#!/usr/bin/env bash
#
# provision.sh -- Reproducible environment for
#   "Improving ML-KEM and ML-DSA on OpenTitan"
#
# Mirrors README sections 2-5. Installs, for the `vagrant` user on a fresh
# Ubuntu 22.04 box:
#   * apt prerequisites (from the repo's apt-requirements.txt) + build tools
#   * the repository (cloned at a pinned ref)
#   * a Python 3.10 virtualenv with the hash-pinned python-requirements.txt
#   * Verilator 5.022  -> /tools/verilator/5.022  (module tests, RTL-ISS, chip 5.x)
#   * Verilator 4.210  -> /tools/verilator/4.210  (chip-level Top Earlgrey tests)
#   * Docker CE (for the OpenROAD/ORFS Bazel flow), with `vagrant` in the group
#   * (optional) pre-pull of the pinned ORFS image for offline synthesis
#
# NOT included (cannot be, see vm/README.md): Vivado, Cadence Genus, CW310 FPGA.
#
# The script is idempotent: each stage is skipped if it is already done, so a
# re-run (`vagrant provision`) only does outstanding work.

set -euo pipefail

# ---------------------------------------------------------------------------
# Configuration (override via environment in the Vagrantfile if desired)
# ---------------------------------------------------------------------------
REPO_URL="${REPO_URL:-https://github.com/PQC-OpenTitan/improving-ml-kem-and-ml-dsa-on-opentitan.git}"
REPO_REF="${REPO_REF:-main}"                    # branch, tag, or commit to check out
REPO_DIR="${REPO_DIR:-/home/vagrant/improving-ml-kem-and-ml-dsa-on-opentitan}"

VERILATOR_5="5.022"
VERILATOR_4="4.210"
TOOLS_PREFIX="/tools/verilator"

# Pinned OpenROAD/ORFS image (keep in sync with MODULE.bazel). Empty => skip pre-pull.
ORFS_IMAGE="${ORFS_IMAGE:-docker.io/openroad/orfs:v3.0-3442-g51a09c48}"
PREPULL_ORFS="${PREPULL_ORFS:-0}"               # set to 1 to docker-pull ORFS at provision time

VAGRANT_USER="vagrant"
VAGRANT_HOME="/home/${VAGRANT_USER}"

log()  { echo -e "\n\033[1;32m[provision] $*\033[0m"; }
warn() { echo -e "\033[1;33m[provision] WARNING: $*\033[0m" >&2; }

# Run a command as the unprivileged vagrant user.
as_user() { sudo -u "${VAGRANT_USER}" -H bash -lc "$*"; }

export DEBIAN_FRONTEND=noninteractive

# ---------------------------------------------------------------------------
# 1. Base build tools + apt prerequisites
# ---------------------------------------------------------------------------
log "Updating apt and installing base build tools"
apt-get update -y
# gcc-11/g++-11 are what the README uses to build Verilator; git/curl for clone
# and Docker repo setup. help2man..ccache etc. are the Verilator build deps.
apt-get install -y --no-install-recommends \
  git curl ca-certificates gnupg lsb-release build-essential \
  gcc-11 g++-11 \
  help2man perl python3 python3-venv python3-pip make autoconf flex bison ccache \
  libgoogle-perftools-dev numactl perl-doc libfl2 libfl-dev zlib1g zlib1g-dev
# zlibc no longer exists on 22.04; the README already says "ignore if error".
apt-get install -y zlibc 2>/dev/null || warn "zlibc unavailable on this release (expected on 22.04) -- skipping"

# ---------------------------------------------------------------------------
# 2. Clone the repository (README section 1) at the pinned ref
# ---------------------------------------------------------------------------
if [[ ! -d "${REPO_DIR}/.git" ]]; then
  log "Cloning ${REPO_URL} (ref ${REPO_REF}) into ${REPO_DIR}"
  as_user "git clone --recurse-submodules -j8 '${REPO_URL}' '${REPO_DIR}'"
  as_user "cd '${REPO_DIR}' && git checkout '${REPO_REF}' && git submodule update --init --recursive"
else
  log "Repository already present at ${REPO_DIR} -- skipping clone"
fi

# Repo-provided apt requirements (README section 2).
if [[ -f "${REPO_DIR}/apt-requirements.txt" ]]; then
  log "Installing repo apt-requirements.txt"
  sed '/^#/d' "${REPO_DIR}/apt-requirements.txt" | xargs -r apt-get install -y || \
    warn "some apt-requirements packages failed to install -- review the log above"
