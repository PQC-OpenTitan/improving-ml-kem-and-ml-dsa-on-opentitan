#!/bin/bash
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Runs the OTBN smoke test (builds software, build simulation, runs simulation
# and checks expected output)

while getopts 'hst:v:' OPTION; do
  case "$OPTION" in
    h)
      echo "This script is for running the smoke tests with the new BNMULV instruction."
      echo "usage: hw/ip/otbn/dv/smoke/run_smoke_bnmulv.sh [-h] [-t ASSEMBLY_TEST] [-s] [-bnmulv_version_id BNMULV_VER]"
      echo ""
      echo "options:"
      echo "  -h               Show help message and exit"
      echo "  -t ASSEMBLY_TEST Specify an assembly test for testing in hw/ip/otbn/dv/smoke/bnmulv_ver*"          
      echo "  -s               Skip Verilator build for otbn_top_sim"
      echo "  -v BNMULV_VER    Specify the version of BNMULV for simulation with Verilator and tests"
      echo "                   If not given, original otbn_top_sim will be simulated"
      echo "                   Supported versions are:"
      echo "                   - 1: BNMULV without ACCH"
      echo "                   - 2: BNMULV with ACCH"
      echo "                   - 3: BNMULV with ACCH and conditional subtraction"
      exit 1
      ;;   
    s)
      echo "-s is given: Skip Verilator build"
      SKIP_VERILATOR_BUILD=1
      ;;
    t)
      ASSEMBLY_TEST="$OPTARG"
      echo "-t is given: Run $ASSEMBLY_TEST"
      ;;
    v)
      BNMULV_VER="$OPTARG"
      echo "-v is given: Simulate otbn_top_sim with BNMULV_VER = $BNMULV_VER"
      ;;
    ?)
      echo "run_smoke_bnmulv: Unrecognized option: '$OPTARG'"
      echo "Use -h to get more information" >&2
      exit 1
      ;;
  esac
done

fail() {
    echo >&2 "OTBN SMOKE FAILURE: $*"
    exit 1
}

set -o pipefail
set -e

SCRIPT_DIR="$(dirname "$(readlink -e "${BASH_SOURCE[0]}")")"
UTIL_DIR="$(readlink -e "$SCRIPT_DIR/../../../../../util")" || \
  fail "Can't find OpenTitan util dir"

source "$UTIL_DIR/build_consts.sh"



SMOKE_BIN_DIR=$BIN_DIR/otbn/smoke_test
SMOKE_SRC_DIR=$REPO_TOP/hw/ip/otbn/dv/smoke

mkdir -p $SMOKE_BIN_DIR

if [[ ! -z "$BNMULV_VER" ]]; then
  BNMULV_SMOKE_BIN_DIR=$BIN_DIR/otbn/smoke_test/bnmulv_ver$BNMULV_VER
  BNMULV_SMOKE_SRC_DIR=$REPO_TOP/hw/ip/otbn/dv/smoke/bnmulv_ver$BNMULV_VER
  mkdir -p $BNMULV_SMOKE_BIN_DIR
  BNMULV_TESTS+=" $(ls "$BNMULV_SMOKE_SRC_DIR"/*.s)"
fi

OTBN_UTIL=$REPO_TOP/hw/ip/otbn/util


if [[ -z "$ASSEMBLY_TEST" ]]; then
  tests="$BNMULV_TESTS"
  echo "No test given, run for all."
  echo $tests
else
  tests=($ASSEMBLY_TEST)
  echo "Running test for $tests"
fi

if [[ -z "$SKIP_VERILATOR_BUILD" ]]; then
  if [[ -z "$BNMULV_VER" ]]; then
    echo "Building Verilator model of original otbn_top_sim..."
    (cd $REPO_TOP;
    fusesoc --cores-root=. run --target=sim --setup --build \
        --mapping=lowrisc:prim_generic:all:0.1 lowrisc:ip:otbn_top_sim \
        --make_options="-j$(nproc)" || fail "HW Sim build failed")
  else
    echo "Building Verilator model of otbn_top_sim with BNMULV_VER = $BNMULV_VER..."
    (cd $REPO_TOP;
    fusesoc --cores-root=. run --target=sim --setup --build \
        --flag +bnmulv_ver$BNMULV_VER \
        --mapping=lowrisc:prim_generic:all:0.1 lowrisc:ip:otbn_top_sim \
        --make_options="-j$(nproc)" || fail "HW Sim build failed")
  fi
