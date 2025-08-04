#!/usr/bin/env python3
# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
# Modified by Authors of "Towards ML-KEM & ML-DSA on OpenTitan" (https://eprint.iacr.org/2024/1192).
# Copyright "Towards ML-KEM & ML-DSA on OpenTitan" Authors.


'''Run a test on the OTBN simulator.'''

import sys
import struct
from enum import IntEnum
from typing import List, Dict, Tuple
from io import StringIO

from hw.ip.otbn.util import otbn_sim_py_shared
from hw.ip.otbn.util.shared.check import CheckResult
from hw.ip.otbn.util.shared.reg_dump import parse_reg_dump
# Import the simulator as python module for injecting dmem
from hw.ip.otbn.dv.otbnsim.sim.stats import ExecutionStatAnalyzer
from hw.ip.otbn.dv.otbnsim.sim.standalonesim import StandaloneSim
from hw.ip.otbn.dv.otbnsim.sim.load_elf import load_elf


# Names of special registers
ERR_BITS = 'ERR_BITS'
INSN_CNT = 'INSN_CNT'
STOP_PC = 'STOP_PC'


# copied from hw/ip/otbn/dv/otbnsim/sim/constants.py
class ErrBits(IntEnum):
    '''A copy of the list of bits in the ERR_BITS register.'''
    BAD_DATA_ADDR = 1 << 0
    BAD_INSN_ADDR = 1 << 1
    CALL_STACK = 1 << 2
    ILLEGAL_INSN = 1 << 3
    LOOP = 1 << 4
    KEY_INVALID = 1 << 5
    RND_REP_CHK_FAIL = 1 << 6
    RND_FIPS_CHK_FAIL = 1 << 7
    IMEM_INTG_VIOLATION = 1 << 16
    DMEM_INTG_VIOLATION = 1 << 17
    REG_INTG_VIOLATION = 1 << 18
    BUS_INTG_VIOLATION = 1 << 19
    BAD_INTERNAL_STATE = 1 << 20
    ILLEGAL_BUS_ACCESS = 1 << 21
    LIFECYCLE_ESCALATION = 1 << 22
    FATAL_SOFTWARE = 1 << 23


def get_err_names(err: int) -> List[str]:
    '''Get the names of all error bits that are set.'''
    out = []
    for err_bit in ErrBits:
        if err & err_bit != 0:
            out.append(err_bit.name)
    return out


def inject_dmem(sim: StandaloneSim, additional_data: List[Tuple[int, bytes]]):
    dmem = sim.dump_data(include_validity=False)
    new_dmem = bytearray()
    for w in struct.iter_unpack("<32s", dmem):
        for v in struct.iter_unpack("<I", w[0]):
            assert len(v) == 1
            new_dmem += v[0].to_bytes(4, 'little')

    assert len(dmem) == len(new_dmem)

    for offset, data in additional_data:
        if offset > len(dmem) or offset < 0:
            raise ValueError("Writing past dmem!")
        new_dmem[offset:offset + len(data)] = bytearray(data)

    if len(new_dmem) != len(dmem):
        raise ValueError("Too many or little dmem bytes written!")

    sim.load_data(bytes(new_dmem), False)


def run_sim(elf: str, additional_data: List[Tuple[int, int, bytes]]) -> Tuple[
        Dict[str, int], List[int]]:
    # Parse expected values.
    result = CheckResult()
    # Run the simulation and produce a register dump.
    sim = StandaloneSim()

    exp_end_addr = load_elf(sim, otbn_sim_py_shared.ELF_MAP[elf])

    if len(additional_data) > 0:
        inject_dmem(sim, additional_data)

    key0 = int((str("deadbeef") * 12), 16)
    key1 = int((str("baadf00d") * 12), 16)
    sim.state.wsrs.set_sideload_keys(key0, key1)

    sim.state.ext_regs.commit()

    sim.start(True)

    reg_dump = StringIO()
    sim.run(verbose=False, dump_file=reg_dump)
    analyzer = ExecutionStatAnalyzer(sim.stats, otbn_sim_py_shared.ELF_MAP[elf])
    print(analyzer.dump())
    stat_data = analyzer.get_stat_data()
    if exp_end_addr is not None:
        if sim.state.pc != exp_end_addr:
            print('Run stopped at PC {:#x}, but _expected_end_addr was {:#x}.'
                  .format(sim.state.pc, exp_end_addr),
                  file=sys.stderr)
            return 1

    actual_regs = parse_reg_dump(reg_dump.getvalue())
    raw_dmem = sim.dump_data(include_validity=False)

    if result.has_errors() or result.has_warnings():
        print(result.report())

    return (actual_regs, raw_dmem, stat_data)
