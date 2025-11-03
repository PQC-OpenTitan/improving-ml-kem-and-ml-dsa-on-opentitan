#!/usr/bin/env python3
# Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
# "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
# (https://eprint.iacr.org/2025/2028)
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import sys
import re
import argparse
import subprocess
import time

from pathlib import Path
from itertools import islice
from tqdm import tqdm

REPO_TOP = Path.cwd()
STACK_SIZE_MLKEM = 20000
STACK_SIZE_MLDSA = 112000
STACK_SIZE_MLDSA_SIGN = {'44': 51200, '65': 78848, '87': 120832}

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


def target_list(scheme, verbose):
    """List supported test targets
    """
    targets = []
    query_cmd = (
        "./bazelisk.sh query 'filter(.*_ver0, "
        f"kind(otbn_sim_test, //sw/otbn/crypto/tests/{scheme}/...))' "
        "&& "
        "./bazelisk.sh query 'filter(.*_ver1, "
        f"kind(otbn_sim_test, //sw/otbn/crypto/tests/{scheme}/...))' "
        "&& "
        "./bazelisk.sh query 'filter(.*_ver2, "
        f"kind(otbn_sim_test, //sw/otbn/crypto/tests/{scheme}/...))' "
        "&& "
        "./bazelisk.sh query 'filter(.*_ver3, "
        f"kind(otbn_sim_test, //sw/otbn/crypto/tests/{scheme}/...))' "
    )

    if verbose:
        print_info(f'INFO: {query_cmd}')
    results = \
        subprocess.run(query_cmd, stdout=subprocess.PIPE, text=True, shell=True, check=True)
    targets = results.stdout.strip().split('\n')

    if scheme == 'mlkem':
        # Remove false_dec targets in ML-KEM list
        targets = [target for target in targets if 'false_decap' not in target]
        # Reverse ML-KEM list to have order keypair --> encap --> decap
        targets.reverse()
        # Sort targets based on the number in their name 512 --> 768 -- 1024
        for i in range(0, 36, 9):
            targets[i : i + 9] = \
                sorted(targets[i : i + 9], key=lambda s: int(re.search(r'\d+', s).group()))
        # Sort targets based on _ver: ver0 --> ver1 --> ver2 --> ver3
        targets = sorted(targets, key=lambda s: int(re.search(r'_ver(\d+)', s).group(1)))

    if scheme == 'mldsa':
        # Remove poly_dilithium target in ML-DSA list
        targets = [target for target in targets if 'poly' not in target]

    return targets


def dict_print(stacks):
    """Pretty-print a dictionary
    """
    max_len_keys = max(len(k) for k in stacks.keys())
    for k, v in stacks.items():
        print(f'{k.ljust(max_len_keys)} : {v}')


