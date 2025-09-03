#!/usr/bin/env python3

import subprocess, re
from tabulate import tabulate
import argparse

def extract_utilization(file_path):
    """Extract utilization information from the file."""  
    utilization_data = {
        "Slice LUTs": None,
        "DSPs": None,
        "Slice Registers": None,
        "Block RAM Tile": None,
    }

    try:
      with open(file_path, "r") as file:
        for line in file:
          for key in utilization_data.keys():
            # Extract values for specific components
            if f"| {key}" in line:
                utilization_data[key] = float(line.split("|")[2].strip())
    except FileNotFoundError: pass

    return utilization_data


def extract_delay(file_path):
    """Extract path delay information from the file."""  
    delay_data = None

    try:
      with open(file_path, "r") as file:
        for line in file:
          line = line.strip()
          line = re.sub(r'\s+', ' ', line)
          
          if f"Requirement:" in line:
              delay_data = float(line.split(" ")[1].strip()[:-3])
    except FileNotFoundError: pass

    return delay_data


def extract(top_module, outdir):
  result = extract_utilization(f"{outdir}/utilization.txt")

  timing = extract_delay(f"{outdir}/timing.txt")

  data = [top_module] + list(result.values()) + [1000/timing if timing else 0]

  return data

def report(data):
  headers = ["top\\_module", "LUT", "DSP", "FF", "BRAM", "Fmax"]
  
  latex_table = tabulate(data, headers, tablefmt="latex_raw",
                         floatfmt=["", "g", "g", "g", ".1f", ".0f"], #, ".3f", ".3f"],
                         missingval="{---}")
  
  print("""
\\documentclass{standalone}
\\usepackage{booktabs}

\\begin{document}
""")

  print(latex_table)
  print("\\end{document}")
  print()


def synthesize(top_module, outdir, flags = []):
#  command = f"fusesoc --cores-root . run --flag=fileset_top --target=sta --flag +old_adder --flag +old_mac --no-export --tool=vivado --setup --mapping=lowrisc:prim_generic:all:0.1 lowrisc:ip:otbn:0.1; cd build/lowrisc_ip_otbn_0.1/sta-vivado; vivado -mode batch -source timing.tcl -notrace -tclargs --top_module {top_module} --start_freq 10 --outdir ../../../{outdir}"
#  command = f"fusesoc --cores-root . run --flag=fileset_top --target=sta --flag +bnmulv_ver1 --no-export --tool=vivado --setup --mapping=lowrisc:prim_generic:all:0.1 lowrisc:ip:otbn:0.1; cd build/lowrisc_ip_otbn_0.1/sta-vivado; vivado -mode batch -source timing.tcl -notrace -tclargs --top_module {top_module} --start_freq 10 --outdir ../../../{outdir}"
#  command = f"fusesoc --cores-root . run --flag=fileset_top --target=sta --flag +bnmulv_ver2 --no-export --tool=vivado --setup --mapping=lowrisc:prim_generic:all:0.1 lowrisc:ip:otbn:0.1; cd build/lowrisc_ip_otbn_0.1/sta-vivado; vivado -mode batch -source timing.tcl -notrace -tclargs --top_module {top_module} --start_freq 10 --outdir ../../../{outdir}"
#  command = f"fusesoc --cores-root . run --flag=fileset_top --target=sta --flag +bnmulv_ver3 --no-export --tool=vivado --setup --mapping=lowrisc:prim_generic:all:0.1 lowrisc:ip:otbn:0.1; cd build/lowrisc_ip_otbn_0.1/sta-vivado; vivado -mode batch -source timing.tcl -notrace -tclargs --top_module {top_module} --start_freq 10 --outdir ../../../{outdir}"
  command = f"fusesoc --cores-root . run --flag=fileset_top --target=sta {' '.join(['--flag +' + flag for flag in flags])} --no-export --tool=vivado --setup --mapping=lowrisc:prim_generic:all:0.1 lowrisc:ip:otbn:0.1; cd build/lowrisc_ip_otbn_0.1/sta-vivado; vivado -mode batch -source timing.tcl -notrace -tclargs --top_module {top_module} --start_freq 10 --outdir ../../../{outdir}"

  print(f"Command: {command})")

  result = subprocess.run(command, shell=True) #, capture_output=True, text=True)


if __name__ == "__main__":
  parser = argparse.ArgumentParser(description="Python stub for program parameters")

  parser.add_argument(
      "--run_synthesis",
      action="store_true",
      default=False,
      help="Run synthesis. (default: False)"
  )

  parser.add_argument(
      "--adders",
      action="store_true",
      default=False,
      help="Output for all adders. (default: False)"
  )

  parser.add_argument(
      "--mul",
      action="store_true",
      default=False,
      help="Output for all multipliers. (default: False)"
  )

  parser.add_argument(
      "--cond_sub",
      action="store_true",
      default=False,
      help="Output for all conditional subtractors. (default: False)"
  )

  parser.add_argument(
      "--otbn_sub",
      action="store_true",
      default=False,
      help="Output for all otbn sub modules. (default: False)"
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
      help="Top-level hardware module."
  )

  args = parser.parse_args()

  print(f"run_synthesis: {args.run_synthesis}")
  print(f"top_module: {args.top_module}")

  flags = {"": []}
  modules = [args.top_module]

  if args.mul:
    modules = ["unified_mul", "otbn_bignum_mul"]
  elif args.adders:
    modules = ["brent_kung_adder_256", "kogge_stone_adder_256", "sklansky_adder_256", "buffer_bit"]
  elif args.cond_sub:
    modules = ["cond_sub", "cond_sub_buffer_bit"]
  elif args.otbn_sub:
    modules = ["otbn_mac_bignum", "otbn_alu_bignum"]
    flags = {"KMAC": ["kmac"],
             "TOWARDS": ["old_adder", "old_mac"],
             "VER1": ["bnmulv_ver1"],
             "VER2": ["bnmulv_ver2"],
             "VER3": ["bnmulv_ver3"]}

  if args.flags:
    flags = args.flags.split(",")
    flags = {"_".join(flags): flags}

  if args.run_synthesis:
    for top_module in modules:
      for flag_group, flag in flags.items():
        synthesize(top_module, "reports/FPGA/" + top_module + ("_" + flag_group if flag_group else ""), flag)
   
  data = [extract(f"{top_module} {flag_group}", "reports/FPGA/" + top_module + "_".join(flag_group)) for top_module in modules for flag_group in flags.keys()]

  report(data)

