#!/usr/bin/env python3
"""Run a chip-level Verilator test with Verilator 4.210.

The repository's *.sv sources carry Verilator 5.x-only lint pragmas
(UNUSEDSIGNAL, SIDEEFFECT) that Verilator 4.210 rejects. This script makes the
4.210 run self-contained:

  1. Apply a git patch that rewrites those pragmas to their 4.210-compatible
     form (UNUSEDSIGNAL -> UNUSED, drop SIDEEFFECT).
  2. Switch the build to Verilator 4.210 (abort if that toolchain is missing).
  3. Build + run the requested chip-level test via bazelisk.
  4. Report whether the test PASSED.
  5. Always remove the patch afterwards (even on build error / failure).

If the build step itself fails (fusesoc / bazel / Verilator), the script aborts
and still removes the patch.

The patch is also removed if the run is interrupted (Ctrl-C / SIGINT) or
terminated (SIGTERM / SIGHUP): those are turned into a normal exception so the
cleanup runs and the child build process is killed. The only case the patch
cannot be removed automatically is SIGKILL (kill -9), which no process can
catch -- recover with `git apply -R aux/verilator-4.210.patch`.

Examples:
    aux/run_chip_verilator_test.py --mlkem            # ver2, KYBER_K=2
    aux/run_chip_verilator_test.py --mlkem --ver 3 --k 4   # -DKYBER_K=4
    aux/run_chip_verilator_test.py --mldsa --ver 2 --k 3   # -DDILITHIUM_MODE=3
"""

import argparse
import os
import re
import signal
import subprocess
import sys

DEFAULT_PATCH = "aux/verilator-4.210.patch"
DEFAULT_VERILATOR_ROOT = "/tools/verilator/4.210"
EXPECTED_VERILATOR_VERSION = "4.210"

# How many times to re-run after discovering a new read-only sandbox path.
# Bounded so a persistent failure cannot loop forever; each retry must discover
# a *new* path or the loop stops.
MAX_SANDBOX_RETRIES = 3

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

# Markers that indicate the *build* (not the test body) failed.
BUILD_FAILURE_MARKERS = (
    "FAILED TO BUILD",
    "Build did NOT complete successfully",
    "ERROR: Failed to build",
    "exited with an error",
    "%Error",
)


def info(msg):
    line = f"[run_chip_verilator_test] {msg}"
    print(colorize(line, GREEN, sys.stdout), flush=True)


def fail(msg, code=1):
    line = f"[run_chip_verilator_test] ERROR: {msg}"
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
        description="Run a chip-level Verilator test with Verilator 4.210.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    suite = p.add_mutually_exclusive_group(required=True)
    suite.add_argument("--mlkem", action="store_true",
                       help="Run otbn_mlkem_test_sim_verilator_ver<VER>.")
    suite.add_argument("--mldsa", action="store_true",
                       help="Run otbn_mldsa_test_sim_verilator_ver<VER>.")
    p.add_argument("--ver", type=int, default=2,
                   help="BNMULV version: sets -DBNMULV_VER and the test's "
                        "ver<N> suffix. Default: 2.")
    p.add_argument("--k", type=int, default=2,
                   help="Scheme parameter. With --mlkem it sets -DKYBER_K; "
                        "with --mldsa it sets -DDILITHIUM_MODE. Default: 2.")
    p.add_argument("--patch", default=DEFAULT_PATCH,
                   help=f"Git patch with the *.sv changes. Default: {DEFAULT_PATCH}.")
    p.add_argument("--verilator-root", default=DEFAULT_VERILATOR_ROOT,
                   help=f"Verilator 4.210 install prefix. Default: {DEFAULT_VERILATOR_ROOT}.")
    return p.parse_args()


def check_verilator(verilator_root):
    """Verify Verilator 4.210 is present; abort otherwise. Returns the bin dir."""
    bin_dir = os.path.join(verilator_root, "bin")
    binary = os.path.join(bin_dir, "verilator")
    if not os.path.isfile(binary):
        fail(f"Verilator 4.210 not found at {binary} -- aborting.", code=3)
    try:
        out = subprocess.run([binary, "--version"], check=True,
                             capture_output=True, text=True)
    except (subprocess.CalledProcessError, OSError) as exc:
        fail(f"could not run {binary}: {exc}", code=3)
    version_line = out.stdout.strip() or out.stderr.strip()
    if EXPECTED_VERILATOR_VERSION not in version_line:
        fail(f"binary at {binary} does not report {EXPECTED_VERILATOR_VERSION} "
             f"(got: {version_line!r}) -- aborting.", code=3)
    info(f"Switched to Verilator: {version_line}")
    return bin_dir


