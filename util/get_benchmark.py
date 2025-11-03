#!/usr/bin/env python3
# Copyright "Towards ML-KEM & ML-DSA on OpenTitan" Authors
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
# Modified by Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
# "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
# (https://eprint.iacr.org/2025/2028)
# Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham.

import sqlite3
import argparse
from operator import add
from collections import defaultdict
from typing import List
from statistics import mean, median, stdev
from tabulate import tabulate

_GROUPING_MLDSA = {
    "Polynomial Arithmetic": [
        "ntt", "intt",
        "poly_pointwise_acc", "poly_pointwise",
        "poly_add", "poly_sub", "poly_add_pseudovec"
    ],
    "Reduction": ["poly_reduce32", "poly_reduce32_short", "poly_reduce32_pos", "poly_caddq"],
    "Sampling": [
        "poly_challenge",
        "poly_uniform",
        "poly_uniform_eta",
        "poly_chknorm",
        "poly_uniform_gamma_1"
    ],
    "Rounding": [
        "poly_make_hint", "poly_use_hint",
        "poly_decompose", "decompose", "decompose_unsigned",
        "poly_power2round"
    ],
    "Packing": [
        "polyeta_pack", "polyz_pack", "polyt0_pack", "polyt1_pack", "polyw1_pack",
        "polyeta_unpack", "polyz_unpack", "polyt0_unpack", "polyt1_unpack",
        "polyvec_encode_h", "polyvec_decode_h"
    ],
    "SHAKE": ["SHAKE", "keccak_send_message", ],
    "Other": [
        "crypto_sign_keypair", "crypto_sign_signature_internal", "crypto_sign_verify_internal",
        "main"
    ]
}

PARAM_MAP_MLDSA = {
    "mldsa44": "mldsalow",
    "mldsa65": "mldsamid",
    "mldsa87": "mldsahigh"
}

_GROUPING_MLKEM = {
    "Polynomial Arithmetic": ["ntt", "intt", "basemul_acc", "basemul", "poly_add", "poly_sub"],
    "Reduction": ["poly_tomont", "poly_reduce"],
    "Sampling": ["poly_gen_matrix", "cbd2", "cbd3", "poly_getnoise_eta_1", "poly_getnoise_eta_2"],
    "Rounding": [],
    "Packing": [
        "poly_decompress", "polyvec_decompress", "unpack_ciphertext",
        "polyvec_decompress_16", "poly_decompress_16",
        "polyvec_compress", "poly_compress", "pack_ciphertext",
        "polyvec_compress_16", "poly_compress_16",
        "poly_tobytes", "pack_pk", "pack_sk",
        "poly_frombytes", "unpack_pk", "unpack_sk",
        "poly_frommsg", "poly_tomsg"
    ],
    "SHAKE": ["SHAKE", "keccak_send_message"],
    "Other": [
        "crypto_kem_keypair", "crypto_kem_enc", "crypto_kem_dec",
        "indcpa_keypair", "indcpa_enc", "indcpa_dec",
        "main"
    ],
}

PARAM_MAP_MLKEM = {
    "mlkem512": "mlkemlow",
    "mlkem768": "mlkemmid",
    "mlkem1024": "mlkemhigh"
}


def grouping(scheme):
    _grouping = dict()
    if scheme == 'mlkem':
        _grouping = _GROUPING_MLKEM
    else: # scheme == 'mldsa'
        _grouping = _GROUPING_MLDSA

    # "Transpose"
    group = dict()
    for k, v in _grouping.items():
        for vi in v:
            group[vi] = k

    return group

