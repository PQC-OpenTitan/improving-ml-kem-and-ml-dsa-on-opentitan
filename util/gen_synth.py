#!/usr/bin/env python3
# Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
# "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
# (https://eprint.iacr.org/2025/2028)
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import subprocess
import re
import sys
import shutil
from collections import deque
import csv
import json
import argparse
from tabulate import tabulate

OUTDIR_ORFS = "reports/ASIC-ORFS"
OUTDIR_GENUS = "reports/ASIC-Genus"
OUTDIR_VIVADO = "reports/FPGA-Vivado"

def extract_util_fpga(filepath):
    """Extract utilization information from FPGA utilization reports.
    """
    util_data = {
        "Slice LUTs": None,
        "DSPs": None,
        "CARRY4": None,
        "Slice Registers": None,
        "Block RAM Tile": None,
        "Fmax": None,
    }

    try:
        with open(filepath + "/utilization.txt", "r") as f:
            for line in f:
                for key in util_data.keys():
                    if f"| {key}" in line:
                        util_data[key] = float(line.split("|")[2].strip())
    except FileNotFoundError:
        pass

    try:
        with open(filepath + "/summary.txt", "r") as f:
            for line in f:
                for key in util_data.keys():
                    # Extract values for specific components
                    if key in line:
                        util_data[key] = float(line.split(" ")[1].strip())
    except FileNotFoundError:
        pass

    return util_data


def extract_delay_fpga(filepath):
    """Extract path delay information from FPGA timing reports.
    """
    delay_data = None

    try:
        with open(filepath, "r") as f:
            for line in f:
                line = line.strip()
                line = re.sub(r'\s+', ' ', line)

                if "Requirement:" in line:
                    delay_data = float(line.split(" ")[1].strip()[:-3])
    except FileNotFoundError:
        pass

    return delay_data


def extract_orfs(filepath):
    """Extract area and Fmax from OpenLane's ASIC reports of Bazel ORFS process.
    """
    util_data = {
        "design_area": None,
        "Fmax": None
    }

    shortest_slack = 0

    try:
        with open(filepath, "r") as f:
            for line in f:
                for key in util_data.keys():
                    if key in line:
                        util_data[key] = float(line.split(" ")[1].strip())
                if "shortest_slack" in line:
                    shortest_slack = float(line.split(": ")[1].strip())
    except FileNotFoundError:
        pass

    if shortest_slack < 0:
        util_data["Fmax"] = str(util_data["Fmax"]) + "!"

    return util_data

def extract_genus(filepath):
    """Extract area and Fmax from Genus' ASIC reports.
    """
    util_data = {
        "Total Area": None,
        "Fmax": None
    }

    try:
        with open(filepath + "/summary.txt", "r") as f:
            for line in f:
                for key in util_data.keys():
                    if key in line:
                        util_data[key] = float(line.split(" ")[1].strip())
    except FileNotFoundError:
        pass

    try:
        with open(filepath + "/area.rpt", "r") as f:
            for line in f:
                # Match the line with instance/module metrics. For example:
                # unified_mul 30553 45966.424 23545.851 69512.275
                match = re.match(
                    r'^\s*\S+\s+(\d+)\s+([\d.]+)\s+([\d.]+)\s+([\d.]+)',
                    line
                )
                if match:
                    util_data["Total Area"] = float(match.group(4))
    except FileNotFoundError:
        pass

    return util_data


def extract_all(top, flag_group, tools):
    """Extract synthesis numbers for ASIC/FPGA reports.
    """
    if flag_group is not None:
        flag_group = "_" + flag_group
    else:
        flag_group = ""
    outdir = top + flag_group
    data = [outdir.replace("_", "\\_")]

    for tool in tools:
        if tool == 'vivado':
            result = extract_util_fpga(f"{OUTDIR_VIVADO}/{outdir}")
            data += list(result.values())
        elif tool == 'orfs':
            pdks = [
                'sky130hd',
                # 'asap7'
            ]
            for pdk in pdks:
                result = extract_orfs(f"{OUTDIR_ORFS}/{top}{flag_group}_{pdk}_stats")
                data += list(result.values())
        elif tool == 'genus':
            result = extract_genus(f"{OUTDIR_GENUS}/{outdir}")
            data += list(result.values())

    return data


