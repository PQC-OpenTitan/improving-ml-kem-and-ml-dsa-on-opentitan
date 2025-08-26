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

    outs = []
    for src in ctx.files.srcs:
        if not src.basename.endswith(".sv"):
            continue

        out = ctx.actions.declare_file("src/" + ctx.label.name + "/" + src.basename[:-3] + ".v")

        args = ctx.actions.args()
        args.add_all([src.path,
                      out.path,
                      " ".join([f.path for f in pkgs]),
                      " ".join(["-I"+d for d in inc_dirs]),
                      " ".join(["--define="+d for d in ctx.attr.defines])])

        ctx.actions.run(
            inputs = [src] + pkgs + inc_files,
            outputs = [out],
            executable = ctx.executable.tool,
            arguments = [args],
            tools = [ctx.executable.tool],
            mnemonic = "SV2V",
            progress_message = "Converting %s → %s" % (src.short_path, out.basename),
        )
        outs.append(out)

    return DefaultInfo(files = depset(outs))


sv2v_rule = rule(
    implementation = _sv2v_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = [".sv"]),
        "tool": attr.label(executable = True, cfg = "exec"),
        "defines": attr.string_list(),
        "pkgs": attr.label_list(allow_files = True),
        "includes": attr.label_list(allow_files = True),
    },
)

