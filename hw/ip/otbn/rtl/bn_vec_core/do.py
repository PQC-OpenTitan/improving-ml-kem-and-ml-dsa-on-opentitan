#!/usr/bin/env python

import subprocess, re
from tabulate import tabulate

from math import ceil, log, floor

import os
import argparse

from wrapper import generate_wrapper


def synthesize(top_module, sources, outdir, wrap=True):
  print(f"starting synthesis {top_module}")

  os.makedirs(outdir, exist_ok=True)

  if wrap:
    with open(top_module + ".sv", 'r') as f:
      module_code = f.read()

    wrapper_code = generate_wrapper(module_code)

    with open(f"{outdir}/wrapper.sv", 'w') as f:
      f.write(wrapper_code)
    print(f"Wrapper written to {outdir}/wrapper.sv")

    sources = sources + f" {outdir}/wrapper.sv"

    top_module = "wrapper"

  defines = ""

  macros  = f""

  command = f"""
	vivado -nojournal -log {outdir}/log.txt -mode batch -source resource_analysis.tcl -tclargs "{sources}" timing_artix7_100t.xdc {top_module} xc7a200tfbg676-3 {outdir}/ "{defines}" "{macros}"
"""

  print(f"Command: {command})")

  result = subprocess.run(command, shell=True) #, capture_output=True, text=True)
#  print(f"Output:\n{result.stdout}")
#  if result.stderr:
#    print(f"Error:\n{result.stderr}")


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

# if __name__ == "__main__":
#   parser = argparse.ArgumentParser(description="Python stub for program parameters")
#   parser.add_argument(
#       "--run_synthesis",
#       action="store_true",
#       default=False,
#       help="Run synthesis (default: False)"
#   )
#   parser.add_argument(
#       "--top_module",
#       type=str,
#       default=False,
#       help='Top-level hardware module.'
#   )
#   parser.add_argument(
#       "--sources",
#       type=str,
#       default=False,
#       help="Source files."
#   )
#   args = parser.parse_args()
# 
# import argparse

if __name__ == "__main__":
  parser = argparse.ArgumentParser(description="Python stub for program parameters")

  parser.add_argument(
      "--run_synthesis",
      action="store_true",
      default=False,
      help="Run synthesis (default: False)"
  )

  parser.add_argument(
      "--top_module",
      type=str,
      default=None,
      help="Top-level hardware module."
  )

  parser.add_argument(
      "--sources",
      type=str,
      default=None,
      help="Source files."
  )

  parser.add_argument(
      "--wrap",
      action="store_true",
      default=False,
      help="Wrap module in registers for inputs and outputs (default: False)"
  )

  args = parser.parse_args()

  print(f"run_synthesis: {args.run_synthesis}")
  print(f"top_module: {args.top_module}")
  print(f"sources: {args.sources}")
  print(f"wrap: {args.wrap}")

  if args.top_module == "adders":
    modules = ["brent_kung_adder_256", "csa_adder_256", "kogge_stone_adder_256", "sklansky_adder_256", "ref_vec_add", "buffer_bit"]
  else:
    modules = [args.top_module]

  if args.run_synthesis:
    for top_module in modules:
      synthesize(top_module, top_module + ".sv", "reports/" + top_module, args.wrap)
   
  data = [extract(top_module, "reports/" + top_module) for top_module in modules]

  report(data)

