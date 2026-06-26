#!/usr/bin/env python3
"""Run the OTBN RTL cocotb + pytest testbenches with Verilator 5.022.

The RTL functional-correctness testbenches in hw/ip/otbn/rtl/test require
Verilator 5.022 (the 5.x lint pragmas in the *.sv sources are written for it).
This script makes the run self-contained:

  1. Verify Verilator 5.022 is present and switch the run onto it (abort with an
     ERROR if that toolchain is missing).
  2. From hw/ip/otbn/rtl, run the requested pytest testbench(es).
  3. Report whether the tests PASSED.

The three available testbenches (see README.md) are:

  vector      test/test_vector_adder_pytest.py      (vectorized adders)
  non-vector  test/test_non_vector_adder_pytest.py  (non-vectorized adders)
  mul         test/test_unified_mul_pytest.py       (vectorized multiplier)

Examples:
    aux/run_rtl_pytest.py                 # run all three testbenches
    aux/run_rtl_pytest.py --vector        # only the vectorized adders
    aux/run_rtl_pytest.py --mul --non-vector
"""

import argparse
import os
import subprocess
import sys

DEFAULT_VERILATOR_ROOT = "/tools/verilator/5.022"
EXPECTED_VERILATOR_VERSION = "5.022"

# Directory (relative to repo root) the testbenches must run from, and the
# pytest files for each selectable testbench.
RTL_DIR = "hw/ip/otbn/rtl"
TESTBENCHES = {
    "vector": "test/test_vector_adder_pytest.py",
    "non-vector": "test/test_non_vector_adder_pytest.py",
    "mul": "test/test_unified_mul_pytest.py",
}

# ANSI color codes. Disabled automatically when stdout/stderr is not a TTY or
# when NO_COLOR is set (https://no-color.org/).
GREEN = "\033[32m"
RED = "\033[31m"
YELLOW = "\033[33m"
BOLD = "\033[1m"
RESET = "\033[0m"


def _color_enabled(stream):
    return stream.isatty() and os.environ.get("NO_COLOR") is None


def colorize(msg, color, stream):
    if not _color_enabled(stream):
        return msg
    return f"{color}{msg}{RESET}"


def info(msg):
    line = f"[run_rtl_pytest] {msg}"
    print(colorize(line, GREEN, sys.stdout), flush=True)


def fail(msg, code=1):
    line = f"[run_rtl_pytest] ERROR: {msg}"
    print(colorize(line, RED + BOLD, sys.stderr), file=sys.stderr, flush=True)
    sys.exit(code)


def repo_root():
    try:
        out = subprocess.run(
            ["git", "rev-parse", "--show-toplevel"],
            check=True, capture_output=True, text=True,
        )
        return out.stdout.strip()
    except (subprocess.CalledProcessError, FileNotFoundError):
        fail("not inside a git repository (could not determine repo root).")


def parse_args():
    p = argparse.ArgumentParser(
        description="Run the OTBN RTL cocotb + pytest testbenches with "
                    "Verilator 5.022.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    p.add_argument("--vector", action="store_true",
                   help="Run test/test_vector_adder_pytest.py.")
    p.add_argument("--non-vector", action="store_true", dest="non_vector",
                   help="Run test/test_non_vector_adder_pytest.py.")
    p.add_argument("--mul", action="store_true",
                   help="Run test/test_unified_mul_pytest.py.")
    p.add_argument("--verilator-root", default=DEFAULT_VERILATOR_ROOT,
                   help=f"Verilator 5.022 install prefix. "
                        f"Default: {DEFAULT_VERILATOR_ROOT}.")
    p.add_argument("pytest_args", nargs=argparse.REMAINDER,
                   help="Extra arguments passed through to pytest (after --).")
    return p.parse_args()


def selected_testbenches(args):
    """Return the list of pytest files to run. With no suite flag, run all."""
    selected = []
    if args.vector:
        selected.append(TESTBENCHES["vector"])
    if args.non_vector:
        selected.append(TESTBENCHES["non-vector"])
    if args.mul:
        selected.append(TESTBENCHES["mul"])
    if not selected:
        selected = list(TESTBENCHES.values())
    return selected