def patch_applies(root, patch):
    """True if the patch applies cleanly onto the current tree."""
    r = subprocess.run(["git", "apply", "--check", patch], cwd=root,
                       capture_output=True, text=True)
    return r.returncode == 0


def patch_already_applied(root, patch):
    """True if the patch is already applied (reverse-applies cleanly)."""
    r = subprocess.run(["git", "apply", "--reverse", "--check", patch], cwd=root,
                       capture_output=True, text=True)
    return r.returncode == 0


# Matches a sandbox "Read-only file system" complaint and captures the path,
# e.g. ccache's:
#   ccache: error: Failed to create temporary file for
#   /run/user/1000/ccache-tmp/tmp.cpp_stdout.j1xkDM: Read-only file system
# The offending path is user/machine-specific (the UID in /run/user/<UID>
# varies), so we discover it from the build output at runtime instead of
# hardcoding it.
READONLY_RE = re.compile(r"(/[^\s:]+):\s*Read-only file system")


def readonly_paths(output):
    """Return the set of directories the sandbox reported as read-only.

    We whitelist the *parent directory* of each reported path: the file itself
    could not be created, so its containing dir is what must become writable."""
    dirs = set()
    for m in READONLY_RE.finditer(output):
        path = m.group(1)
        dirs.add(os.path.dirname(path) or path)
    return dirs


def build_command(args, writable_paths=()):
    suite = "mlkem" if args.mlkem else "mldsa"
    target = f"//sw/device/tests:otbn_{suite}_test_sim_verilator_ver{args.ver}"
    copts = [f"-DBNMULV_VER={args.ver}"]
    if args.mlkem:
        copts.append(f"-DKYBER_K={args.k}")
    else:
        copts.append(f"-DDILITHIUM_MODE={args.k}")
    cmd = [
        "./bazelisk.sh", "test",
        "--test_output=streamed",
        "--test_timeout=10000",
        # Pass PATH to build actions AND to repository rules: the @nonhermetic
        # repo re-detects the Verilator binary from PATH, so --repo_env=PATH is
        # what actually forces the build onto 4.210.
        "--action_env=PATH",
        "--repo_env=PATH",
    ]
    # Sandbox paths discovered from a previous attempt's "Read-only file system"
    # errors (e.g. ccache's per-user temp dir). Empty on the first attempt.
    cmd += [f"--sandbox_writable_path={p}" for p in sorted(writable_paths)]
    cmd += [f"--copt={c}" for c in copts]
    cmd.append(target)
    return cmd, target


def run_test(root, cmd, env, holder):
    """Stream the test output to the console while capturing it. Stores the
    running process in holder["proc"] so cleanup can stop it. Returns
    (returncode, captured_output)."""
    info("Running: " + " ".join(cmd))
    proc = subprocess.Popen(cmd, cwd=root, env=env, stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT, text=True, bufsize=1,
                            encoding="utf-8", errors="replace")
    holder["proc"] = proc
    captured = []
    try:
        for line in proc.stdout:
            sys.stdout.write(line)
            sys.stdout.flush()
            captured.append(line)
    finally:
        if proc.stdout:
            proc.stdout.close()
    proc.wait()
    return proc.returncode, "".join(captured)


def stop_child(proc):
    """Best-effort stop of the build process. Asks bazel to cancel gracefully
    (SIGINT) first, then escalates."""
    if proc is None or proc.poll() is not None:
        return
    for sig, wait_s in ((signal.SIGINT, 20), (signal.SIGTERM, 10)):
        try:
            proc.send_signal(sig)
            proc.wait(timeout=wait_s)
            return
        except subprocess.TimeoutExpired:
            continue
        except (ProcessLookupError, OSError):
            return
    try:
        proc.kill()
        proc.wait(timeout=10)
    except (subprocess.TimeoutExpired, ProcessLookupError, OSError):
        pass


