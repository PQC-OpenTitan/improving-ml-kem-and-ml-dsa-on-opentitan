#!/usr/bin/env python3

# This script is for running RTL-ISS tests, including: build software, build simulation, run
# simulation and checks if RTL trace matches ISS trace. A BNMULV_VER must be given via
# --bnmulv_version_id.

import os
import sys
import argparse
import subprocess
from pathlib import Path


def print_info(s):
    """Print info or error message
    """
    s_split = s.split(':', 1)
    if s_split[0] == 'ERROR':
        s_split[0] = f'\033[1;31m{s_split[0]}\033[0m'
    if s_split[0] == 'INFO':
        s_split[0] = f'\033[1;32m{s_split[0]}\033[0m'
    s_split[1] = f'\033[1m{s_split[1]}\033[0m'

    info = ': '.join(s_split)
    print(info)


def fusesoc_build(flags, mac_adder, alu_adder, verbose):
    """Build Verilated model with FuseSoc command and given flags
    """
    cmd = 'fusesoc --cores-root=. run --target=sim --setup --build '
    cmd += flags
    cmd += '--mapping=lowrisc:prim_generic:all:0.1 lowrisc:ip:otbn_top_sim '
    cmd += f'--MAC_ADDER {mac_adder} '
    cmd += f'--ALU_ADDER {alu_adder} '
    cmd += f'--make_options="-j{os.cpu_count()}"'
    if verbose:
        print_info(f'INFO: Running command {cmd}')

    subprocess.run(cmd, shell=True, check=True)


def bin_build(target, verbose):
    """Run bazel build on a given target
    """
    cmd = f'./bazelisk.sh build --copt="-DRTL_ISS_TEST" {target}'
    if verbose:
        print_info(f'INFO: Running command {cmd}')

    subprocess.run(cmd, shell=True, check=True)


def elf_build(target):
    """Create elf file name from test target name
    """
    test_elf = target.replace(':', '/')
    test_elf = test_elf.replace('//', 'bazel-bin/')
    test_elf = test_elf + '.elf'

    return test_elf


def exp_build(target):
    """Create exp file name from test target name
    """
    test_exp = target.replace(':', '/')
    test_exp = test_exp.replace('//', '')
    test_exp = test_exp.replace('_test', '_expected')
    test_exp = test_exp + '.txt'

    return test_exp


def file_to_list(filename):
    """Put content of file to a list
    """
    # For smoke_test.s, the corresponding smoke_expected file is should be smoke_expected_ver*.txt.
    # However, it should be the same for different bnmulv_ver so we only smoke_expected.txt
    if 'smoke/smoke_expected' in filename:
        filename = 'hw/ip/otbn/dv/smoke/smoke_expected.txt'

    with open(filename, 'r') as f:
        lines = [line.strip() for line in f]

    return lines


def test_run(elf, repo_top, verbose):#
    """Run RTL-ISS test on built Verilated model
    """
    cmd = (
        f'cd {repo_top} && '
        './build/lowrisc_ip_otbn_top_sim_0.1/sim-verilator/Votbn_top_sim '
        f'--load-elf={elf}'
    )
    if verbose:
        print_info(f'INFO: Running command {cmd}')

    results = subprocess.run(cmd, stdout=subprocess.PIPE, text=True, shell=True, check=True)
    actual = results.stdout.strip().split('\n')

    # "actual" is a list of actual outputs from "Call stack:" to "w31 | ..."
    return actual[7:-8]


def target_list(bnmulv_ver, verbose):
    """List supported test targets
    """
    targets = []
    query_cmd = (
        f"./bazelisk.sh query 'filter(.*_test_ver{bnmulv_ver}, "
        "kind(otbn_binary, //sw/otbn/crypto/tests/mlkem/...))' "
        "&& "
        f"./bazelisk.sh query 'filter(.*_test_ver{bnmulv_ver}, "
        "kind(otbn_binary, //sw/otbn/crypto/tests/mldsa/...))' "
        "&& "
        f"./bazelisk.sh query 'filter(.*_test_ver{bnmulv_ver}, "
        "kind(otbn_binary, //hw/ip/otbn/dv/smoke:*))' "
    )
    if bnmulv_ver != 0:
        query_cmd += (
            "&& "
            "./bazelisk.sh query 'filter(.*,"
            f"kind(otbn_binary, //hw/ip/otbn/dv/smoke/bnmulv_ver{bnmulv_ver}:*))' "
        )
    else:
        query_cmd += (
            "&& "
            "./bazelisk.sh query 'filter(.*, kind(otbn_binary, //sw/otbn/crypto/tests/isa_ext:*))'"
        )
    if verbose:
        print_info(f'INFO: {query_cmd}')
    results = subprocess.run(query_cmd, stdout=subprocess.PIPE, text=True, shell=True, check=True)
    targets = results.stdout.strip().split('\n')

    return targets


