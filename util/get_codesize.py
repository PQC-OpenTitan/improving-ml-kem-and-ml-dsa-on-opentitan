#!/usr/bin/env python3

import sys
import re
import argparse
import subprocess
import time
import csv
from tqdm import tqdm
from tabulate import tabulate

STACK_SIZE = 20000

MLKEM512_CRYPTO_PUBLICKEYBYTES = 800
MLKEM512_CRYPTO_SECRETKEYBYTES = 1632
MLKEM512_CRYPTO_CIPHERTEXTBYTES = 768
MLKEM768_CRYPTO_PUBLICKEYBYTES = 1184
MLKEM768_CRYPTO_SECRETKEYBYTES = 2400
MLKEM768_CRYPTO_CIPHERTEXTBYTES = 1088
MLKEM1024_CRYPTO_PUBLICKEYBYTES = 1568
MLKEM1024_CRYPTO_SECRETKEYBYTES = 3168
MLKEM1024_CRYPTO_CIPHERTEXTBYTES = 1568
MLKEM_CRYPTO_BYTE = 32
MLKEM_COINS_KEYPAIR_BYTES = 64
MLKEM_COINS_ENCAP_BYTES = 32
MLKEM_IO_CONST = MLKEM_CRYPTO_BYTE*2 + MLKEM_COINS_KEYPAIR_BYTES + MLKEM_COINS_ENCAP_BYTES

MLDSA44_CRYPTO_PUBLICKEYBYTES = 1312
MLDSA44_CRYPTO_SECRETKEYBYTES = 2560
MLDSA44_CRYPTO_BYTES = 2420 + 12 # for 32B alignment
MLDSA65_CRYPTO_PUBLICKEYBYTES = 1952
MLDSA65_CRYPTO_SECRETKEYBYTES = 4032
MLDSA65_CRYPTO_BYTES = 3309 + 19 # for 32B alignment
MLDSA87_CRYPTO_PUBLICKEYBYTES = 2592
MLDSA87_CRYPTO_SECRETKEYBYTES = 4896
MLDSA87_CRYPTO_BYTES = 4627 + 13 # for 32B alignment
MLDSA_MSG_BYTES = 3196 + 4 # for 32B alignment
MLDSA_CTX_BYTES = 32
MLDSA_ZETA_BYTES = 32
MLDSA_RESULT_BYTES = 32
MLDSA_IO_CONST = MLDSA_MSG_BYTES + MLDSA_CTX_BYTES + MLDSA_ZETA_BYTES + MLDSA_RESULT_BYTES

def elf_build(target):
    """Create elf file name from test target name
    """
    test_elf = target.replace(':', '/')
    test_elf = test_elf.replace('//', 'bazel-bin/')
    test_elf = test_elf + '.elf'

    return test_elf


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
        "./bazelisk.sh query 'filter(.*_code_size_ver0, "
        f"kind(otbn_binary, //sw/otbn/crypto/tests/{scheme}/...))' "
        "&& "
        "./bazelisk.sh query 'filter(.*_code_size_ver1, "
        f"kind(otbn_binary, //sw/otbn/crypto/tests/{scheme}/...))' "
        "&& "
        "./bazelisk.sh query 'filter(.*_code_size_ver2, "
        f"kind(otbn_binary, //sw/otbn/crypto/tests/{scheme}/...))' "
        "&& "
        "./bazelisk.sh query 'filter(.*_code_size_ver3, "
        f"kind(otbn_binary, //sw/otbn/crypto/tests/{scheme}/...))' "
    )

    if verbose:
        print_info(f'INFO: {query_cmd}')
    results = \
        subprocess.run(query_cmd, stdout=subprocess.PIPE, text=True, shell=True, check=True)
    targets = results.stdout.strip().split('\n')
    targets = sorted(targets, key=lambda x: int(re.search(r'\d+', x).group()))
    # In case we want NOLD codesize, uncomment the following lines
    # for i in range(0, n, 7):
    #     targets[i + 0], targets[i + 1] = targets[i + 1], targets[i + 0]
    #     targets[i + 2], targets[i + 3] = targets[i + 3], targets[i + 2]
    #     targets[i + 4], targets[i + 5] = targets[i + 5], targets[i + 4]

    targets = [t for t in targets if 'nold' not in t]

    # Sort so that ver0_base is before _ver0
    n = len(targets)
    for i in range(0, n, 5):
        targets[i], targets[i + 1] = targets[i + 1], targets[i]

    return targets