fi

# ---------------------------------------------------------------------------
# 3. Python 3.10 virtualenv + hash-pinned requirements (README section 2)
# ---------------------------------------------------------------------------
if [[ ! -d "${REPO_DIR}/.venv" ]]; then
  log "Creating Python venv and installing python-requirements.txt (--require-hashes)"
  as_user "cd '${REPO_DIR}' && python3 -m venv .venv && \
           source .venv/bin/activate && \
           python3 -m pip install -U pip 'setuptools<66.0.0' && \
           pip3 install -r python-requirements.txt --require-hashes"
else
  log "Python venv already present -- skipping"
fi

# ---------------------------------------------------------------------------
# 4. Verilator builds (README section 3)
# ---------------------------------------------------------------------------
build_verilator() {
  local ver="$1" prefix="${TOOLS_PREFIX}/$1"
  if [[ -x "${prefix}/bin/verilator" ]]; then
    log "Verilator ${ver} already installed at ${prefix} -- skipping"
    return
  fi
  log "Building Verilator ${ver} -> ${prefix}"
  local src="/usr/local/src/verilator-${ver}"
  rm -rf "${src}"
  git clone https://github.com/verilator/verilator.git "${src}"
  pushd "${src}" >/dev/null
    git checkout "v${ver}"
    autoconf
    CC=gcc-11 CXX=g++-11 ./configure --prefix="${prefix}"
    CC=gcc-11 CXX=g++-11 make -j"$(nproc)"
    CC=gcc-11 CXX=g++-11 make install
  popd >/dev/null
  rm -rf "${src}"
}

build_verilator "${VERILATOR_5}"
build_verilator "${VERILATOR_4}"

# Put 5.022 on PATH by default for interactive shells (README: keep 5.022 on
# PATH; the chip-level helper script switches to 4.210 by itself).
PROFILE_D="/etc/profile.d/verilator.sh"
if [[ ! -f "${PROFILE_D}" ]]; then
  log "Adding Verilator ${VERILATOR_5} to the default PATH (${PROFILE_D})"
  echo "export PATH=${TOOLS_PREFIX}/${VERILATOR_5}/bin:\$PATH" > "${PROFILE_D}"
  chmod 0644 "${PROFILE_D}"
fi

# ---------------------------------------------------------------------------
# 5. Docker CE for the OpenROAD/ORFS Bazel flow (README section 5)
# ---------------------------------------------------------------------------
if ! command -v docker >/dev/null 2>&1; then
  log "Installing Docker CE"
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" \
    > /etc/apt/sources.list.d/docker.list
  apt-get update -y
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
else
  log "Docker already installed -- skipping"
fi

# Allow the vagrant user to run docker without sudo (README section 5).
if ! id -nG "${VAGRANT_USER}" | grep -qw docker; then
  log "Adding ${VAGRANT_USER} to the docker group"
  gpasswd -a "${VAGRANT_USER}" docker
  warn "docker group membership applies on the NEXT login -- reconnect with 'vagrant ssh'"
fi
systemctl enable --now docker || warn "could not enable docker service (check 'systemctl status docker')"

# Optional: pre-pull the pinned ORFS image so synthesis works offline.
if [[ "${PREPULL_ORFS}" == "1" && -n "${ORFS_IMAGE}" ]]; then
  log "Pre-pulling ORFS image ${ORFS_IMAGE}"
  docker pull "${ORFS_IMAGE}" || warn "ORFS image pre-pull failed -- Bazel will pull it on first synthesis run"
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
log "Provisioning complete."
cat <<EOF

  Repository : ${REPO_DIR}  (ref: ${REPO_REF})
  Python venv: ${REPO_DIR}/.venv  (activate with 'source .venv/bin/activate')
  Verilator  : ${TOOLS_PREFIX}/${VERILATOR_5} (default on PATH)
               ${TOOLS_PREFIX}/${VERILATOR_4} (used automatically by
               aux/run_chip_verilator_test.py)
  Docker     : installed; re-login so 'docker' works without sudo.

  Next steps (inside 'vagrant ssh'):
    cd ${REPO_DIR}
    source .venv/bin/activate
    verilator --version                       # -> 5.022
    ./bazelisk.sh test //sw/otbn/crypto/tests/mlkem:mlkem512_keypair_test_ver1 ...

  Not provisioned (see vm/README.md): Vivado, Cadence Genus, CW310 FPGA runs.
EOF