def main() -> int:
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawTextHelpFormatter
    )
    parser.add_argument(
        '-v', '--verbose',
        action="store_true",
        help=("Print out executed commands")
    )
    parser.add_argument(
        '-ver', '--bnmulv_version_id',
        type=int,
        metavar="BNMULV_VER",
        default=0,
        help=(
            "Specify the version of BNMULV for Verilator simulation and tests. This must be given.\n"
            " Supported versions are:\n"
            "- 0: Baseline design from paper: Towards ML-KEM and ML-DSA on OpenTitan\n"
            "- 1: BNMULV without ACCH\n"
            "- 2: BNMULV with ACCH\n"
            "- 3: BNMULV with ACCH and conditional subtraction")
    )
    parser.add_argument(
        '-m', '--mac_adder',
        type=str,
        metavar="MAC_ADDER",
        default="buffer_bit",
        help=(
            "Specify the adder to be used in OTBN's BN-MAC. Only used if BNMULV_VER != 0.\n"
            "Supported adders are (must be given in exact format):\n"
            "- buffer_bit (default)\n"
            "- brent_kung\n"
            "- sklansky\n"
            "- kogge_stone\n"
            "- csa_carry4")
    )
    parser.add_argument(
        '-a', '--alu_adder',
        type=str,
        metavar="ALU_ADDER",
        default="buffer_bit",
        help=(
            "Specify the adder to be used in OTBN's BN-ALU. Only used if BNMULV_VER != 0.\n"
            "Supported adders are (must be given in exact format):\n"
            "- buffer_bit (default)\n"
            "- brent_kung\n"
            "- sklansky\n"
            "- kogge_stone\n"
            "- csa_carry4")
    )
    parser.add_argument(
        '-l', '--list_target',
        action="store_true",
        help=("List all supported test targets.")
    )
    parser.add_argument(
        '-t', '--test_target',
        type=str,
        metavar="TEST_TARGET",
        help=("Specify a bazel test target to run RTL-ISS test.")
    )
    parser.add_argument(
        '-s', '--skip_verilator_build',
        action="store_true",
        help=("Skip Verilator build for otbn_top_sim.")
    )

    args = parser.parse_args()

    verbose = args.verbose

    # Set repo_top = $REPO_TOP
    repo_top = Path.cwd()

    # If BNMULV_VER is not given, exit.
    bnmulv_ver = args.bnmulv_version_id
    if bnmulv_ver is None:
        print_info('ERROR: BNMULV_VER is not given. Please provide a version with --bnmulv_version_id')
        return 1
    elif bnmulv_ver != 0:
        print_info(f'INFO: Set BNMULV_VER = {bnmulv_ver}')
        flags  = f'--flag=bnmulv_ver{bnmulv_ver} '
        if args.mac_adder == 'csa_carry4' or args.alu_adder == 'csa_carry4':
            flags += '--flag=carry4 '
    elif bnmulv_ver == 0:
        print_info(f'INFO: Set BNMULV_VER = {bnmulv_ver}')
        flags = '--flag=towards '
    else:
        print_info(f'ERROR: BNMULV_VER = {bnmulv_ver} is not valid. Valid versions are 0,1,2,3')
        return 1

    # List supported test targets.
    targets = target_list(bnmulv_ver, verbose)
    max_len = max(len(target) for target in targets)
    if args.list_target:
        print_info('INFO: List supported targets')
        print('\n'.join(targets))
        return 0

    # Build Verilated model
    if args.skip_verilator_build is True:
        print_info('INFO: Skip Verilator build of otbn_top_sim')
    else:
        fusesoc_build(flags, args.mac_adder, args.alu_adder, verbose)

    # Run Verilated model
    if args.test_target is not None:
        print(f'\033[1;34m=========================== Run {args.test_target} ===========================\033[0m')
        bin_build(args.test_target, verbose)
        test_elf = elf_build(args.test_target)
        actual = test_run(test_elf, repo_top, verbose)

        # For smoke tests, we compare actual results with expected results.
        if 'smoke' in args.test_target:
            test_exp = exp_build(args.test_target)
            expected = file_to_list(test_exp)
            if actual != expected:
                for i, (act, exp) in enumerate(zip(actual, expected)):
                    if act != exp:
                        print_info(f'ERROR: Mismatch as index {i}: {act} != {exp}')
                print_info('ERROR: Actual outputs do not match expected outputs')
                return 1
        print_info(f'INFO: RTL matches ISS for {args.test_target} \U00002705')
    else:
        for target in targets:
            print(f'\033[1;34m=========================== Run {target} ===========================\033[0m')
            bin_build(target, verbose)
            elf = elf_build(target)
            actual = test_run(elf, repo_top, verbose)

            # For smoke tests, we compare actual results with expected results.
            if 'smoke' in target:
                test_exp = exp_build(target)
                expected = file_to_list(test_exp)
                if actual != expected:
                    for i, (act, exp) in enumerate(zip(actual, expected)):
                        if act != exp:
                            print_info(f'ERROR: Mismatch as index {i}: {act} != {exp}')
                    print_info('ERROR: Actual outputs do not match expected outputs')
                    return 1

        print('INFO: RTL matches ISS for the following tests')
        print('\n'.join(f"{target.ljust(max_len)} \U00002705" for target in targets))


if __name__ == "__main__":
    sys.exit(main())
