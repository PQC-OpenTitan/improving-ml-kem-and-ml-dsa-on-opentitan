import re
import os

def parse_ports(module_code):
    pattern = r'(input|output)\s+logic\s+(\[[^\]]+\])?\s*(\w+)\s*,?'
    return re.findall(pattern, module_code)

def extract_module_name(code):
    match = re.search(r'\bmodule\s+(\w+)', code)
    return match.group(1) if match else "unknown_module"

def generate_wrapper(module_code, wrapper_name="wrapper", clock="clk_i"):
    ports = parse_ports(module_code)
    module_name = extract_module_name(module_code)

    inputs  = [p for p in ports if p[0] == 'input']
    outputs = [p for p in ports if p[0] == 'output']

    wrapper = f"module {wrapper_name} (\n    input logic {clock},\n"

    # Port declarations in wrapper interface
    for direction, width, name in inputs + outputs:
        wrapper += f"    {direction} logic "
        if width:
            wrapper += f"{width} "
        wrapper += f"{name}_i,\n" if direction == "input" else f"{name}_o,\n"

    wrapper = wrapper.rstrip(',\n') + "\n);\n\n"

    # Internal registered signals
    for direction, width, name in inputs:
        width_str = f"{width} " if width else ""
        wrapper += f"    logic {width_str}{name}_reg;\n"

    for direction, width, name in outputs:
        width_str = f"{width} " if width else ""
        wrapper += f"    logic {width_str}{name}_int;\n"

    wrapper += "\n"

    # Register inputs
    wrapper += f"    always_ff @(posedge {clock}) begin\n"
    for direction, _, name in inputs:
        wrapper += f"        {name}_reg <= {name}_i;\n"
    wrapper += f"    end\n\n"

    # Instantiate original module
    wrapper += f"    {module_name} u_{module_name} (\n"
    for direction, _, name in inputs:
        wrapper += f"        .{name}({name}_reg),\n"
    for direction, _, name in outputs:
        wrapper += f"        .{name}({name}_int),\n"
    wrapper = wrapper.rstrip(',\n') + "\n    );\n\n"

    # Register outputs
    wrapper += f"    always_ff @(posedge {clock}) begin\n"
    for _, _, name in outputs:
        wrapper += f"        {name}_o <= {name}_int;\n"
    wrapper += f"    end\n\nendmodule"

    return wrapper

def main(input_path, output_path=None):
    with open(input_path, 'r') as f:
        module_code = f.read()

    wrapper_code = generate_wrapper(module_code)

    if output_path is None:
        print(wrapper_code)
    else:
        with open(output_path, 'w') as f:
            f.write(wrapper_code)
        print(f"Wrapper written to {output_path}")

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Generate SV wrapper with registered I/Os")
    parser.add_argument("input_file", help="Path to SystemVerilog module file")
    parser.add_argument("--output_file", help="Optional output file path")
    parser.add_argument("--clk", default="clk_i", help="Clock signal name (default: clk_i)")
    args = parser.parse_args()

    main(args.input_file, args.output_file)

