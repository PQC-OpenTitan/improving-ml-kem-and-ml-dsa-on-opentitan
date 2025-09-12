#!/usr/bin/env python3

import subprocess, re
from tabulate import tabulate
import argparse

def extract_utilization_FPGA(file_path):
    """Extract utilization information from the file."""  
    utilization_data = {
        "Slice LUTs": None,
        "DSPs": None,
        "CARRY4": None,
        "Slice Registers": None,
        "Block RAM Tile": None,
        "Fmax": None,
    }

    try:
      with open(file_path + "/utilization.txt", "r") as file:
        for line in file:
          for key in utilization_data.keys():
            # Extract values for specific components
            if f"| {key}" in line:
                utilization_data[key] = float(line.split("|")[2].strip())
    except FileNotFoundError: pass

    try:
      with open(file_path + "/summary.txt", "r") as file:
        for line in file:
          for key in utilization_data.keys():
            # Extract values for specific components
            if f"{key}" in line:
                utilization_data[key] = float(line.split(" ")[1].strip())
    except FileNotFoundError: pass


    return utilization_data


def extract_delay_FPGA(file_path):
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

def extract_ORFS(file_path):
    utilization_data = {
        "Fmax": None,
        "design_area": None,
    }

    shortest_slack = 0
    in2out_required = 0

    try:
      with open(file_path, "r") as file:
        for line in file:
          for key in utilization_data.keys():
            # Extract values for specific components
            if f"{key}" in line:
                utilization_data[key] = float(line.split(" ")[1].strip())
          if "shortest_slack" in line:
            shortest_slack = float(line.split(": ")[1].strip())
    except FileNotFoundError: pass

    if shortest_slack < 0:
      utilization_data["Fmax"] = str(utilization_data["Fmax"]) + "!"

    return utilization_data

def extract_Genus(file_path):
    #print(file_path)

    utilization_data = {
        "Fmax": None,
    }

    try:
      with open(file_path + "/summary.txt", "r") as file:
        for line in file:
          for key in utilization_data.keys():
            # Extract values for specific components
            if f"{key}" in line:
                utilization_data[key] = float(line.split(" ")[1].strip())
    except FileNotFoundError: pass

    try:
      with open(file_path + "/area.rpt", "r") as f:
          for line in f:
              # Match the line with instance/module metrics
              # Example line:
              # unified_mul              30553  45966.424 23545.851    69512.275
              match = re.match(
                  r'^\s*\S+\s+(\d+)\s+([\d.]+)\s+([\d.]+)\s+([\d.]+)',
                  line
              )
              if match:
                  #utilization_data["Cell Count"] = int(match.group(1))
                  #utilization_data["Cell Area"] = float(match.group(2))
                  #utilization_data["Net Area"] = float(match.group(3))
                  utilization_data["Total Area"] = float(match.group(4))
    except FileNotFoundError: pass

    return utilization_data


def extract(top_module, flag_group):
  outdir = top_module + ("_" + flag_group if flag_group else "")

  result = extract_utilization_FPGA(f"reports/FPGA/{outdir}")

#  timing = extract_delay_FPGA(f"reports/FPGA/{outdir}/timing.txt")

  #print(timing, type(timing), result)

#  result["Fmax"] = 1000.0 / timing if timing else timing

  #asap7 = extract_ORFS(f"reports/ASIC/{top_module}{'_' + flag_group if flag_group else ''}_asap7_stats")
  sky130hd = extract_ORFS(f"reports/ASIC/{top_module}{'_' + flag_group if flag_group else ''}_sky130hd_stats")

  genus = extract_Genus(f"reports/ASIC-Genus/{outdir}")

  data = [top_module.replace("_", "\_") + (" " + flag_group if flag_group else "")] +\
          list(result.values()) + \
          list(sky130hd.values()) + \
          list(genus.values())
          #[1000/timing if timing else 0] + list(asap7.values()) + \

  return data

def report(data):
  headers = ["top\\_module", "LUT", "DSP", "CARRY4", "FF", "BRAM", "Fmax", "Fmax", "area", "Fmax", "area"]
  
  latex_table = tabulate(data, headers, tablefmt="latex_raw",
                         floatfmt=["", "g", "g", "g", "g", "g", "g", "g", ".3f"], #, ".3f", ".3f"],
                         missingval="{---}")
  
  print("""
\\documentclass{standalone}
\\usepackage{booktabs}

\\begin{document}
""")

  print(latex_table)
  print("\\end{document}")
  print()