def output_csv(cs, outdir, round_const):
    filename = outdir + "/codesize.csv"

    del cs[0]
    cs_csv = [[
        "Level", "Platform", "Text MLKEM", "Ratio MLKEM", "Const MLKEM", "IO MLKEM",
        "Text MLDSA", "Ratio MLDSA", "Const MLDSA", "IO MLDSA"
    ]]
    n = len(cs)
    # Change list to list of lists
    for i in range(n):
        if 'ver1' in cs[i][0]:
            if 'nold' in cs[i][0]:
                platform = "\\otbnmulvnold"
            else:
                platform = "\\otbnmulv"
        elif 'ver2' in cs[i][0]:
            if 'nold' in cs[i][0]:
                platform = "\\otbnmulvacchnold"
            else:
                platform = "\\otbnmulvacch"
        elif 'ver3' in cs[i][0]:
            platform = "\\otbnmulvacchcond"
        else:
            if 'base' in cs[i][0]:
                platform = "\\otbnbase"
            else:
                platform = "\\otbntw"
        if 'mlkem512' in cs[i][0]:
            level = "\\mlkemlow"
        elif 'mlkem768' in cs[i][0]:
            level = "\\mlkemmid"
        elif 'mlkem1024' in cs[i][0]:
            level = "\\mlkemhigh"
        elif 'mldsa44' in cs[i][0]:
            level = "\\mldsalow"
        elif 'mldsa65' in cs[i][0]:
            level = "\\mldsamid"
        elif 'mldsa87' in cs[i][0]:
            level = "\\mldsahigh"
        cs[i][2] = f"$\\times${cs[i][2]:.{round_const}f}"
        data = [level] + [platform] + cs[i][1:]
        cs_csv.append(data)

    # Remove repeated Level
    for i in range(1, n // 2, 5):
        cs_csv[i] += cs_csv[i + 15][2:] # Append ML-DSA code size to ML-KEM code size
        cs_csv[i + 1] += cs_csv[i + 16][2:] # Append ML-DSA code size to ML-KEM code size
        cs_csv[i + 2] += cs_csv[i + 17][2:] # Append ML-DSA code size to ML-KEM code size
        cs_csv[i + 3] += cs_csv[i + 18][2:] # Append ML-DSA code size to ML-KEM code size
        cs_csv[i + 4] += cs_csv[i + 19][2:] # Append ML-DSA code size to ML-KEM code size

    cs_csv = cs_csv[:16]

    # Print to stdout
    writer = csv.writer(sys.stdout)
    writer.writerows(cs_csv)

    # Write to output file
    with open(filename, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerows(cs_csv)


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
        '--mlkem',
        action="store_true",
        help=("Get code size for all ML-KEM targets")
    )
    parser.add_argument(
        '--mldsa',
        action="store_true",
        help=("Get code size for all ML-DSA targets")
    )
    parser.add_argument(
        '--compare',
        action="store_true",
        help=("Give code size improvement of BNMULV_VER{0_BASE,1,2,3} vs BNMULV_VER0")
    )
    parser.add_argument(
        '-l', '--list_target',
        action="store_true",
        help=("List all supported build targets")
    )
    parser.add_argument(
        '--csv_outdir',
        type=str,
        metavar="CSV_OUTDIR",
        help=("Directory of output csv file. If file does not exist, it will be created\n"
              "Must be given with full path")
    )

    # Start timer
    start_time = time.perf_counter()

    args = parser.parse_args()

    verbose = args.verbose

    # If --mlkem or --mldsa is not given, abort
    if not args.mlkem and not args.mldsa:
        print_info('ERROR: Please provide at least one of --mlkem or --mldsa')
        return 1

    # List supported targets
    targets = []
    if args.mlkem:
        targets += target_list('mlkem', verbose)
    if args.mldsa:
        targets += target_list('mldsa', verbose)

    if args.list_target:
        print_info('INFO: List supported targets')
        print('\n'.join(targets))
        return 0

    # Compute IO_SIZE
    mlkem512_io_size = MLKEM512_CRYPTO_PUBLICKEYBYTES + MLKEM512_CRYPTO_SECRETKEYBYTES + \
        MLKEM512_CRYPTO_CIPHERTEXTBYTES + MLKEM_IO_CONST
    mlkem768_io_size = MLKEM768_CRYPTO_PUBLICKEYBYTES + MLKEM768_CRYPTO_SECRETKEYBYTES + \
        MLKEM768_CRYPTO_CIPHERTEXTBYTES + MLKEM_IO_CONST
    mlkem1024_io_size = MLKEM1024_CRYPTO_PUBLICKEYBYTES + MLKEM1024_CRYPTO_SECRETKEYBYTES + \
        MLKEM1024_CRYPTO_CIPHERTEXTBYTES + MLKEM_IO_CONST
    mldsa44_io_size = MLDSA44_CRYPTO_PUBLICKEYBYTES + MLDSA44_CRYPTO_SECRETKEYBYTES + \
        MLDSA44_CRYPTO_BYTES + MLDSA_IO_CONST
    mldsa65_io_size = MLDSA65_CRYPTO_PUBLICKEYBYTES + MLDSA65_CRYPTO_SECRETKEYBYTES + \
        MLDSA65_CRYPTO_BYTES + MLDSA_IO_CONST
    mldsa87_io_size = MLDSA87_CRYPTO_PUBLICKEYBYTES + MLDSA87_CRYPTO_SECRETKEYBYTES + \
        MLDSA87_CRYPTO_BYTES + MLDSA_IO_CONST

    # Build a bazel otbn_binary target, then run "size" for the "elf" file located in bazel-bin to
    # get code size.
    cs = [['TARGET', 'TEXT SIZE (bytes)', 'CONST_SIZE (bytes)', 'IO_SIZE (bytes)']]
    for target in tqdm(targets):
        # Run bazel build to obtain elf file in bazel-bin
        print_info(f'INFO: Get code size for {target}')
        cmd = f'./bazelisk.sh build {target}'
        if verbose:
            print_info(f'INFO: Running command {cmd}')
        subprocess.run(cmd, shell=True, check=True)

        # Run size command to get code size
        target_elf = elf_build(target)
        cmd = f'size {target_elf}'
        if verbose:
            print_info(f'INFO: Running command {cmd}')
        results = subprocess.run(cmd, stdout=subprocess.PIPE, text=True, shell=True, check=True)

        # Parse code size from stdout
        results_split = results.stdout.strip().split('\n')
        codesize = results_split[1].split('\t')
        codesize = [cs.strip() for cs in codesize[0:2]]

        # DATA_SIZE = CONST_SIZE + IO_SIZE + STACK_SIZE
        total = int(codesize[1]) - STACK_SIZE
        if 'mlkem512' in target:
            io_size = mlkem512_io_size
        elif 'mlkem768' in target:
            io_size = mlkem768_io_size
        elif 'mlkem1024' in target:
            io_size = mlkem1024_io_size
        elif 'mldsa44' in target:
            io_size = mldsa44_io_size
        elif 'mldsa65' in target:
            io_size = mldsa65_io_size
        else: # 'mldsa87' in target:
            io_size = mldsa87_io_size
        const_size = total - io_size

        # Add code size to cs
        target_cs = [target, int(codesize[0]), const_size, io_size]
        cs.append(target_cs)

    round_const = 2
    # Compare if given --compare
    if args.compare:
        cs[0].insert(2, 'VERX/VER0')
        cs_len = len(cs)
        for i in range(1, cs_len, 5):
            a = cs[i + 1][1]
            cs[i + 1].insert(2, 1)
            b = cs[i][1]
            r = round((b / a), round_const)
            cs[i].insert(2, r)
            for j in range(i + 2, i + 5):
                b = cs[j][1]
                r = round((b / a), round_const)
                cs[j].insert(2, r)

    cs_table = tabulate(cs, missingval="{---}", tablefmt="pipe")
    print(cs_table)

    if args.csv_outdir is not None:
        print_info('INFO: Create CSV file')
        output_csv(cs, args.csv_outdir, round_const)

    # End timer
    end_time = time.perf_counter()
    elapsed = end_time - start_time
    print_info(f'INFO: Code size benchmarking done in {elapsed:.4f} seconds')
    return 0


if __name__ == "__main__":
    sys.exit(main())
