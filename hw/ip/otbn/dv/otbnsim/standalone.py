#!/usr/bin/env python3
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
# Modified by Authors of "Towards ML-KEM & ML-DSA on OpenTitan" (https://eprint.iacr.org/2024/1192).
# Copyright "Towards ML-KEM & ML-DSA on OpenTitan" Authors.
# Modified by Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
# "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
# (https://eprint.iacr.org/2025/2028)
# Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham.


import os
import argparse
import sys

def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument('elf')
    parser.add_argument('-v', '--verbose', action='store_true')
    parser.add_argument('--dump-rtl-sim', action="store_true")
    parser.add_argument(
        '--bnmulv_version_id',
        type=str,
        default='0',
        help=("specify the version of bnmulv.")
    )
    parser.add_argument(
        '--dump-dmem',
        metavar="FILE",
        type=argparse.FileType('wb'),
        help=("after execution, write the data memory contents to this file. "
              "Use '-' to write to STDOUT.")
    )
    parser.add_argument(
        '--dump-regs',
        metavar="FILE",
        type=argparse.FileType('w'),
        help=("after execution, write the GPR and WDR contents to this file. "
              "Use '-' to write to STDOUT.")
    )
    parser.add_argument(
        '--dump-stats',
        metavar="FILE",
        type=argparse.FileType('w'),
        help=("after execution, write execution statistics to this file. "
              "Use '-' to write to STDOUT.")
    )

    args = parser.parse_args()

    # Read --bnmulv_version_id given by user and set the os variable BNMULV_VER.
    # Since all of the dependencies depends on isa.py, we need to set
    # the environment variable first before importing them.
    os.environ['BNMULV_VER'] = args.bnmulv_version_id
    from sim.stats import ExecutionStatAnalyzer
    from sim.standalonesim import StandaloneSim
    from sim.load_elf import load_elf

    collect_stats = args.dump_stats is not None

    sim = StandaloneSim()
    exp_end_addr = load_elf(sim, args.elf, args.dump_rtl_sim)
    key0 = int((str("deadbeef") * 12), 16)
    key1 = int((str("baadf00d") * 12), 16)
    sim.state.wsrs.set_sideload_keys(key0, key1)

    sim.state.ext_regs.commit()

    sim.start(collect_stats)
    sim.run(verbose=args.verbose, dump_file=args.dump_regs)

    if exp_end_addr is not None:
        if sim.state.pc != exp_end_addr:
            print('Run stopped at PC {:#x}, but _expected_end_addr was {:#x}.'
                  .format(sim.state.pc, exp_end_addr),
                  file=sys.stderr)
            return 1

    if args.dump_dmem is not None:
        args.dump_dmem.write(sim.dump_data())

    if collect_stats:
        assert sim.stats is not None
        stat_analyzer = ExecutionStatAnalyzer(sim.stats, args.elf)
        args.dump_stats.write(stat_analyzer.dump())

    return 0


if __name__ == "__main__":
    sys.exit(main())