class Evaluation:
    def __init__(self, benchmark_ids: List, file_name: str = "dilithium_bench.db"):
        self.benchmark_ids = benchmark_ids
        self.iter_func_instr_to_perf = {}
        self.instr_hist_median = {}
        self.func_instr_hist = {}
        self.iter_func_to_perf = {}
        self.func_to_perf = {}
        self.iter_cycles = {}
        self.func_names = []
        self.func_calls = {}
        self.func_calls = defaultdict(lambda: [], self.func_calls)
        self.operation = ""

        with sqlite3.connect(file_name) as con:
            cur = con.cursor()

            # Check all data belongs to the same operation:
            query = (
                "SELECT operation FROM benchmark "
                f"WHERE id IN ({','.join(['?']*len(benchmark_ids))})"
            )
            res = cur.execute(query, benchmark_ids)
            operations = [r[0] for r in res.fetchall()]
            assert len(set(operations)) == 1
            self.operation = operations[0]

            # Get cycles per iteration
            query = (
                "SELECT benchmark_iteration_id, cycles FROM cycles JOIN benchmark_iteration "
                "ON benchmark_iteration.id = cycles.benchmark_iteration_id "
                f"WHERE benchmark_iteration.benchmark_id IN ({','.join(['?']*len(benchmark_ids))})"
            )
            res = cur.execute(query, benchmark_ids)
            el = res.fetchone()
            while el is not None:
                self.iter_cycles[el[0]] = el[1]
                el = res.fetchone()

            query = (
                "SELECT benchmark_iteration_id, func_name, instr_name, instr_count, stall_count "
                "FROM func_instrs JOIN benchmark_iteration "
                "ON benchmark_iteration.id = func_instrs.benchmark_iteration_id "
                f"WHERE benchmark_iteration.benchmark_id IN ({','.join(['?']*len(benchmark_ids))})"
            )
            res = cur.execute(query, benchmark_ids)
            el = res.fetchone()
            while el is not None:
                if el[0] not in self.iter_func_instr_to_perf:
                    self.iter_func_instr_to_perf[el[0]] = {}
                if el[1] not in self.iter_func_instr_to_perf[el[0]]:
                    self.iter_func_instr_to_perf[el[0]][el[1]] = {}
                if el[2] not in self.iter_func_instr_to_perf[el[0]][el[1]]:
                    self.iter_func_instr_to_perf[el[0]][el[1]][el[2]] = {}
                self.iter_func_instr_to_perf[el[0]][el[1]][el[2]] = el[3:5]

                el = res.fetchone()

            # Initialize iter_func_to_perf
            for i, func_stats in self.iter_func_instr_to_perf.items():
                if i not in self.iter_func_to_perf:
                    self.iter_func_to_perf[i] = {}
                    self.iter_func_to_perf[i] = defaultdict(lambda: [0, 0], self.iter_func_to_perf[i])
                for func_name, instruction_data in func_stats.items():
                    # Treat the cycles for SHAKE as a special case
                    _instruction_data = dict(instruction_data)
                    # Reads/Writes from/to WSRs account to Keccak only for us
                    shake_cycles = _instruction_data.pop('bn.wsrr', None)
                    if shake_cycles is not None:
                        self.iter_func_to_perf[i]["SHAKE"] = \
                            list(map(add, self.iter_func_to_perf[i]["SHAKE"], shake_cycles))
                    shake_cycles = _instruction_data.pop('bn.wsrw', None)
                    if shake_cycles is not None:
                        self.iter_func_to_perf[i]["SHAKE"] = \
                            list(map(add, self.iter_func_to_perf[i]["SHAKE"], shake_cycles))
                    self.iter_func_to_perf[i][func_name] = \
                        [sum(x) for x in zip(*_instruction_data.values())]

            # Verify no cycle got lost
            for i, func_cycles in self.iter_func_to_perf.items():
                assert self.iter_cycles[i] == sum([sum(x) for x in zip(*func_cycles.values())])

            # Assume all function calls call the same function
            self.func_names = list(next(iter(self.iter_func_to_perf.values())).keys())

            # Get number of function calls total
            query = (
                "SELECT callee_func_name, call_count FROM func_calls JOIN benchmark_iteration "
                "ON benchmark_iteration.id = func_calls.benchmark_iteration_id "
                f"WHERE benchmark_iteration.benchmark_id IN ({','.join(['?']*len(benchmark_ids))})"
            )
            res = cur.execute(query, benchmark_ids)
            el = res.fetchone()
            while el is not None:
                if not el[0].startswith("_"):
                    self.func_calls[el[0]].append(el[1])
                el = res.fetchone()
            self.func_calls["SHAKE"] = [1]
            self.func_calls["main"] = [1]
            self.func_calls = dict(self.func_calls)

            # Instruction Histogram Median
            _instr_hist = {}
            _instr_hist = defaultdict(lambda: [], _instr_hist)
            for _, func_stats in self.iter_func_instr_to_perf.items():
                instr_count = {}
                instr_count = defaultdict(lambda: 0, instr_count)
                for _, instruction_data in func_stats.items():
                    for instr, instrcount_stalls in instruction_data.items():
                        instr_count[instr] += instrcount_stalls[0]
                for instr, instr_count in instr_count.items():
                    _instr_hist[instr].append(instr_count)

            for instr, instr_counts in _instr_hist.items():
                self.instr_hist_median[instr] = round(median(instr_counts))

            self.instr_hist_median = \
                dict(sorted(self.instr_hist_median.items(), key=lambda item: item[1], reverse=True))

    def cycles(self, stat_func):
        return round(stat_func(self.iter_cycles.values()))

    def per_func_stat(self, stat_func, per_call=False):
        # Initialize func_to_perf
        # usually, no division
        div = 1
        per_func_stat = {}
        per_func_stat = defaultdict(lambda: [], per_func_stat)
        # collect data
        for i, func_stats in self.iter_func_to_perf.items():
            for func_name, cycles in func_stats.items():
                per_func_stat[func_name].append(cycles)
        # compute statistics
        for func_name, cycles in per_func_stat.items():
            if per_call and func_name not in ["main", "SHAKE"]:
                div = mean(self.func_calls[func_name])
            per_func_stat[func_name] = [
                stat_func([c[j]/div for c in per_func_stat[func_name]]) for j in range(2)
            ]
        return dict(per_func_stat)

STAT_FUNC = median

