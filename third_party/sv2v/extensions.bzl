# Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
# "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
# (https://eprint.iacr.org/2025/2028)
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

def _sv2v_repo_impl(ctx):
    os = ctx.os.name.lower()
    if "linux" in os:
        url = "https://github.com/zachjs/sv2v/releases/download/v0.0.13/sv2v-Linux.zip"
        sha = "552799a1d76cd177b9b4cc63a3e77823a3d2a6eb4ec006569288abeff28e1ff8"
        bin_path = "sv2v-Linux/sv2v"
    elif "mac" in os:
        url = "https://github.com/zachjs/sv2v/releases/download/v0.0.13/sv2v-macOS.zip"
        sha = "44737572fb42e4c8e8851a76c592f69216a6f3c80d9441dc4d55d557a0e8b8f1"
        bin_path = "sv2v-macOS/sv2v"
    elif "windows" in os:
        url = "https://github.com/zachjs/sv2v/releases/download/v0.0.13/sv2v-Windows.zip"
        sha = "5fd5ae5177d88999e333db21cdfa1796e60e557586df10bc0bdd378b94e9eb71"
        bin_path = "sv2v-Windows/sv2v.exe"
    else:
        fail("Unsupported host OS: %s" % ctx.os.name)

    ctx.download_and_extract(url = url, sha256 = sha)

    ctx.file(
        "sv2v.sh",
        """#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
exec "$DIR/%s" "$@"
""" % bin_path,
        executable = True,
    )

    ctx.file(
        "sv2v.bat",
        "@echo off\r\n\"%%~dp0\\%s\" %%*" % bin_path,
        executable = True,
    )

    ctx.file(
        "BUILD.bazel",
        """
package(default_visibility = ["//visibility:public"])

filegroup(
    name = "real_bin",
    srcs = ["%s"],
)

sh_binary(
  name = "sv2v_bin",
  srcs = select({
    "@platforms//os:windows": ["sv2v.bat"],
    "//conditions:default": ["sv2v.sh"],
  }),
  data = ["%s"],
)
""" % (bin_path, bin_path),
    )

sv2v_repository = repository_rule(
    implementation = _sv2v_repo_impl,
    attrs = {},
)

def _sv2v_repos(_module_ctx):
    sv2v_repository(name = "sv2v")

sv2v = module_extension(
    implementation = _sv2v_repos,
)

