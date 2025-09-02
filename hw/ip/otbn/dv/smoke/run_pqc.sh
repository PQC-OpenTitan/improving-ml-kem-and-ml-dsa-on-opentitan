#!/bin/bash
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Run ML-KEM and ML-DSA tests (build software, build simulation, run simulation
# and checks if RTL trace matches ISS trace)

while getopts 'hst:v:l' OPTION; do
  case "$OPTION" in
    h)
      echo "This script is for running ML-{KEM,DSA} tests with the old or new BNMULV instruction."
      echo "usage: hw/ip/otbn/dv/smoke/run_pqc.sh [-h] [-t TEST_TARGET] [-s] [-v BNMULV_VER]"
      echo ""
      echo "options:"
      echo "  -h               Show help message and exit"
      echo "  -t TEST_TARGET   Specify a bazel test target in sw/otbn/crypto/tests/{mlkem,mldsa}/BUILD"
      echo "                   The supported targets start with 'otbn_{mlkem,dsa}*_'"        
      echo "  -l               List all supported test targets"  
      echo "  -s               Skip Verilator build for otbn_top_sim"
      echo "  -v BNMULV_VER    Specify the version of BNMULV for simulation with Verilator and tests"
      echo "                   This is required for ML-KEM and ML-DSA tests."
      echo "                   Supported versions are:"
      echo "                   - 0: Baseline design from paper: Towards ML-KEM & ML-DSA on OpenTitan"
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
      TEST_TARGET="$OPTARG"
      echo "-t is given: Run $TEST_TARGET"
      ;;
    l)
      echo "-l is given: List all supported test targets"
      LIST_TEST=1
      ;;
    v)
      BNMULV_VER="$OPTARG"
      echo "-v is given: Simulate otbn_top_sim with BNMULV_VER = $BNMULV_VER"
      ;;
    ?)
      echo "run_pqc: Unrecognized option: '$OPTARG'"
      echo "Use -h to get more information" >&2
      exit 1
      ;;
  esac
done

fail() {
    echo >&2 "RUN_PQC FAILURE: $*"
    exit 1
}

set -o pipefail
set -e

if [[ -z "$BNMULV_VER" ]]; then
  fail "BNMULV_VER is not set, please specify it with -v option."
fi

SCRIPT_DIR="$(dirname "$(readlink -e "${BASH_SOURCE[0]}")")"
UTIL_DIR="$(readlink -e "$SCRIPT_DIR/../../../../../util")" || \
  fail "Can't find OpenTitan util dir"

source "$UTIL_DIR/build_consts.sh"

# Filter out otbn_binary build targets with specified BNMULV_VER
MLKEM_QUERY_CMD="./bazelisk.sh query filter(.*_ver$BNMULV_VER, kind(otbn_binary, //sw/otbn/crypto/tests/mlkem/...))"
MLDSA_QUERY_CMD="./bazelisk.sh query filter(.*_ver$BNMULV_VER, kind(otbn_binary, //sw/otbn/crypto/tests/mldsa/...))"
readarray -t MLKEM_TARGETS < <($MLKEM_QUERY_CMD)
readarray -t MLDSA_TARGETS < <($MLDSA_QUERY_CMD) 
MLKEM_TARGETS_SORTED=($(sort -f <<<"${MLKEM_TARGETS[*]}"))
MLDSA_TARGETS_SORTED=($(sort -f <<<"${MLDSA_TARGETS[*]}"))

if [[ ! -z "$LIST_TEST" ]]; then
  echo "For ML-KEM:"
  $MLKEM_QUERY_CMD
  echo "For ML-DSA:"
  $MLDSA_QUERY_CMD
  exit 1
fi

if [[ -z "$TEST_TARGET" ]]; then
  
  tests=${MLKEM_TARGETS_SORTED[@]}
  tests+=" ${MLDSA_TARGETS_SORTED[@]}"
  echo "No target given, run for all."
else
  tests=($TEST_TARGET)
  echo "Running test for $tests"
fi

if [[ -z "$SKIP_VERILATOR_BUILD" ]]; then
  if [[ "$BNMULV_VER" -eq 0 ]]; then
    # For BNMULV_VER == 0 means old design in Towards paper.
    echo "Building Verilator model of otbn_top_sim with BNMULV_VER = $BNMULV_VER..."
    (cd $REPO_TOP;
    fusesoc --cores-root=. run --target=sim --setup --build \
        --flag +old_adder \
        --flag +old_mac \
        --mapping=lowrisc:prim_generic:all:0.1 lowrisc:ip:otbn_top_sim \
        --make_options="-j$(nproc)" || fail "HW Sim build failed")
  else
    # OTBN's BN-ALU adders are set to buffer-bit adders by default.
    # To use old adder by Towards paper, please add "--flag +old_adder" to the command below.
    echo "Building Verilator model of otbn_top_sim with BNMULV_VER = $BNMULV_VER..."
    (cd $REPO_TOP;
    fusesoc --cores-root=. run --target=sim --setup --build \
        --flag +bnmulv_ver$BNMULV_VER \
        --mapping=lowrisc:prim_generic:all:0.1 lowrisc:ip:otbn_top_sim \
        --make_options="-j$(nproc)" || fail "HW Sim build failed")
    echo ""
  fi
else
  echo -e "\e[1;33mWARNING: skipping verilator build, because you set -s\e[0m"
  echo ""
fi

RUN_LOG=`mktemp`
readonly RUN_LOG
# shellcheck disable=SC2064 # The RUN_LOG tempfile path should not change
trap "rm -rf $RUN_LOG" EXIT

for test in ${tests[@]}
do
  echo -e "\e[1;38;5;94m===================== Testing $test =====================\e[0m"

  # Construct elf file name from target name
  test_name=${test#//}
  test_path=${test_name/:/\/}
  test_elf="bazel-bin/$test_path.elf"

  # Build the target to obtain elf files
  ./bazelisk.sh build --copt="-DRTL_ISS_TEST" $test || fail "Bazel build failed for $test"
  echo ""

  # Run the simulation with the elf
  $REPO_TOP/build/lowrisc_ip_otbn_top_sim_0.1/sim-verilator/Votbn_top_sim \
  --load-elf=$test_elf | tee $RUN_LOG

  if [ $? -ne 0 ]; then
    fail -e "\e[1;31mSimulator run failed for $test\e[0m"
  else
    echo -e "\e[1;32mRTL matches ISS for $test\e[0m"
    echo ""
  fi
done