def main():
    parser = argparse.ArgumentParser(
        description='Evaluate Benchmark Database.'
    )
    parser.add_argument(
        '-f', '--filename',
        metavar="FILENAME",
        help="<Required> Define the database filename",
        required=True
    )
    parser.add_argument(
        '-o', '--output',
        help="<Optional> Define the output file. Default: eval_result.txt",
        nargs='?',
        const="eval_result.txt"
    )
    parser.add_argument(
        '-i','--ids',
        nargs='+',
        help='<Required> ids of entries from the database to evaluate, space separated.',
        type=int,
        required=True
    )
    parser.add_argument(
        '--scheme',
        metavar="SCHEME",
        type=str,
        help="<Required> Define which scheme to be evaluated. Choices are 'mlkem' or 'mldsa'",
        required=True
    )
    parser.add_argument(
        '--latex',
        action="store_true",
        help="If given, output latex file with \\DefineVar format"
    )
    parser.add_argument(
        '--latex_filename',
        help="<Optional> Define the output latex file. Default: eval_result.tex",
        nargs='?',
        const="eval_result.tex"
    )

    args = parser.parse_args()

    GROUPING = dict()
    GROUPING = grouping(args.scheme)

    n = len(args.ids)
    if n == 1:
        entries = args.ids
    else:
        entries = range(args.ids[0], args.ids[1] + 1)

    data = ""
    latex = ""
    for dben in entries:
        e = Evaluation([dben], file_name=args.filename)
        data += (f" --- {e.operation}: index {dben} in {args.filename} ---\n")

        per_func_stat = e.per_func_stat(lambda x: round(STAT_FUNC(x)), per_call=False)
        # sort
        per_func_stat = \
            dict(sorted(per_func_stat.items(), key=lambda item: sum(item[1]), reverse=True))
        per_group_data = {}
        per_group_data = defaultdict(lambda: [0, 0], per_group_data)

        for k, v in per_func_stat.items():
            per_group_data[GROUPING[k]] = list(map(add, per_group_data[GROUPING[k]], v))
        per_group_data = \
            dict(sorted(per_group_data.items(), key=lambda item: sum(item[1]), reverse=True))

        total_pie = sum([sum(v) for _, v in per_group_data.items()])

        data += ("\nOverall Stats\n")
        headers = ["Metric", "Cycles"]
        cycle_data = [
            ["Mean", e.cycles(mean)],
            ["Median", e.cycles(median)],
            ["Std. Dev.", e.cycles(stdev)]
        ]
        data += (tabulate(cycle_data, headers) + "\n")

        data += ("\nGroup Percentages\n")
        headers = ["Group", "Percentage"]
        pie_data = [
            [k, round(sum(v)/total_pie*100)]
            for k, v in per_group_data.items() if round(sum(v)/total_pie*100) != 0
        ]
        data += (tabulate(pie_data, headers) + "\n")

        data += ("\nPer Function Statistics (accumulated)\n")
        headers = ["Function", "Calls", "Instructions", "Stall", "Total", "Per Call"]
        per_func_acc_data = [
            [k, round(STAT_FUNC(e.func_calls[k])), v[0], v[1], sum(v), \
                round(sum(v)/round(STAT_FUNC(e.func_calls[k])))]
            for k, v in per_func_stat.items()
        ]
        data += (tabulate(per_func_acc_data, headers) + "\n")

        data += ("\nInstruction Histogram\n")
        headers = ["Instruction", "Count"]
        instr_hist_data = [[k, v] for k, v in e.instr_hist_median.items()]
        data += (tabulate(instr_hist_data, headers) + "\n\n\n")

        if args.latex:
            latex += (f"% --- {e.operation}: index {dben} ---\n")
            # print percentages
            for k, v in per_group_data.items():
                latex += (
                    f"\\DefineVar{{percentage-{e.operation.replace('_', '-')}-{k}}}"
                    f"{{{round(sum(v)/total_pie*100)}}}\n"
                )

            latex += ("% per func mean accumulated\n")
            # accumulated per func perf macro
            for k, v in per_func_stat.items():
                latex += (f"\\DefineVar{{{e.operation.replace('_', '-')}-{k}-acc}}{{{sum(v)}}}\n")

            latex += ("% per func mean callwise\n")
            # per func perf macro
            for k, v in per_func_stat.items():
                latex += (
                    f"\\DefineVar{{{e.operation.replace('_', '-')}-{k}}}"
                    f"{{{round(sum(v)/round(STAT_FUNC(e.func_calls[k])))}}}\n"
                )

            latex += ("% cycle count stats\n")
            # cycle count to latex
            latex += (f"\\DefineVar{{{e.operation.replace('_', '-')}-mean}}{{{e.cycles(mean)}}}\n")
            latex += (
                f"\\DefineVar{{{e.operation.replace('_', '-')}-median}}{{{e.cycles(median)}}}\n"
            )
            latex += (
                f"\\DefineVar{{{e.operation.replace('_', '-')}-stdev}}{{{e.cycles(stdev)}}}\n"
            )
            latex += "\n"

    with open(args.output, "w") as f:
        f.write(data)

    if args.latex:
        with open(args.latex_filename, "w") as f:
            f.write(latex)


if __name__ == '__main__':
    main()
