# Improving ML-KEM and ML-DSA on OpenTitan

# Efficient Multiplication Vector Instructions for OTBN

## About This Repository

This repository is a [research fork](https://github.com/zerorisc/expo-otbn-pqc)
of OpenTitan hosted by our collaborators at [zeroRISC](https://www.zerorisc.com/).
It accompanies our paper
**[Improving ML-KEM and ML-DSA on OpenTitan – Efficient Multiplication Vector
Instructions for OTBN](https://tches.iacr.org/index.php/TCHES/article/view/12897/)**, and contains the hardware and simulator
modifications that implement our proposed **vector multiplication instructions**
for OTBN.

This README provides a step-by-step guide to reproduce all results presented in
the paper, including **software benchmarks**, **hardware synthesis**, and **FPGA
experiments**.

---

## Structure of The Code

We follow the notations used in the paper to explain the structure of our
code.

### 1. Hardware
Under `hw/ip/otbn/rtl`, you can find five hardware designs for OTBN, which are
controlled by corresponding macros, allowing easier version control with
Fusesoc:


| Version | Macros | Description |
| ----------- | ---------- | ---------- |
| OTBN | None | Unmodified OTBN |
| OTBN<sub>KMAC</sub> | `TOWARDS_KMAC` | OTBN with only KMAC interface from [*Towards ML-KEM and ML-DSA on OpenTitan*](https://eprint.iacr.org/2024/1192.pdf) (also referred to as OTBN<sup>KMAC</sup> in that paper) |
| OTBN<sub>TW</sub> | `TOWARDS_KMAC`, `TOWARDS_BASE`, `TOWARDS_ALU_ADDER`, `TOWARDS_MAC_ADDER` | `OTBN_KMAC` + full hardware design for the ISE (multi-cycle multiplication approach) from [*Towards ML-KEM and ML-DSA on OpenTitan*](https://eprint.iacr.org/2024/1192.pdf) (also referred to as OTBN<sup>KMAC</sup><sub>Ext</sub> in that paper) |
| OTBNV1 | `TOWARDS_KMAC`, `TOWARDS_BASE`, `BNMULV` | Variant 1 of our proposed vector multiplication instruction |
| OTBNV2 | `TOWARDS_KMAC`, `TOWARDS_BASE`, `BNMULV`, `BNMULV_ACCH` | Variant 2 of our proposed vector multiplication instruction |
| OTBNV3 | `TOWARDS_KMAC`, `TOWARDS_BASE`, `BNMULV`, `BNMULV_ACCH`, `BNMULV_COND_SUB` | Variant 3 of our proposed vector multiplication instruction |

Under `hw/ip/otbn/rtl/bn_vec_core`, you can find core modules for the five
versions above:

| Module | Description |
| ----------- | --------- |
| otbn_bignum_mul.sv | 64-bit multiplier of unmodified OTBN |
| otbn_mul.sv | Vector multiplier of [*Towards ML-KEM and ML-DSA on OpenTitan*](https://eprint.iacr.org/2024/1192.pdf) |
| unified_mul.sv | Vector multiplier of this paper |
| towards_alu_adder.sv | Vector adder of BN-ALU in [*Towards ML-KEM and ML-DSA on OpenTitan*](https://eprint.iacr.org/2024/1192.pdf) |
| towards_mac_adder.sv | Vector adder of BN-MAC in [*Towards ML-KEM and ML-DSA on OpenTitan*](https://eprint.iacr.org/2024/1192.pdf) |
| brent_kung.sv | Brent-Kung vector adder of this paper |
| kogge_stone.sv | Kogge-Stone vector adder of this paper |
| sklansky.sv | Sklansky vector adder of this paper |
| buffer_bit.sv | Buffer-bit vector adder of this paper |
| csa_carry4.sv | FPGA-tailored vector adder with Xilinx primitives `LUT6_2` and `CARRY4` of this paper |
| ref_add.sv | Reference 256-bit non-vector adder of this paper |
| brent_kung_256.sv | 256-bit Brent-Kung non-vector adder of this paper |
| kogge_stone_256.sv | 256-bit Kogge-Stone non-vector adder of this paper |
| sklansky_256.sv | 256-bit Sklansky non-vector adder of this paper |

### 2. Software

Under `sw/otbn/crypto`, you can find five software implementations of ML-KEM and
ML-DSA:

| Version     | Description                                                                                                         |
| ----------- | ------------------------------------------------------------------------------------------------------------------- |
| `ver0_base` | With base OTBN's instructions and with KMAC interface from [Towards ML-KEM and ML-DSA on OpenTitan](https://eprint.iacr.org/2024/1192.pdf) |
| `ver0`      | With ISE (multi-cycle multiplication approach) and KMAC interface from [Towards ML-KEM and ML-DSA on OpenTitan](https://eprint.iacr.org/2024/1192.pdf)                                                          |
| `ver1`      | With Variant 1 (OTBNV1) of our proposed vector multiplication instruction                                                               |
| `ver2`      | With Variant 2 (OTBNV2) of our proposed vector multiplication instruction                                                               |
| `ver3`      | With Variant 3 (OTBNV3) of our proposed vector multiplication instruction                                                               |

All the tests for above implementations can be found in
`sw/otbn/crypto/tests/{mlkem,mldsa}`.

> 💡 Although Variant 3 of our vector multiplication instruction is only briefly
> discussed in Section 5.2 (*Design Space Exploration*), we include it here to
> allow readers to explore the complete design and evaluate both its hardware
> and software performance in support of the claims made in our paper.

---

## Getting Started

### Reproducible VM (recommended)

To make reproduction easy, we provide a [Vagrant](https://developer.hashicorp.com/vagrant)
VM under [`vm/`](vm/) that sets up the whole environment for you: it clones the
repository, creates the Python virtualenv, builds **both** Verilator versions
(5.022 and 4.210), and installs Docker for the OpenROAD flow.

The VM covers:

* all **software** test flows (benchmarking, fixed-input tests, code size),
* **hardware synthesis with ORFS** (OpenROAD, no license required),
* **RTL functional verification** with cocotb + pytest,
* **chip-level (Top Earlgrey) tests with Verilator**.

The following **must be run manually on a suitable host** (they cannot be
bundled into the VM): hardware **synthesis with Vivado and Cadence Genus**
(proprietary, licensed tools) and **chip-level tests on the CW310 FPGA board**
(requires the physical board and USB access). Follow the manual instructions in
the [Hardware](#hardware) section for these.

#### Requirements

* [Vagrant](https://developer.hashicorp.com/vagrant/downloads) with a provider:
  **VirtualBox** (any host) or **libvirt/KVM** (Linux, faster for this workload).
* For VirtualBox, the disk-resize plugin:
  `vagrant plugin install vagrant-disksize`.
* Host resources: **≥ 8 vCPUs**, **≥ 16 GB RAM**, and **~100 GB free disk**
  (two Verilator builds, Bazel toolchains and the OpenTitan external
  dependencies, and the per-configuration Verilated chip models add up fast).
  Hardware virtualization must be enabled in the host BIOS.

#### Running

```bash
cd vm
vagrant up          # build + provision (long: builds two Verilators from source)
vagrant ssh         # log into the VM (Docker works without sudo from here)
```

Then, inside the VM:

```bash
cd ~/improving-ml-kem-and-ml-dsa-on-opentitan
source .venv/bin/activate
verilator --version   # -> Verilator 5.022
```

You can now run any of the software/hardware flows described below. See the
comments in [`vm/Vagrantfile`](vm/Vagrantfile) for configuration options
(resource sizing, pinning a specific ref, packaging a prebuilt box for
distribution, etc.).

> 💡 Prefer a manual setup instead? Follow steps 1–5 below.

### 1. Clone this repository
```
git clone --recurse-submodules -j8 https://github.com/PQC-OpenTitan/improving-ml-kem-and-ml-dsa-on-opentitan.git
```

### 2. Environment setup for Ubuntu 22.04

Please follow the [OpenTitan official setup
guide](https://opentitan.org/book/doc/getting_started/index.html) to prepare
your development environment.

Concretely, you need to install required packages as below:

```bash
sed '/^#/d' ./apt-requirements.txt | xargs sudo apt install -y
```

If you are using a Python virtual environment, we
recommend **Python 3.10**. Then you can set up and install dependencies as
follows:

```bash
cd improving-ml-kem-and-ml-dsa-on-opentitan
python3 -m venv .venv
source .venv/bin/activate
python3 -m pip install -U pip "setuptools<66.0.0"
pip3 install -r python-requirements.txt --require-hashes
```

### 3. Installing Verilator

To run all the tests below, you need two versions of Verilator installed:
- **Verilator 5.022** — for the module-level verification tests using `cocotb` and `pytest`.
- **Verilator 4.210** — for the chip-level (Top Earlgrey) Verilator tests.

#### Verilator 5.022

```bash
# Install prerequisites
sudo apt-get install git help2man perl python3 make autoconf g++ flex bison ccache
sudo apt-get install libgoogle-perftools-dev numactl perl-doc
sudo apt-get install libfl2  # Ubuntu only (ignore if gives error)
sudo apt-get install libfl-dev  # Ubuntu only (ignore if gives error)
sudo apt-get install zlibc zlib1g zlib1g-dev  # Ubuntu only (ignore if gives error)

export VERILATOR_VERSION=5.022

# Clone and build Verilator
git clone https://github.com/verilator/verilator.git
cd verilator
git checkout v$VERILATOR_VERSION

autoconf
CC=gcc-11 CXX=g++-11 ./configure --prefix=/tools/verilator/$VERILATOR_VERSION
CC=gcc-11 CXX=g++-11 make
sudo CC=gcc-11 CXX=g++-11 make install

# Add Verilator to your PATH
export PATH=/tools/verilator/$VERILATOR_VERSION/bin:$PATH
```

If you are not using Ubuntu, please reference the official [installation guide
of Verilator](https://verilator.org/guide/latest/install.html).

#### Verilator 4.210

The chip-level (Top Earlgrey) Verilator tests run against Verilator **4.210**.
If you intend to run them via `aux/run_chip_verilator_test.py` (see
[Chip-Level (Top Earlgrey) tests](#4-chip-level-top-earlgrey-tests)), install
4.210 alongside 5.022. The build flow is identical, only the version and install
prefix differ:

```bash
# Clone and build Verilator (reuse the prerequisites installed above)
git clone https://github.com/verilator/verilator.git
cd verilator
git checkout v4.210

autoconf
CC=gcc-11 CXX=g++-11 ./configure --prefix=/tools/verilator/4.210
CC=gcc-11 CXX=g++-11 make
sudo CC=gcc-11 CXX=g++-11 make install
```

This installs Verilator 4.210 to `/tools/verilator/4.210`, which is the default
location `aux/run_chip_verilator_test.py` expects. The helper script switches to
this toolchain automatically, so you do **not** need to add it to your `PATH`
(keep 5.022 on your `PATH` for the other simulation flows).

### 4. Installing hardware synthesis tools

You need to install Cadence Genus or
[Vivado](https://www.xilinx.com/support/download.html) if you want to run
synthesis with these tools. Please note that a paid
license is required for Cadence Genus synthesis, as well as for bitstream
generation for the CW310-K410T in Vivado.

### 5. Installing Docker

OpenROAD synthesis is integrated into the Bazel workflow and runs inside a
Docker container. Thus, you also need Docker on your machine.
We advise to follow
[the official Docker installation guide for Ubuntu](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository).
In particular, you can run the followings:

```bash
# Remove conflicting packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install the latest version
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify that Docker is running:
sudo systemctl status docker
```

We must ensure Docker can be run without root privileges:

```bash
sudo gpasswd -a $USER docker
# Then restart system to apply group changes
```

---

## Software

### 1. Benchmarking (Tables 4–6)

We benchmark ML-KEM and ML-DSA using the `otbn_sim_py_test` Bazel rule, which runs both:

* Python reference implementations by Giacomo Pope
  ([ML-KEM](https://github.com/GiacomoPope/kyber-py),
  [ML-DSA](https://github.com/GiacomoPope/dilithium-py)) in `sw/otbn/crypto/tests/{mlkem,mldsa}/{kyber,dilithium}py_bench_otbn`
* Corresponding OTBN implementations in `sw/otbn/crypto/{mlkem,mldsa}_ver{0_base,0,1,2,3}`

The benchmarks compare outputs and collect performance data over `ITERATIONS`
iterations using `N_PROC` threads (as defined in
`sw/otbn/crypto/tests/{mlkem,mldsa}/{kyberpy,dilithiumpy}_bench_otbn/bench_{kyber,dilithium}.py`).
The data are logged in SQLite database files `mlkem_bench.db` and
`mldsa_bench.db`.

#### Running ML-DSA

```bash
./bazelisk.sh test --test_timeout=10000 --cache_test_results=no \
  --action_env=PATH --sandbox_writable_path="$PWD" \
  //sw/otbn/crypto/tests/mldsa:mldsa{44,65,87}_{keypair,sign,verify}_bench_ver{0_base,0,1,2,3}
```

#### Running ML-KEM

```bash
./bazelisk.sh test --test_timeout=10000 --cache_test_results=no \
  --action_env=PATH --sandbox_writable_path="$PWD" \
  //sw/otbn/crypto/tests/mlkem:mlkem{512,768,1024}_{keypair,encap,decap}_bench_ver{0_base,0,1,2,3}
```

To extract benchmark numbers in Table 6, you can use our provided script as
follows, where `<start>` and `<end>` is the start and end index of the test you want to benchmark in
the database file:

```bash
util/get_benchmark.py -f mldsa_bench.db -o mldsa_eval.txt -i <start> <end> --scheme mldsa
util/get_benchmark.py -f mlkem_bench.db -o mlkem_eval.txt -i <start> <end> --scheme mlkem
```

For example, to analyze benchmark results of target
`mlkem512_keypair_bench_ver1`, `mlkem512_encap_bench_ver1` and
`mlkem512_decap_bench_ver1`, which has index 28, 29, 30 in `mlkem_bench.db`, do:

```bash
util/get_benchmark.py -f mlkem_bench.db -o mlkem_eval.txt -i 28 30 --scheme mlkem
```

We also include the benchmark results in Table 6 of the paper in `mlkem_db.tar.xz`
and `mldsa_db.tar.xz`. The files can be found [here](https://nce.mpi-sp.org/index.php/s/XH9TjpNgKyBKBf6).
Download them to this repo directory. Then to decompress them, do:
```bash
tar -xJvf mlkem_db.tar.xz
tar -xJvf mldsa_db.tar.xz
```


---

### 2. Fixed-input tests

In case you want to modify the implementations, these tests are quicker to
execute, which use `otbn_sim_test` Bazel rule.

#### Running ML-DSA

```bash
./bazelisk.sh test --test_output=streamed --cache_test_results=no \
  --action_env=PATH --sandbox_writable_path="$PWD" \
  //sw/otbn/crypto/tests/mldsa:mldsa{44,65,87}_{keypair,sign,verify}_test_ver{0_base,0,1,2,3}
```

#### Running ML-KEM

```bash
./bazelisk.sh test --test_output=streamed --cache_test_results=no \
  --action_env=PATH --sandbox_writable_path="$PWD" \
  //sw/otbn/crypto/tests/mlkem:mlkem{512,768,1024}_{keypair,encap,decap}_test_ver{0_base,0,1,2,3}
```

---

### 3. Obtaining code size (Table 7)

To reproduce the code size analysis in Table 7 of the paper, you can use our
script:

```bash
util/get_codesize.py --mlkem --mldsa --compare
```

---

## Hardware

### 1. Hardware synthesis (Tables 1–3)

We provide a script that can run synthesis for either Vivado, ORFS or Cadence
Genus. You can specify synthesis tools using:

```
--tool={Vivado,Genus,ORFS,all}
```
Note that **you do not need a Vivado paid license** for synthesis in this section.

Synthesis results are stored under:

* `reports/FPGA-Vivado`
* `reports/ASIC-Genus`
* `reports/ASIC-ORFS`

#### Multiplier (Table 1)

```bash
util/gen_synth.py --run_synthesis --tool={all,Vivado,ORFS,Genus} --mul
```

#### Adders (Table 2)

```bash
util/gen_synth.py --run_synthesis --tool={all,Vivado,ORFS,Genus} --adders
```

#### BN-ALU / BN-MAC / OTBN (Table 3)

```bash
util/gen_synth.py --run_synthesis --tool={all,Vivado,ORFS,Genus} --otbn_sub
util/gen_synth.py --run_synthesis --tool={all,Vivado,ORFS,Genus} --otbn
```

(Without `--run_synthesis`, existing reports will be parsed.)

> 💡 For OpenRoad (ORFS flow), we need to apply a patch to
`third_party/python/python.MODULE.bazel`:

> ```bash
> git apply aux/python_orfs.patch
> ```
> This is already handled by the script. However, if you want to run ORFS
> manually, please apply the patch and restore this file when done in order for
> the SW testing to work correctly:
> ```bash
> git restore third_party/python/python.MODULE.bazel
> git restore MODULE.bazel.lock
> ```

---

### 2. RTL functional correctness verification with cocotb + pytest

Our RTL modules in `hw/ip/otbn/rtl/bn_vec_core` can be validated using cocotb
testbenches:

| TARGET                                 | Description                    |
| -------------------------------------- | ------------------------------ |
| `test/test_vector_adder_pytest.py`     | Test our vectorized adders     |
| `test/test_non_vector_adder_pytest.py` | Test our non-vectorized adders |
| `test/test_unified_mul_pytest.py`      | Test our vectorized multiplier |

These testbenches require Verilator **5.022**. The simplest way to run them is
the helper script `aux/run_rtl_pytest.py`, which verifies Verilator 5.022 is
installed, switches to it if needed, and runs the testbenches from
`hw/ip/otbn/rtl/`:

```bash
aux/run_rtl_pytest.py                       # run all three testbenches
aux/run_rtl_pytest.py --vector              # only the vectorized adders
aux/run_rtl_pytest.py --non-vector --mul    # any subset
```

Alternatively, with Verilator 5.022 on your `PATH`, you can run them manually
from `hw/ip/otbn/rtl/`:

```bash
pytest test/test_vector_adder_pytest.py
pytest test/test_non_vector_adder_pytest.py
pytest test/test_unified_mul_pytest.py
```

---

### 3. RTL–ISS tests

The RTL-ISS test simulates OTBN's RTL, runs an OTBN program binary on it and
compares results with standalone-Python-simulator (ISS) results for every cycle.
We provide these tests for our new multiplication instructions and
full ML-KEM/ML-DSA designs, which takes significantly less time than full-chip simulation with Verilator.

> ⚠️ These tests require Verilator **5.022**. `run_rtl_iss_test.py` checks the
> active Verilator before building and switches to 5.022 (installed at
> `/tools/verilator/5.022`) if needed, aborting with an error if it is not found.

Our script `run_rtl_iss_test.py` supports the following SW versions:

* `ver0`: Test base OTBN's instruction and ISE from *Towards ML-KEM and ML-DSA on OpenTitan*
* `ver1`, `ver2`, `ver3`: Test base OTBN's instruction, our proposed vector
  multiplication instructions and full-scheme ML-KEM/ML-DSA with these
  instructions.

With `ver{1,2,3}`, you can also configure the BN-MAC and BN-ALU adders using
`-m` and `-a` options respectively (`buffer_bit` by default).

> ⚠️ For `csa_carry4`, due to copyright restrictions, please copy `LUT6_2.v` and
> `CARRY4.v` from `<Vivado install dir>/data/verilog/src/unisims/` to
> `hw/ip/otbn/rtl/bn_vec_core/` before running the test.

Here is an example to run all RTL-ISS tests with Variant 2 (OTBNV2) of our
vector multiplication instruction, Brent-Kung as BN-ALU adders and Kogge-Stone as
BN-MAC adder:

```bash
hw/ip/otbn/dv/smoke/run_rtl_iss_test.py -ver 2 -a brent_kung -m kogge_stone
```

In order to skip Fusesoc building Verilated model, use `-s`. For more
information, use `-h`.

---

### 4. Chip-Level (Top Earlgrey) tests

These tests compare OTBN’s results with reference implementations of
[**pq-crystals**](https://pq-crystals.org/)
[Kyber](https://github.com/pq-crystals/kyber) and
[Dilithium](https://github.com/pq-crystals/dilithium) running on Ibex. For
Dilithium signing on Ibex, we need to use the [lowram
implementation](https://github.com/dop-amin/dilithium/tree/lowram).

#### 🔸 With Verilator

These tests can take several hours. They build against Verilator **4.210** (see
[Verilator 4.210](#verilator-4210)),
whereas the rest of the repository targets 5.022.

##### Recommended: the helper script

The simplest way to run these is `aux/run_chip_verilator_test.py`. In short, the
script:

1. Applies the git patch `aux/verilator-4.210.patch`, which rewrites the
   Verilator 5.x-only lint pragmas in the `*.sv` sources (e.g.
   `UNUSEDSIGNAL` → `UNUSED`, dropping `SIDEEFFECT`) into their 4.210-compatible
   form.
2. Switches the build to Verilator 4.210 (aborting if that toolchain is not
   installed at `/tools/verilator/4.210`).
3. Builds and runs the requested chip-level test via `bazelisk`, then reports
   whether it PASSED.
4. **Always removes the patch afterwards** — even on build error, test failure,
   or interruption (Ctrl-C / SIGTERM). The patch can only be left behind by a
   `kill -9`, which is recoverable with `git apply -R aux/verilator-4.210.patch`.

```bash
aux/run_chip_verilator_test.py --mlkem --ver 2 --k 2   # ML-KEM, OTBNV2, KYBER_K=2
aux/run_chip_verilator_test.py --mldsa --ver 3 --k 5   # ML-DSA, OTBNV3, DILITHIUM_MODE=5
```

##### Running manually

If you prefer to run the `bazel` commands yourself, you must first apply the
4.210 compatibility patch, and restore the tree afterwards:

```bash
# Apply the patch so the *.sv sources build with Verilator 4.210.
git apply aux/verilator-4.210.patch
```

You also need Verilator 4.210 in your shell:

```bash
# Add Verilator to your PATH
export PATH=/tools/verilator/4.210/bin:$PATH
verilator -version # check if Verilator 4.210 is present
```

**Running ML-DSA:**

```bash
./bazelisk.sh test --test_output=streamed --test_timeout=10000 --action_env=PATH \
  --copt="-DBNMULV_VER={1,2,3}" --copt="-DDILITHIUM_MODE={2,3,5}" \
  //sw/device/tests:otbn_mldsa_test_sim_verilator_ver{1,2,3}
```

**Running ML-KEM:**

```bash
./bazelisk.sh test --test_output=streamed --test_timeout=10000 --action_env=PATH \
  --copt="-DBNMULV_VER={1,2,3}" --copt="-DKYBER_K={2,3,4}" \
  //sw/device/tests:otbn_mlkem_test_sim_verilator_ver{1,2,3}
```

```bash
# Remove the patch to restore the *.sv sources to their 5.022 baseline.
git apply -R aux/verilator-4.210.patch
```

> ⚠️ Note that `_sim_verilator_ver*` must match the version defined in
> `--copt="-DBNMULV_VER=*"`.

#### 🔸 With FPGA (CW310)

Before proceeding, please refer to [OpenTitan’s FPGA setup
guide](https://opentitan.org/book/doc/getting_started/setup_fpga.html#fpga-setup)
for instructions on setting up your CW310-K410T board and for general guidance
on running chip-level tests.

We provide bitstreams for OTBNV1, OTBNV2 and OTBNV3 with `buffer_bit` as adders
in both BN-ALU and BN-MAC in
`hw/top_earlgrey/bitstream_cw310/bnmulv_ver{1,2,3}`. For the following steps,
we assume you have a configuration file at `~/.config/opentitantool/config` with
the following content:

```bash
--interface=cw310
```

**Load bitstream:**

```bash
./bazelisk.sh run //sw/host/opentitantool -- fpga load-bitstream \
  /absolute/path/to/hw/top_earlgrey/bitstream_cw310/bnmulv_ver{1,2,3}/lowrisc_systems_chip_earlgrey_cw310_0.1.bit
```

**Run ML-KEM tests:**

```bash
./bazelisk.sh test --define bitstream=skip --test_output=streamed --action_env=PATH \
  --copt="-DKYBER_K={2,3,4}" --copt="-DBNMULV_VER={1,2,3}" \
  //sw/device/tests:otbn_mlkem_test_fpga_cw310_test_rom_ver{1,2,3}
```

**Run ML-DSA tests:**

```bash
./bazelisk.sh test --define bitstream=skip --test_output=streamed --action_env=PATH \
  --copt="-DDILITHIUM_MODE={2,3,5}" --copt="-DBNMULV_VER={1,2,3}" \
  //sw/device/tests:otbn_mldsa_test_fpga_cw310_test_rom_ver{1,2,3}
```

> 💡 When preloading the bitstream, the test version suffix (`_ver*`) and
> `--copt` version do **not** need to match, unless you are building the
> bitstream on the fly with `--define bitstream=vivado`.

**Build bitstream:**

In case you want to build the bitstream yourself, you need **a paid Vivado
license** and then do:

```bash
./bazelisk.sh build //hw/bitstream/vivado:fpga_cw310_test_rom_ver{1,2,3}
```

The bitstream can be found in

```bash
bazel-bin/hw/bitstream/vivado/build.fpga_cw310_ver{1,2,3}/lowrisc_systems_chip_earlgrey_cw310_0.1/synth-vivado
```

---

## Have a question?

If you have any troubles running the code or questions for the paper, please contact:

* **Ruben Niederhagen**: ruben@polycephaly.org
* **Hoang Nguyen Hien Pham**: nguyenhien.phamhoang@gmail.com

---

## Citation

If you use this work, please cite us as follows:

```
@article{TCHES:NP26,
  author    = {Ruben Niederhagen and Hoang Nguyen Hien Pham},
  title     = {Improving {ML}-{KEM} and {ML}-{DSA} on OpenTitan: Efficient Multiplication Vector Instructions for {OTBN}}",
  pages     = {495--519},
  volume    = {2026},
  number    = {2},
  year      = {2026},
  journal   = {IACR Transactions on Cryptographic Hardware and Embedded Systems},
  doi       = {10.46586/tches.v2026.i2.495-519},
}
```