def _term_handler(signum, frame):
    # Convert SIGTERM/SIGHUP into KeyboardInterrupt so the try/finally cleanup
    # runs (Python would otherwise exit immediately, skipping finally).
    raise KeyboardInterrupt


def looks_like_build_failure(output):
    return any(marker in output for marker in BUILD_FAILURE_MARKERS)


def main():
    args = parse_args()
    root = repo_root()
    patch = args.patch if os.path.isabs(args.patch) else os.path.join(root, args.patch)

    if not os.path.isfile(patch):
        fail(f"patch file not found: {patch}", code=2)

    # 1. Verify the 4.210 toolchain BEFORE touching the tree, so a missing
    #    toolchain never leaves a patch applied.
    bin_dir = check_verilator(args.verilator_root)

    # 2. Make sure the patch can be applied cleanly.
    if not patch_applies(root, patch):
        if patch_already_applied(root, patch):
            fail("patch appears to be already applied. Remove it first "
                 f"(`git apply -R {args.patch}`) or restore the *.sv files to "
                 "their 5.022 baseline, then re-run.", code=2)
        fail("patch does not apply cleanly. Ensure the *.sv files are at the "
             "5.022 baseline (commit it or `git checkout HEAD -- <files>`) "
             "before running.", code=2)

    env = dict(os.environ)
    env["PATH"] = bin_dir + os.pathsep + env.get("PATH", "")

    # Turn termination signals into KeyboardInterrupt so the finally below runs
    # (SIGINT already raises KeyboardInterrupt by default).
    for sig in ("SIGTERM", "SIGHUP"):
        signum = getattr(signal, sig, None)
        if signum is not None:
            try:
                signal.signal(signum, _term_handler)
            except (ValueError, OSError):
                pass

    holder = {"proc": None}
    applied = False
    try:
        info(f"Applying patch: {args.patch}")
        subprocess.run(["git", "apply", patch], cwd=root, check=True)
        applied = True

        # Run the test, and if the bazel sandbox rejects a path as read-only
        # (e.g. ccache's per-user temp dir), extract that path from the output,
        # add it via --sandbox_writable_path and retry. The path is
        # user/machine-specific, so it is discovered here rather than hardcoded.
        writable = set()
        for attempt in range(1, MAX_SANDBOX_RETRIES + 2):
            cmd, target = build_command(args, writable)
            info(f"Target: {target}")
            rc, output = run_test(root, cmd, env, holder)

            if rc == 0:
                print(colorize("[run_chip_verilator_test] RESULT: TEST PASSED",
                               GREEN + BOLD, sys.stdout), flush=True)
                return 0

            new_paths = readonly_paths(output) - writable
            if new_paths and attempt <= MAX_SANDBOX_RETRIES:
                writable |= new_paths
                info("Sandbox reported read-only path(s); retrying with "
                     "--sandbox_writable_path for: " + ", ".join(sorted(new_paths)))
                continue

            if looks_like_build_failure(output):
                fail(f"BUILD FAILED (exit {rc}) -- aborting. The patch will be "
                     "removed.", code=4)
            print(colorize(f"[run_chip_verilator_test] RESULT: TEST FAILED (exit {rc})",
                           RED + BOLD, sys.stdout), flush=True)
            return 5
    finally:
        # Make cleanup uninterruptible so the patch is always removed, even if
        # the user keeps sending signals (Ctrl-C, kill). Only SIGKILL can
        # prevent this.
        for sig in ("SIGINT", "SIGTERM", "SIGHUP"):
            signum = getattr(signal, sig, None)
            if signum is not None:
                try:
                    signal.signal(signum, signal.SIG_IGN)
                except (ValueError, OSError):
                    pass

        if applied:
            info(f"Removing patch: {args.patch}")
            r = subprocess.run(["git", "apply", "--reverse", patch], cwd=root,
                               capture_output=True, text=True)
            if r.returncode != 0:
                warning = (f"[run_chip_verilator_test] WARNING: failed to remove "
                           f"patch cleanly:\n{r.stderr}\nRecover with: "
                           f"git apply -R {args.patch}")
                print(colorize(warning, YELLOW, sys.stderr),
                      file=sys.stderr, flush=True)
            else:
                info("Patch removed; tree restored to baseline.")

        # Stop the build process last (bounded waits); the patch is already
        # restored by this point.
        stop_child(holder["proc"])


if __name__ == "__main__":
    sys.exit(main())
