# Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
# "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
# (https://eprint.iacr.org/2025/2028)
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("@nonhermetic//:env.bzl", "BIN_PATHS")

"""Rules for running sv2v.

sv2v is an open-source tool that generates Verilog files (.v) from SystemVerilog
files (.sv). The Verilog source files are needed for bazel-orfs rule to run
synthesis the RTL with the open-source ASIC flow called OpenLANE/OpenROAD.
"""

def _sv2v_impl(ctx):

    pkgs = []
    for f in ctx.files.pkgs:
       sp = f.short_path
       if sp.endswith("_pkg.sv") and sp.rsplit("/", 2)[-2] == "rtl":
           pkgs.append(f)

    inc_dirs = []
    for inc in ctx.attr.includes:
       inc = str(inc.label)[4:].split(":")[0] + "/rtl"
       if inc not in inc_dirs:
          inc_dirs.append(inc)

    inc_files = []
    for f in ctx.files.includes:
       sp = f.short_path
       if (sp.endswith(".sv") or sp.endswith(".svh")) and sp.rsplit("/", 2)[-2] == "rtl":
         inc_files.append(f)

    # Set define arguments
    args_defines = " ".join(["--define="+d for d in ctx.attr.defines])

    # Set include arguments
    args_incs = " ".join(["-I"+f for f in inc_dirs])

    # Set package files
    args_pkgs = " ".join([f.path for f in pkgs])

    outs = []
    for src in ctx.files.srcs:
        if not src.basename.endswith(".sv"):
            continue

        # Construct output file name
        file_name = "{}/{}.v".format(ctx.attr.outdir, src.basename[:-3])
        out = ctx.actions.declare_file(file_name)

        # print(outputs.path)

        # Add arguments to sv2v
        args = ctx.actions.args()
        args.add(args_defines)
        args.add(args_pkgs)
        args.add(args_incs)
        args.add(src.path)
        args.add(out.path)

        # Run sv2v
        ctx.actions.run(
            mnemonic = "SV2V",
            inputs = [src] + pkgs + inc_files,
            outputs = [out],
            arguments = [args],
            executable = ctx.executable._sv2v_wrapper,
            use_default_shell_env = False,
            env = {
                # Obtain the non-hermetic binary path and append Bazel's default PATH.
                "PATH": BIN_PATHS["sv2v"] + ":/bin:/usr/bin:/usr/local/bin",
            },
            progress_message = "Converting {} → {}".format(src.short_path, src.basename),
        )
        outs.append(out)

    return DefaultInfo(files = depset(outs))


sv2v_build = rule(
    implementation = _sv2v_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = [".sv"], doc = "SystemVerilog source file"),
        "defines": attr.string_list(doc = "Define macros --define"),
        "pkgs": attr.label_list(allow_files = True, doc = "Package files"),
        "includes": attr.label_list(allow_files = True, doc = "Include options -I"),
        "outdir": attr.string(mandatory = True, doc = "Otuput directory for Verilog files"),
        "_sv2v_wrapper": attr.label(
            default = "//hw/ip/otbn/sta:sv2v_wrapper",
            executable = True,
            cfg = "exec",
        ),
    },
)