def report(data, tools):
    """Put collected data to a table in LaTex.
    """
    headers = ["topmodule"]
    floatfmt= [""]

    if 'vivado' in tools:
        headers += ["LUT", "DSP", "CARRY4", "FF", "BRAM", "Fmax"]
        floatfmt += ["g", "g", "g", "g", "g", "g"]
    if 'genus' in tools:
        headers += ["areaGenus", "FmaxGenus"]
        floatfmt += [".3f", "g"]
    if 'orfs' in tools:
        headers += ["areaORFS", "FmaxORFS"]
        floatfmt += [".3f", "g"]

    latex_table = tabulate(
        data,
        headers,
        tablefmt="latex_raw",
        floatfmt=floatfmt,
        missingval="{---}"
    )

    print(latex_table)

    # Write results to a CSV file
    writer = csv.writer(sys.stdout)
    writer.writerows([headers] + data)

def run_with_tail(command, tail_lines=20):
    # Use deque with maxlen to automatically maintain last N lines
    recent_lines = deque(maxlen=tail_lines)
    
    # Get terminal width
    terminal_width = shutil.get_terminal_size().columns
    
    # Start the subprocess
    process = subprocess.Popen(
        command,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        bufsize=1,  # Line buffered
        universal_newlines=True,
        shell=True
    )
    
    print(f"Running: {command}\n")
    print("-" * terminal_width)
    
    line_count = 0
    last_row_count = 0
    
    # Read output line by line
    for line in process.stdout:
        line = line.rstrip()
        while len(line) > 0:
            recent_lines.append(line[:terminal_width])
            line = line[terminal_width:]
        line_count += 1
        
        if line_count <= tail_lines:
            # First N lines: print normally without overwriting
            print(line)
        else:
            # Move cursor up by the tail_lines rows
            print(f"\033[{tail_lines}A", end='')
            
            # Write all recent lines, clearing each row
            for recent_line in recent_lines:
                # Clear line
                print("\033[2K", end='')
                # Print the line
                print("\r" + recent_line)
            
        # Ensure output is flushed immediately
        sys.stdout.flush()
    
    # Wait for process to complete
    process.wait()

    print(f"\033[{tail_lines+1}A", end='')
    for _ in range(tail_lines+1):
        print("\033[2K", end='')
        print("\r ")
    print(f"\033[{tail_lines+1}A", end='')
    
    print(f"Process completed with exit code: {process.returncode}\n")
    
    return process.returncode

def run_synthesis(top, tool, outdir, flags=None):
    """Run FPGA/ASIC synthesis with given tool and top module.
    """
    fusesoc_flags = ""
    if flags is not None:
        fusesoc_flags = '--flag ' + '--flag '.join(flags)

    cmd_synth = (
        f"fusesoc --cores-root . run --flag=fileset_top --target=sta {fusesoc_flags} --no-export "
        f"--tool={tool} --setup --mapping=lowrisc:prim_generic:all:0.1 lowrisc:ip:otbn:0.1 && "
        f"mkdir -p {outdir} && cd build/lowrisc_ip_otbn_0.1/sta-{tool} && "
    )
    cmd_timing = (
        f"fusesoc --cores-root . run --flag=fileset_top --target=sta {fusesoc_flags} --no-export "
        f"--tool={tool} --setup --mapping=lowrisc:prim_generic:all:0.1 lowrisc:ip:otbn:0.1 && "
        f"cd build/lowrisc_ip_otbn_0.1/sta-{tool} && "
    )
    if tool == 'vivado':
        cmd_synth += (
            f"vivado -mode batch -source vivado_synth.tcl -notrace -tclargs --top_module {top} "
            f"--start_freq 10 --outdir ../../../{outdir}"
        )
        cmd_timing += (
            f"vivado -mode batch -source vivado_timing.tcl -notrace -tclargs --top_module {top} "
            f"--outdir ../../../{outdir}"
        )
    elif tool == 'genus':
        cmd_synth += (
            "source /opt/cadence/CIC/genus.cshrc && "
            f"setenv TOP_MODULE {top} && setenv START_F 400 && setenv OUTDIR ../../../{outdir} && "
            "make"
        )
    elif tool == 'orfs':
        pdks = [
            'sky130hd',
            # We don't want to compare ASAP7 synth from ORFS to Genus. Commented out for now.
            # 'asap7'
        ]
        for pdk in pdks:
            target = f"//hw/ip/otbn:{top}{flags}_{pdk}_results"
            outname = f"bazel-bin/hw/ip/otbn/{top}{flags}_{pdk}"
            cmd_synth = (
                # Apply patch for third_party/python/python.MODULE.bazel before running ORFS
                "git restore third_party/python/python.MODULE.bazel && "
                "git restore MODULE.bazel.lock && "
                "git apply aux/python_orfs.patch && "
                f"./bazelisk.sh build {target} && mkdir -p {outdir} && chmod u+w {OUTDIR_ORFS}/* && "
                f"cp -f {outname}_stats {outdir} && "
                f"cp -f {outname}_reports {outdir} && "
                f"cp -f {outname}_fsearch {outdir} && "
                # Restore third_party/python/python.MODULE.bazel when done
                "git restore third_party/python/python.MODULE.bazel && "
                "git restore MODULE.bazel.lock"
            )
    else:
        print(f"ERROR: Unsupported tool {tool}")
        return 1

    print(f"Command: {cmd_synth}")
    if tool != 'genus':