def verilator_version(binary):
    """Return the version line reported by `binary --version`, or None if it
    cannot be run."""
    try:
        out = subprocess.run([binary, "--version"], check=True,
                             capture_output=True, text=True)
    except (subprocess.CalledProcessError, OSError):
        return None
    return out.stdout.strip() or out.stderr.strip()


def check_verilator(verilator_root):
    """Detect the Verilator currently on PATH and switch to 5.022 if needed.

    Prints the version that was found, and (when it is not already 5.022)
    verifies the 5.022 install and returns its bin dir to prepend to PATH.
    Returns the bin dir to prepend, or None if PATH is already on 5.022.
    Aborts with an ERROR if 5.022 cannot be located."""
    current = verilator_version("verilator")
    if current is None:
        info("No Verilator found on PATH.")
    else:
        info(f"Found Verilator: {current}")
        if EXPECTED_VERILATOR_VERSION in current:
            info(f"Already on Verilator {EXPECTED_VERILATOR_VERSION}; "
                 "no switch needed.")
            return None

    info(f"Switching to Verilator {EXPECTED_VERILATOR_VERSION}...")
    bin_dir = os.path.join(verilator_root, "bin")
    binary = os.path.join(bin_dir, "verilator")
    if not os.path.isfile(binary):
        fail(f"Verilator {EXPECTED_VERILATOR_VERSION} not found at {binary} "
             "-- aborting.", code=3)
    version_line = verilator_version(binary)
    if version_line is None:
        fail(f"could not run {binary} -- aborting.", code=3)
    if EXPECTED_VERILATOR_VERSION not in version_line:
        fail(f"binary at {binary} does not report {EXPECTED_VERILATOR_VERSION} "
             f"(got: {version_line!r}) -- aborting.", code=3)
    info(f"Switched to Verilator: {version_line}")
    return bin_dir


def run_pytest(rtl_dir, pytest_file, env, extra_args):
    """Stream a single pytest run to the console. Returns the return code."""
    cmd = [sys.executable, "-m", "pytest", pytest_file] + extra_args
    info(f"Running ({pytest_file}): " + " ".join(cmd))
    proc = subprocess.run(cmd, cwd=rtl_dir, env=env, check=False)
    return proc.returncode


def main():
    args = parse_args()
    root = repo_root()
    rtl_dir = os.path.join(root, RTL_DIR)
    if not os.path.isdir(rtl_dir):
        fail(f"RTL directory not found: {rtl_dir}", code=2)

    # Strip a leading "--" separator from the pass-through pytest args.
    extra_args = args.pytest_args
    if extra_args and extra_args[0] == "--":
        extra_args = extra_args[1:]

    testbenches = selected_testbenches(args)

    # 1. Detect the current Verilator and switch to 5.022 if needed, putting it
    #    first on PATH so cocotb/pytest pick it up.
    bin_dir = check_verilator(args.verilator_root)
    env = dict(os.environ)
    if bin_dir is not None:
        env["PATH"] = bin_dir + os.pathsep + env.get("PATH", "")

    info(f"Working directory: {rtl_dir}")
    info("Testbenches: " + ", ".join(testbenches))

    failures = []
    for pytest_file in testbenches:
        rc = run_pytest(rtl_dir, pytest_file, env, extra_args)
        if rc == 0:
            print(colorize(f"[run_rtl_pytest] RESULT: {pytest_file} PASSED",
                           GREEN + BOLD, sys.stdout), flush=True)
        else:
            failures.append((pytest_file, rc))
            print(colorize(
                f"[run_rtl_pytest] RESULT: {pytest_file} FAILED (exit {rc})",
                RED + BOLD, sys.stdout), flush=True)

    if failures:
        summary = ", ".join(f"{f} (exit {rc})" for f, rc in failures)
        print(colorize(f"[run_rtl_pytest] {len(failures)} of {len(testbenches)} "
                       f"testbench(es) FAILED: {summary}",
                       RED + BOLD, sys.stderr), file=sys.stderr, flush=True)
        return 5

    print(colorize(f"[run_rtl_pytest] ALL {len(testbenches)} testbench(es) PASSED",
                   GREEN + BOLD, sys.stdout), flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