def latex_print(stacks, filename, schemes):
    """Export a .tex file including stack usage
    """
    # Check if file exists, otherwise create one in REPO_TOP
    filepath = Path(filename)
    if filepath.exists():
        print_info(f'INFO: {filename} exists and new data will be appended')
    else:
        print_info(f'INFO: {filename} does not exist and will be created')
        filepath.touch(exist_ok=True)

    # Remove first item
    del stacks['TARGET']

    # This is specific for only two schemes: ML-KEM and ML-DSA.
    if schemes:
        start = 0
        for scheme in schemes:
            bnmulv_ver = 0
            for i in range(start, start + 36, 9):
                with filepath.open("a") as f:
                    f.write(f'% {scheme.upper()} stack usage for BNMULV_VER = {bnmulv_ver} %\n')
                bnmulv_ver += 1
                for k, v in islice(stacks.items(), i, i + 9):
                    k_split = k.rsplit(':', 1)
                    var_name = k_split[1].replace('_', '-')
                    var_name = var_name + '-stack'
                    var = f'\\DefineVar{{{var_name}}}{{{v}}}\n'
                    with filepath.open("a") as f:
                        f.write(var)
            start += 36
    else:
        for k, v in stacks.items():
            k_split = k.rsplit(':', 1)
            var_name = k_split[1].replace('_', '-')
            var_name = var_name + '-stack'
            var = f'\\DefineVar{{{var_name}}}{{{v}}}\n'
            with filepath.open("a") as f:
                f.write(var)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Please provide at least one argument as follows to run this script (except -v)",
        formatter_class=argparse.RawTextHelpFormatter
    )
    parser.add_argument(
        '-v', '--verbose',
        action="store_true",
        help=("Print out executed commands")
    )
    parser.add_argument(
        '-t', '--test_target',
        type=str,
        metavar="[TEST_TARGET, STACK_SIZE]",
        help=(
            "Specify a bazel 'otbn_sim_test' target and its stack size to get its stack usage\n"
            "The BNMULV_VER must be given in the target 'copts' field as '--bnmulv_version_id='\n" \
            "Otherwise, all targets will be built with BNMULV_VER = 0")
    )
    parser.add_argument(
        '-ts', '--test_target_stack_size',
        type=int,
        metavar="STACK_SIZE",
        help=("Specify the stack size of the given target to get its stack usage")
    )
    parser.add_argument(
        '--mlkem',
        action="store_true",
        help=("Get stack usage for all ML-KEM targets. Not used with --test_target")
    )
    parser.add_argument(
        '--mldsa',
        action="store_true",
        help=("Get stack usage for all ML-DSA targets. Not used with --test_target")
    )
    parser.add_argument(
        '-l', '--list_target',
        action="store_true",
        help=("List all supported test targets")
    )
    parser.add_argument(
        '--output_latex',
        action="store_true",
        help=("If given, output stack usage in a LaTex-formatted variables '\\DefineVar' \n"
              "Must be used with --latex_filename")
    )
    parser.add_argument(
        '--latex_filename',
        type=str,
        metavar="LATEX_FILENAME",
        help=("Output file of --output_latex option. If file does not exist, it will be created\n"
              "Must be given with full path")
    )

    # Start timer
    start_time = time.perf_counter()

    args = parser.parse_args()

    verbose = args.verbose

    # If no --test_target or --mlkem or --mldsa is not given, abort
    if not args.test_target and not args.mlkem and not args.mldsa and not args.list_target:
        print_info('ERROR: Please provide at least one of --test_target or --mlkem or --mldsa')
        return 1

    # Abort if --test_target is not given with --test_target_stack_size
    if args.test_target and not args.test_target_stack_size:
        print_info('ERROR: --test_target must be used with --test_target_stack_size')
        return 1

    # Abort if --test_target is given with --mlkem or --mldsa
    if args.test_target and (args.mlkem or args.mldsa):
        print_info('ERROR: --test_target cannot be used with --mlkem or --mldsa')
        return 1

    # Abort if --output_latex is given without --latex_filename
    if args.output_latex and not args.latex_filename:
        print_info('ERROR: --output_latex must be used with --latex_filename')
        return 1

    # Create a new file for logging stack usage
    filename = f'{REPO_TOP}/stack_benchmark.txt'
    filepath = Path(filename)
    filepath.touch(exist_ok=True)

    # List supported targets
    targets = []
    schemes = []
    if args.test_target:
        targets += [args.test_target]
    else:
        if args.mlkem:
            targets += target_list('mlkem', verbose)
            schemes += ['mlkem']
        if args.mldsa:
            targets += target_list('mldsa', verbose)
            schemes += ['mldsa']

    if args.list_target:
        print_info('INFO: List supported targets')
        print('\n'.join(targets))
        return 0

    # Assign correct STACK_SIZE for each target
    targets_dict = {}
    if args.test_target:
        targets_dict[args.test_target] = args.test_target_stack_size
    else:
        for target in targets:
            if 'mlkem' in target:
                targets_dict[target] = STACK_SIZE_MLKEM
            if 'mldsa' in target:
                targets_dict[target] = STACK_SIZE_MLDSA
                if 'sign' in target:
                    if 'mldsa44' in target:
                        targets_dict[target] = STACK_SIZE_MLDSA_SIGN['44']
                    elif 'mldsa65' in target:
                        targets_dict[target] = STACK_SIZE_MLDSA_SIGN['65']
                    elif 'mldsa87' in target:
                        targets_dict[target] = STACK_SIZE_MLDSA_SIGN['87']

    # Run a bazel test target to get stack usage. We must add command argument --action_env since
    # bazel test is sandboxed, and thus insn_ver*.py doesn't see "stack_benchmark.txt" created in
    # REPO_TOP. Then, read the result logged in {REPO_TOP}/stack_benchmark.txt.
    stacks = {'TARGET': 'STACK USAGE'}
    for target in tqdm(targets):
        print_info(f'INFO: Get stack usage for {target}')
        cmd = (
            f'./bazelisk.sh test --action_env=REPO_TOP={REPO_TOP} --action_env=STACK_BENCH=1 '
            f'--action_env=STACK_SIZE={targets_dict[target]} --sandbox_writable_path={REPO_TOP} '
            f'--cache_test_results=no {target}'
        )
        if verbose:
            print_info(f'INFO: Running command {cmd}')
        subprocess.run(cmd, shell=True, check=True)

        # Read out stack usage
        stack = int(filepath.read_text().strip())

        # Add stack to stacks
        stacks[target] = stack

        # Write 0 to stack_benchmark.txt
        filepath.write_text('0')
        print_info(f'INFO: Reset to 0 in {filename}')

    # Once done, we delete stack_benchmark.txt
    filepath.unlink()
    print_info(f'INFO: {filename} deleted')

    # Print out stacks
    if not args.output_latex:
        print_info('INFO: Print out stack usage')
        dict_print(stacks)
        return 0
    else:
        print_info('INFO: Create LaTex file')
        latex_print(stacks, args.latex_filename, schemes)

    # End timer
    end_time = time.perf_counter()
    elapsed = end_time - start_time
    print_info(f'INFO: Stack benchmarking done in {elapsed:.4f} seconds')


if __name__ == "__main__":
    sys.exit(main())