#        subprocess.run(cmd_synth, shell=True)

      start_f = 80

      slow_f = None
      fast_f = None
  
      best_f = -1
      max_freq = None
  
      mid_f = float(start_f)
  
      # temp_file existed in Tcl but is unused in the shown code.
      # temp_file = "/tmp/timing.rpt"

      scale_factor = 1000.0
  
      if scale_factor == 1000.0:
          unit = "ns"
      else:
          unit = "ps"
  
      print()

      # Binary search for max frequency
      while True:
          mid_f = round(mid_f)
  
          if (mid_f == slow_f) or (mid_f == fast_f):
              break
  
          print(f"Slow frequency: {slow_f} MHz (period: {scale_factor/slow_f if slow_f else '--'} {unit})")
          print(f"Fast frequency: {fast_f} MHz (period: {scale_factor/fast_f if fast_f else '--'} {unit})")
          print(f"Testing clock period: {mid_f} MHz (Frequency: {scale_factor/mid_f} {unit})")
          print()
  
#          # Apply new clock constraint
#          set_timing_paths(clk, scale_factor / mid_f)
#  
#          # Run implementation/STA
#          place_and_route()
#  
#          # Get slack (>= 0 means pass)
#          slack = get_slack()

          run_with_tail(cmd_timing + f" --start_freq {mid_f}")

#          subprocess.run(cmd_timing + f" --start_freq {mid_f}", shell=True)
  
          with open(f"{outdir}/child_result.json", 'r') as file:
            data = json.load(file)
  
          print(data)

          slack = data["slack"]
  
          print()
          print(f"Slack: {slack} {unit}")
          print()
  
          if slack >= 0:
              if mid_f > best_f:
                  best_f = mid_f
                  max_freq = best_f
              slow_f = mid_f
          else:
              fast_f = mid_f

          print(f"New best frequency: {best_f} MHz (period: {scale_factor/best_f if best_f else '--'} {unit})")
          print(f"New slow frequency: {slow_f} MHz (period: {scale_factor/slow_f if slow_f else '--'} {unit})")
          print(f"New fast frequency: {fast_f} MHz (period: {scale_factor/fast_f if fast_f else '--'} {unit})")
          print(f"\n\n{'*' * shutil.get_terminal_size().columns}\n\n")
  
          # Update mid_f:
          if fast_f == None:
              mid_f = 2.0 * mid_f
          elif slow_f == None:
              mid_f = mid_f / 2.0
          else:
              # Harmonic-mean step (average periods, convert back to freq)
              mid_f = scale_factor / (((scale_factor / slow_f) + (scale_factor / fast_f)) / 2.0)
  
          if mid_f < 1.0:
              # In Tcl:
              #   global f_search
              #   close $f_search
              #   exit 1
              # Here we raise to clearly signal the failure.
              raise SystemExit(1)
  
      best_period = scale_factor / max_freq
  
      print("\n\n================================================")
      print(f"Maximum Achievable Frequency: {max_freq} MHz")
      print(f"Clock Period: {best_period} {unit}")
      print("================================================\n\n")

      run_with_tail(cmd_timing + f" --start_freq {max_freq}")
  
    else:
        subprocess.run(cmd_synth, shell=True, executable='csh')


