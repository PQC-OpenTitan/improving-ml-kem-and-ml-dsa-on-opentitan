# Improving ML-KEM and ML-DSA on OpenTitan

# Efficient Multiplication Vector Instructions for OTBN

## About This Repository

This repository is a [research fork](https://github.com/zerorisc/expo-otbn-pqc)
of OpenTitan hosted by our collaborators at [ZeroRISC](https://www.zerorisc.com/).
It accompanies our paper
**[Improving ML-KEM and ML-DSA on OpenTitan – Efficient Multiplication Vector
Instructions for OTBN](https://eprint.iacr.org/2025/2028)**, and contains the hardware and simulator
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

### 1. Clone this repository
```
git clone --recurse-submodules -j8 https://github.com/phamhnh/improving-mlkem-and-mldsa-on-opentitan.git
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
cd improving-mlkem-and-mldsa-on-opentitan
python3 -m venv .venv
source .venv/bin/activate
python3 -m pip install -U pip "setuptools<66.0.0"
pip3 install -r python-requirements.txt --require-hashes
```

### 3. Installing Verilator 5.022

In order to run hardware-related simulation, you need to install Verilator with
version 5.022 outside this repository:

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

### 4. Installing hardware synthesis tools

For ASIC synthesis with Cadence Genus or FPGA synthesis with Vivado, you need a paid license.

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
./bazelisk.sh test --test_timeout=10000 --cache_test_results=no
--action_env=PATH --sandbox_writable_path="$PWD$"
//sw/otbn/crypto/tests/mldsa:mldsa{44,65,87}_{keypair,sign,verify}_bench_ver{0_base,0,1,2,3}
```

#### Running ML-KEM

```bash
./bazelisk.sh test --test_timeout=10000 --cache_test_results=no
--action_env=PATH --sandbox_writable_path="$PWD$"
//sw/otbn/crypto/tests/mlkem:mlkem{512,768,1024}_{keypair,encap,decap}_bench_{0_base,0,1,2,3}
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

We also include the benchmark results in Table 6 of the paper in `DBs.tar.gz`.  

---

### 2. Fixed-input tests

In case you want to modify the implementations, these tests are quicker to
execute, which use `otbn_sim_test` Bazel rule.

#### Running ML-DSA

```bash
./bazelisk.sh test --test_output=streamed --cache_test_results=no
--action_env=PATH --sandbox_writable_path="path/to/repo"
//sw/otbn/crypto/tests/mldsa:mldsa{44,65,87}_{keypair,sign,verify}_test_ver{0_base,0,1,2,3}
```

#### Running ML-KEM

```bash
./bazelisk.sh test --test_output=streamed --cache_test_results=no
--action_env=PATH --sandbox_writable_path="path/to/repo"
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

### 1. ASIC Synthesis (Tables 1–3)

We provide a script that can run synthesis for either Vivado, ORFS or Cadence
Genus. You can specify synthesis tools using:

```
--tool={Vivado,Genus,ORFS,all}
```

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

Then from `hw/ip/otbn/rtl/`, please run:

```bash
pytest TARGET
```

---

### 3. RTL–ISS Tests

The RTL-ISS test simulates OTBN's RTL, runs an OTBN program binary on it and
compares results with standalone-Python-simulator (ISS) results for every cycle.
We provide these tests for our new multiplication instructions and
full ML-KEM/ML-DSA designs, which takes significantly less time than full-chip simulation with Verilator.

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
[Dilithium](https://github.com/pq-crystals/dilithium) running on Ibex.

#### 🔸 With Verilator

These tests can take several hours.

**Running ML-DSA:**

```bash
./bazelisk.sh test --test_output=streamed --test_timeout=10000 --action_env=PATH
--copt="-DBNMULV_VER={1,2,3}" --copt="-DDILITHIUM_MODE={2,3,5}"
//sw/device/tests:otbn_mldsa_test_sim_verilator_ver{1,2,3}
```

**Running ML-KEM:**

```bash
./bazelisk.sh test --test_output=streamed --test_timeout=10000 --action_env=PATH
--copt="-DBNMULV_VER={1,2,3}" --copt="-DKYBER_K={2,3,4}"
//sw/device/tests:otbn_mlkem_test_sim_verilator_ver{1,2,3}
```

> ⚠️ Note that `_sim_verilator_ver*` must match the version defined in
> `--copt="-DBNMULV_VER=*"`.

#### 🔸 With FPGA (CW310)

Please follow [OpenTitan’s FPGA setup
guide](https://opentitan.org/book/doc/getting_started/setup_fpga.html#connecting-chipwhisperer-fpga-and-hyperdebug-boards-to-your-pc)
for setting up your CW310 board.

We provide bitstreams for OTBNV1, OTBNV2 and OTBNV3 with `buffer_bit` as adders
in both BN-ALU and BN-MAC in
`hw/top_earlgrey/bitstream_cw310/bnmulv_ver{1,2,3}`.

**Load bitstream:**

```bash
./bazelisk.sh run //sw/host/opentitantool -- fpga load-bitstream
hw/top_earlgrey/bitstream_cw310/bnmulv_ver{1,2,3}/lowrisc_systems_chip_earlgrey_cw310_0.1.bit
```

**Run ML-KEM tests:**

```bash
./bazelisk.sh test --define bitstream=skip --test_output=streamed --action_env=PATH
--copt="-DKYBER_K={2,3,4}" --copt="-DBNMULV_VER={1,2,3}"
//sw/device/tests:otbn_mlkem_test_fpga_cw310_test_rom_ver{1,2,3}
```

**Run ML-DSA tests:**

```bash
./bazelisk.sh test --define bitstream=skip --test_output=streamed --action_env=PATH
--copt="-DDILITHIUM_MODE={2,3,5}" --copt="-DBNMULV_VER={1,2,3}"
//sw/device/tests:otbn_mldsa_test_fpga_cw310_test_rom_ver{1,2,3}
```

> 💡 When preloading the bitstream, the test version suffix (`_ver*`) and `--copt` version do **not** need to match, unless you are building the bitstream on the fly with `--define bitstream=vivado`.

---

## Have a question?

If you have any troubles running the code or questions for the paper, please contact:

* **Ruben Niederhagen**: ruben@polycephaly.org
* **Hoang Nguyen Hien Pham**: nguyenhien.phamhoang@gmail.com

---

## Citation

If you use this work, please cite us as follows:

```
@misc{cryptoeprint:2025/2028,
      author = {Ruben Niederhagen and Hoang Nguyen Hien Pham},
      title = {Improving {ML}-{KEM} and {ML}-{DSA} on {OpenTitan} - Efficient Multiplication Vector Instructions for {OTBN}},
      howpublished = {Cryptology {ePrint} Archive, Paper 2025/2028},
      year = {2025},
      url = {https://eprint.iacr.org/2025/2028}
}
```