def synthesize_ORFS(top_module, outdir, flags = []):
#  command = f"bazel build //hw/ip/otbn:{top_module}{'_' + flags if flags else ''}_asap7{'_all' if flags else ''}_results; mkdir -p {outdir}; cp bazel-bin/hw/ip/otbn/{top_module}{'_' + flags if flags else ''}_asap7_stats {outdir}/"
#
#  # //hw/ip/otbn:otbn_mac_bignum_TOWARDS_asap7_all_results
#
#  print(f"Command: {command}")
#
#  result = subprocess.run(command, shell=True) #, capture_output=True, text=True)

  command = f"bazel build //hw/ip/otbn:{top_module}{'_' + flags if flags else ''}_sky130hd{'_all' if flags else ''}_results; mkdir -p {outdir}; cp bazel-bin/hw/ip/otbn/{top_module}{'_' + flags if flags else ''}_sky130hd_stats {outdir}"

  print(f"Command: {command}")

  result = subprocess.run(command, shell=True) #, capture_output=True, text=True)

def synthesize_Genus(top_module, outdir, flags = []):
  #print("flags:" + str(flags))

  command = f"fusesoc --cores-root . run --flag=fileset_top --target=sta {' '.join(['--flag +' + flag for flag in flags])} --no-export --tool=genus --setup --mapping=lowrisc:prim_generic:all:0.1 lowrisc:ip:otbn:0.1; mkdir -p {outdir}; cd build/lowrisc_ip_otbn_0.1/sta-genus/; source /opt/cadence/CIC/genus.cshrc ; setenv TOP_MODULE {top_module} ; setenv START_F 400 ; setenv OUTDIR ../../../{outdir}; make "

  print(f"Command: {command}")

  result = subprocess.run(command, shell=True, executable='csh') #, capture_output=True, text=True)


def synthesize(top_module, outdir, flags = []):
  command = f"fusesoc --cores-root . run --flag=fileset_top --target=sta {' '.join(['--flag +' + flag for flag in flags])} --no-export --tool=vivado --setup --mapping=lowrisc:prim_generic:all:0.1 lowrisc:ip:otbn:0.1; mkdir -p {outdir}; cd build/lowrisc_ip_otbn_0.1/sta-vivado; vivado -mode batch -source vivado.tcl -notrace -tclargs --top_module {top_module} --start_freq 10 --outdir ../../../{outdir}"
#  command = f"fusesoc --cores-root . run --flag=fileset_top --target=sta {' '.join(['--flag +' + flag for flag in flags])} --no-export --tool=vivado --setup --mapping=lowrisc:prim_generic:all:0.1 lowrisc:ip:otbn:0.1"

  print(f"Command: {command})")

  result = subprocess.run(command, shell=True) #, capture_output=True, text=True)


if __name__ == "__main__":
  parser = argparse.ArgumentParser(description="Python stub for program parameters")

  parser.add_argument(
      "--run_synthesis",
      choices=['Vivado', 'ORFS', 'Genus'],
      help="Run synthesis with specified tool."
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
      "--otbn",
      action="store_true",
      default=False,
      help="Output for the otbn module. (default: False)"
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
  modules = [(args.top_module, flags)]

  if args.mul:
    modules = [("otbn_bignum_mul", {None: []}),
               ("otbn_mul",        {None: ["towards"]}),
               ("unified_mul",     {None: ["bnmulv_ver1"]})]
  elif args.adders:
    modules = [(top_module, {"": []}) for top_module in ["ref_add", "towards_alu_adder", "towards_mac_adder", "buffer_bit", "brent_kung", "kogge_stone", "sklansky"]]
  #elif args.cond_sub:
  #  modules = ["cond_sub", "cond_sub_buffer_bit"]
  elif args.otbn:
    flags = {"": [],
             "KMAC": ["kmac"],
             "TOWARDS": ["towards"],
             "VER1": ["bnmulv_ver1"],
             "VER2": ["bnmulv_ver2"],
             "VER3": ["bnmulv_ver3"]}
    modules = [("otbn", flags)]
  elif args.otbn_sub:
    flags = {"": [],
             "KMAC": ["kmac"],
             "TOWARDS": ["towards"],
             "VER1": ["bnmulv_ver1"],
             "VER2": ["bnmulv_ver2"],
             "VER3": ["bnmulv_ver3"]}
    modules = [(top_module, flags) for top_module in ["otbn_mac_bignum", "otbn_alu_bignum"]]

  if args.flags:
    flags = args.flags.split(",")
    flags = {"_".join(flags): flags}

    modules = [(args.top_module, flags)]

  if args.run_synthesis:
    for top_module, flags in modules:
      for flag_group, flag in flags.items():
        if args.run_synthesis == "Genus":
          synthesize_Genus(top_module, "reports/ASIC-Genus/"+ top_module + ("_" + flag_group if flag_group else ""), flag)
        if args.run_synthesis == "ORFS":
          synthesize_ORFS(top_module, "reports/ASIC/", flag_group)
        if args.run_synthesis == "Vivado":
          synthesize(top_module, "reports/FPGA/" + top_module + ("_" + flag_group if flag_group else ""), flag)

  data = [extract(top_module, flag_group) for flag_group in flags.keys() for top_module, flags in modules]

  report(data)