def main():
    parser = argparse.ArgumentParser(
        description="Python script for running FPGA and ASIC synthesis"
    )
    parser.add_argument(
        "--run_synthesis",
        action="store_true",
        default=False,
        help="Run synthesis. (default: False)"
    )
    parser.add_argument(
        "--tool",
        choices=['Vivado', 'ORFS', 'Genus', 'all'],
        default='all',
        help="Output results or run synthesis for specified tool. (default: all)"
    )
    parser.add_argument(
        "--adders",
        action="store_true",
        default=False,
        help="Output synthesis results for all adders. (default: False)"
    )
    parser.add_argument(
        "--mul",
        action="store_true",
        default=False,
        help="Output synthesis results for all multipliers. (default: False)"
    )
    parser.add_argument(
        "--otbn",
        action="store_true",
        default=False,
        help="Output synthesis results for the 'otbn' module. (default: False)"
    )
    parser.add_argument(
        "--otbn_sub",
        action="store_true",
        default=False,
        help="Output synthesis results for all OTBN's submodules. (default: False)"
    )
    parser.add_argument(
        "--flags",
        type=str,
        default=None,
        help="Comma-separated list of flags for module variants."
    )
    parser.add_argument(
        "--top_module",
        type=str,
        default=None,
        help="Top-level hardware module to be synthesized."
    )

    args = parser.parse_args()

    if not args.top_module and not args.adders and not args.mul and not args.otbn \
        and not args.otbn_sub:
        print(
            "ERROR: Please give one of the arugments: --top_module, --adders, --mul, --otbn, "
            ", --otbn_sub"
        )
        return 1

    if args.flags and (args.adders or args.mul or args.otbn or args.otbn_sub):
        print("ERROR: --flag is only used with --top_module.")
        return 1

    print(f"run_synthesis: {args.run_synthesis}")
    print(f"top_module: {args.top_module}")

    ADDERS = [
        "ref_add",
        "towards_alu_adder",
        "towards_mac_adder",
        "buffer_bit",
        "brent_kung_256",
        "brent_kung",
        "kogge_stone_256",
        "kogge_stone",
        "sklansky_256",
        "sklansky"
    ]

    FLAGS = [
        (None, None),
        ("KMAC", ["kmac"]),
        ("TOWARDS", ["towards"]),
        ("VER1", ["bnmulv_ver1"]),
        ("VER2", ["bnmulv_ver2"]),
        ("VER3", ["bnmulv_ver3"])
    ]

    if args.top_module:
        modules = [(args.top_module, None, None)]
    if args.flags:
        flags = args.flags.split(",")
        modules = [(args.top_module, "_".join(flags), flags)]

    if args.mul:
        modules = [
            ("otbn_bignum_mul", None, None),
            ("otbn_mul",        None, ["towards"]),
            ("unified_mul",     None, None),
            ("unified_mul",     "WALLACE", ["wallace"])
        ]
    elif args.adders:
        modules = [(top_module, None, None) for top_module in ADDERS]
        if args.tool in ["all", "Vivado"]:
            modules.insert(4, ("csa_carry4", None, ["carry4"]))
    elif args.otbn:
        modules = [("otbn", flag_group, flag) for flag_group, flag in FLAGS]
    elif args.otbn_sub:
        modules = [
            (top_module, flag_group, flag)
            for top_module in ["otbn_mac_bignum", "otbn_alu_bignum"] for flag_group, flag in FLAGS
        ]

    if args.tool == 'all':
        tools = ['vivado', 'genus', 'orfs']
    else:
        tools = [args.tool.lower()]

    if args.run_synthesis:
        for top_module, flag_group, flag in modules:
            flag_group = '_' + flag_group if flag_group is not None else ''
            for tool in tools:
                if tool == 'genus':
                    outdir = f"{OUTDIR_GENUS}/{top_module}{flag_group}"
                elif tool == 'orfs':
                    outdir = f"{OUTDIR_ORFS}/"
                    flag = flag_group
                else:
                    outdir = f"{OUTDIR_VIVADO}/{top_module}{flag_group}"
                # Run synthesis
                run_synthesis(top_module, tool, outdir, flag)

    data = [
        extract_all(top_module, flag_group, tools) for top_module, flag_group, flag in modules
    ]

    report(data, tools)
    return 0


if __name__ == "__main__":
    sys.exit(main())
