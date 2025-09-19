#!/usr/bin/env python3

import subprocess
import re
import sys
import argparse
from pathlib import Path
from datetime import datetime
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
    headers = ["top\\_module"]
    floatfmt= [""]

    if 'vivado' in tools:
        headers += ["LUT", "DSP", "CARRY4", "FF", "BRAM", "Fmax"]
        floatfmt += ["g", "g", "g", "g", "g", "g"]
    if 'genus' in tools:
        headers += ["area", "Fmax"]
        floatfmt += [".3f", "g"]
    if 'orfs' in tools:
        headers += ["area", "Fmax"]
        floatfmt += [".3f", "g"]

    latex_table = tabulate(data, headers, tablefmt="latex_raw",
                            floatfmt=floatfmt, missingval="{---}")

    print("""
    \\documentclass{standalone}
    \\usepackage{booktabs}

    \\begin{document}
    """)

    print(latex_table)
    print("\\end{document}")
    print()


def latex_print(data, filename):
    """Export a .tex file of \DefineVar{}{}
    """
    # check if file exists, otherwise create one
    filepath = Path(filename)
    if filepath.exists():
        print(f"INFO: {filename} exists and new data will be overwritten")
    else:
        print(f"INFO: {filename} does not exist and will be created")
        filepath.touch(exist_ok=True)

    lines = (
        "%------------------- W A R N I N G: A U T O - G E N E R A T E D   F I L E !! "
        "-------------------%\n"
        "% PLEASE DO NOT HAND-EDIT THIS FILE. IT HAS BEEN AUTO-GENERATED WITH THE FOLLOWING "
        "COMMAND:\n"
        "%\n"
        "% util/gen_synth.py --output_latex --latex_filename=synth.tex\n"
        "%\n"
        f"% Generated on {datetime.now().date()}.\n\n"
    )

    len_data = len(data)
    for i in range(len_data):
        for j in range(1, 11):
            if data[i][j] is not None:
                data_split = str(data[i][j]).split('.')
                if data_split[1] == '0':
                    data[i][j] = int(data[i][j])
            else:
                data[i][j] = "---"

    for i in range(len_data):
        module = data[i][0]
        module = module.replace('\\_', '-')
        lut = module + '-LUT'
        dsp = module + '-DSP'
        carry4 = module + '-CARRY4'
        ff = module + '-FF'
        bram = module + '-BRAM'
        fmax = module + '-fmax'
        genus_area = module + '-genus-area'
        genus_fmax = module + '-genus-fmax'
        orfs_area = module + '-orfs-area'
        orfs_fmax = module + '-orfs-fmax'
        lines += f"\\DefineVar{{{lut}}}{{{data[i][1]}}}\n"
        lines += f"\\DefineVar{{{dsp}}}{{{data[i][2]}}}\n"
        lines += f"\\DefineVar{{{carry4}}}{{{data[i][3]}}}\n"
        lines += f"\\DefineVar{{{ff}}}{{{data[i][4]}}}\n"
        lines += f"\\DefineVar{{{bram}}}{{{data[i][5]}}}\n"
        lines += f"\\DefineVar{{{fmax}}}{{{data[i][6]}}}\n"
        lines += f"\\DefineVar{{{genus_area}}}{{{data[i][7]}}}\n"
        lines += f"\\DefineVar{{{genus_fmax}}}{{{data[i][8]}}}\n"
        lines += f"\\DefineVar{{{orfs_area}}}{{{data[i][9]}}}\n"
        lines += f"\\DefineVar{{{orfs_fmax}}}{{{data[i][10]}}}\n"
        lines += "\n"

    with filepath.open("w") as f:
        f.write(lines)


def run_synthesis(top, tool, outdir, flags=None):
    """Run FPGA/ASIC synthesis with given tool and top module.
    """
    fusesoc_flags = ""
    if flags is not None:
        fusesoc_flags = '--flag ' + '--flag '.join(flags)

    cmd = (
        f"fusesoc --cores-root . run --flag=fileset_top --target=sta {fusesoc_flags} --no-export "
        f"--tool={tool} --setup --mapping=lowrisc:prim_generic:all:0.1 lowrisc:ip:otbn:0.1 && "
        f"mkdir -p {outdir} && cd build/lowrisc_ip_otbn_0.1/sta-{tool} && "
    )
    if tool == 'vivado':
        cmd += (
            f"vivado -mode batch -source vivado.tcl -notrace -tclargs --top_module {top} "
            f"--start_freq 10 --outdir ../../../{outdir}"
        )
    elif tool == 'genus':
        cmd += (
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
            target = f"//hw/ip/otbn:{top}{flags}_{pdk}{'_all' if flags else ''}_results"
            outname = f"bazel-bin/hw/ip/otbn/{top}{flags}_{pdk}_stats"
            cmd = f"bazel build {target} && mkdir -p {outdir} && cp -f {outname} {outdir}"
    else:
        print(f"ERROR: Unsupported tool {tool}")
        return 1

    print(f"Command: {cmd}")
    if tool != 'genus':
        subprocess.run(cmd, shell=True)
    else:
        subprocess.run(cmd, shell=True, executable='csh')


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
    parser.add_argument(
        '--output_latex',
        action="store_true",
        help=("If given, read all generated reports and output in a LaTex-formatted variables\n"
              "Must be used with only --latex_filename.")
    )
    parser.add_argument(
        '--latex_filename',
        type=str,
        metavar="LATEX_FILENAME",
        help=("Output file of --output_latex option. If file does not exist, it will be created\n"
              "Must be given with full path")
    )

    args = parser.parse_args()

    if not args.top_module and not args.adders and not args.mul and not args.otbn \
        and not args.otbn_sub and not args.output_latex:
        print(
            "ERROR: Please give one of the arugments: --top_module, --adders, --mul, --otbn, "
            ", --otbn_sub, or --output_latex"
        )
        return 1

    if args.flags and (args.adders or args.mul or args.otbn or args.otbn_sub):
        print("ERROR: --flag is only used with --top_module.")
        return 1

    # Abort if --output_latex is given without --latex_filename
    if args.output_latex and not args.latex_filename:
        print('ERROR: --output_latex must be used with --latex_filename')
        return 1

    print(f"run_synthesis: {args.run_synthesis}")
    print(f"top_module: {args.top_module}")

    ADDERS = [
        "ref_add",
        "towards_alu_adder", "towards_mac_adder",
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
            ("unified_mul",     "wallace", ["wallace"])
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

    if args.output_latex:
        modules = [(top_module, None, None) for top_module in ADDERS]
        modules.insert(4, ("csa_carry4", None, ["carry4"]))
        modules += [
            ("otbn_bignum_mul", None, None),
            ("otbn_mul",        None, ["towards"]),
            ("unified_mul",     None, None),
            ("unified_mul",     "wallace", ["wallace"])
        ]
        modules += [
            (top_module, flag_group, flag)
            for top_module in ["otbn_mac_bignum", "otbn_alu_bignum"] for flag_group, flag in FLAGS
        ]
        modules += [("otbn", flag_group, flag) for flag_group, flag in FLAGS]

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

    if args.output_latex:
        data = [
            extract_all(top_module, flag_group, tools) for top_module, flag_group, flag in modules
        ]
        latex_print(data, args.latex_filename)

    return 0


if __name__ == "__main__":
    sys.exit(main())
