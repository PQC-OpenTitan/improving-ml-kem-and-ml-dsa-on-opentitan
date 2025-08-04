# Copyright "Towards ML-KEM & ML-DSA on OpenTitan" Authors
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import sqlite3


def create_db(cur):
    try:
        cur.execute("CREATE TABLE benchmark(id INTEGER PRIMARY KEY AUTOINCREMENT, start_time INTEGER, end_time INTEGER, iterations INTEGER, operation TEXT )")
        cur.execute("CREATE TABLE benchmark_iteration(id INTEGER PRIMARY KEY AUTOINCREMENT, benchmark_id INTEGER, FOREIGN KEY (benchmark_id) REFERENCES benchmark (id) );")
        cur.execute("CREATE TABLE cycles(cycles INTEGER, benchmark_iteration_id INTEGER, FOREIGN KEY (benchmark_iteration_id) REFERENCES benchmark_iteration (id) );")
        cur.execute("CREATE TABLE stalls(stalls INTEGER, benchmark_iteration_id INTEGER, FOREIGN KEY (benchmark_iteration_id) REFERENCES benchmark_iteration (id) );")
        cur.execute("CREATE TABLE instr_counts(instr_name TEXT, count INTEGER, benchmark_iteration_id INTEGER, FOREIGN KEY (benchmark_iteration_id) REFERENCES benchmark_iteration (id) );")
        cur.execute("CREATE TABLE func_counts(func_name TEXT, instr_count INTEGER, stall_count INTEGER, benchmark_iteration_id INTEGER, FOREIGN KEY (benchmark_iteration_id) REFERENCES benchmark_iteration (id) );")
        cur.execute("CREATE TABLE func_instrs(func_name TEXT, instr_name TEXT, instr_count INTEGER, stall_count INTEGER, benchmark_iteration_id INTEGER, FOREIGN KEY (benchmark_iteration_id) REFERENCES benchmark_iteration (id) );")
        cur.execute("CREATE TABLE func_calls(caller_func_name TEXT, callee_func_name TEXT, call_count INTEGER, benchmark_iteration_id INTEGER, FOREIGN KEY (benchmark_iteration_id) REFERENCES benchmark_iteration (id) );")
    except sqlite3.OperationalError as e:
        print("DB already seems to exist, skipping creation of tables.")