else
  echo "WARNING: skipping verilator build, because you set -s"
fi

RUN_LOG=`mktemp`
readonly RUN_LOG
# shellcheck disable=SC2064 # The RUN_LOG tempfile path should not change
trap "rm -rf $RUN_LOG" EXIT

echo  "===================== Testing smoke_test.s ====================="

if [[ ! -z "$BNMULV_VER" ]]; then
  $OTBN_UTIL/otbn_as.py --bnmulv_version_id=$BNMULV_VER \
      -o $SMOKE_BIN_DIR/smoke_test.o $SMOKE_SRC_DIR/smoke_test.s || \
      fail "Failed to assemble smoke_test.s"
else
  $OTBN_UTIL/otbn_as.py -o $SMOKE_BIN_DIR/smoke_test.o $SMOKE_SRC_DIR/smoke_test.s || \
      fail "Failed to assemble smoke_test.s"
fi

$OTBN_UTIL/otbn_ld.py -o $SMOKE_BIN_DIR/smoke.elf $SMOKE_BIN_DIR/smoke_test.o || \
    fail "Failed to link smoke_test.o"

timeout 5s \
  $REPO_TOP/build/lowrisc_ip_otbn_top_sim_0.1/sim-verilator/Votbn_top_sim \
  --load-elf=$SMOKE_BIN_DIR/smoke.elf -t | tee $RUN_LOG

if [ $? -eq 124 ]; then
  fail "Simulation timeout"
fi

if [ $? -ne 0 ]; then
  fail "Simulator run failed"
else
  echo "RTL matches ISS for smoke_test.s"
fi

had_diff=0
grep -A 74 "Call Stack:" $RUN_LOG | diff -U3 $SMOKE_SRC_DIR/smoke_expected.txt - || had_diff=1

if [ $had_diff == 0 ]; then
  echo "OTBN SMOKE PASS"
else
  fail "Simulator output does not match expected output"
fi

if [[ ! -z "$BNMULV_VER" ]]; then
  for test in $tests
  do
    echo  "===================== Testing $test ====================="

    test_name="${test##*/}"
    test_o="${test_name/.s/.o}"
    test_elf="${test_name/.s/.elf}"
    test_exp="${test_name/_test.s/_expected.txt}"

    $OTBN_UTIL/otbn_as.py --bnmulv_version_id=$BNMULV_VER -o $BNMULV_SMOKE_BIN_DIR/$test_o $test || \
        fail "Failed to assemble ${test}"
    $OTBN_UTIL/otbn_ld.py -o $BNMULV_SMOKE_BIN_DIR/$test_elf $BNMULV_SMOKE_BIN_DIR/$test_o || \
        fail "Failed to link ${test_o}"

    timeout 5s \
      $REPO_TOP/build/lowrisc_ip_otbn_top_sim_0.1/sim-verilator/Votbn_top_sim \
      --load-elf=$BNMULV_SMOKE_BIN_DIR/$test_elf -t | tee $RUN_LOG

    if [ $? -eq 124 ]; then
      fail "Simulation timeout"
    fi

    if [ $? -ne 0 ]; then
      fail "Simulator run failed"
    else
      echo "RTL matches ISS for $test"
    fi

    had_diff=0
    grep -A 71 "Call Stack:" $RUN_LOG | diff -U3 $BNMULV_SMOKE_SRC_DIR/$test_exp - || had_diff=1

    if [ $had_diff == 0 ]; then
      echo "OTBN SMOKE PASS"
    else
      fail "Simulator output does not match expected output"
    fi
  done
fi