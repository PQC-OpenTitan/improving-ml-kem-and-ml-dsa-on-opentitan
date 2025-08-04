# Copyright "Towards ML-KEM & ML-DSA on OpenTitan" Authors
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

from typing import Tuple
from hw.ip.otbn.util.otbn_sim_py import run_sim

CRYPTO_BYTES = 32
STACK_SIZE = 20000

def mlkem_keypair_otbn(z_bytes: bytes, operation: str) -> Tuple[bytes, bytes]:
    if "mlkem512" in operation:
        CRYPTO_PUBLICKEYBYTES = 800
        CRYPTO_SECRETKEYBYTES = 1632
        CRYPTO_CIPHERTEXTBYTES = 768
    elif "mlkem768" in operation:
        CRYPTO_PUBLICKEYBYTES = 1184
        CRYPTO_SECRETKEYBYTES = 2400
        CRYPTO_CIPHERTEXTBYTES = 1088
    elif "mlkem1024" in operation:
        CRYPTO_PUBLICKEYBYTES = 1568
        CRYPTO_SECRETKEYBYTES = 3168
        CRYPTO_CIPHERTEXTBYTES = 1568
    _, raw_dmem, stat_data = run_sim(operation,
        [(STACK_SIZE + CRYPTO_SECRETKEYBYTES + CRYPTO_PUBLICKEYBYTES, z_bytes)])

    ek = raw_dmem[STACK_SIZE + CRYPTO_SECRETKEYBYTES:STACK_SIZE +
                  CRYPTO_SECRETKEYBYTES + CRYPTO_PUBLICKEYBYTES]
    dk = raw_dmem[STACK_SIZE:STACK_SIZE + CRYPTO_SECRETKEYBYTES]

    return ek, dk, stat_data

def mlkem_encaps_otbn(m_bytes: bytes, ek_bytes: bytes, operation: str) -> Tuple[bytes, bytes]:
    if "mlkem512" in operation:
        CRYPTO_PUBLICKEYBYTES = 800
        CRYPTO_SECRETKEYBYTES = 1632
        CRYPTO_CIPHERTEXTBYTES = 768
    elif "mlkem768" in operation:
        CRYPTO_PUBLICKEYBYTES = 1184
        CRYPTO_SECRETKEYBYTES = 2400
        CRYPTO_CIPHERTEXTBYTES = 1088
    elif "mlkem1024" in operation:
        CRYPTO_PUBLICKEYBYTES = 1568
        CRYPTO_SECRETKEYBYTES = 3168
        CRYPTO_CIPHERTEXTBYTES = 1568
    _, raw_dmem, stat_data = run_sim(operation,
        [(STACK_SIZE + CRYPTO_CIPHERTEXTBYTES + CRYPTO_BYTES, m_bytes),
        (STACK_SIZE + CRYPTO_CIPHERTEXTBYTES + CRYPTO_BYTES + CRYPTO_BYTES, ek_bytes)])

    c = raw_dmem[STACK_SIZE:STACK_SIZE + CRYPTO_CIPHERTEXTBYTES]
    K = raw_dmem[STACK_SIZE + CRYPTO_CIPHERTEXTBYTES:STACK_SIZE +
                 CRYPTO_CIPHERTEXTBYTES + CRYPTO_BYTES]

    return c, K, stat_data

def mlkem_decaps_otbn(c_bytes: bytes, dk_bytes: bytes, operation: str) -> bytes:
    if "mlkem512" in operation:
        CRYPTO_PUBLICKEYBYTES = 800
        CRYPTO_SECRETKEYBYTES = 1632
        CRYPTO_CIPHERTEXTBYTES = 768
    elif "mlkem768" in operation:
        CRYPTO_PUBLICKEYBYTES = 1184
        CRYPTO_SECRETKEYBYTES = 2400
        CRYPTO_CIPHERTEXTBYTES = 1088
    elif "mlkem1024" in operation:
        CRYPTO_PUBLICKEYBYTES = 1568
        CRYPTO_SECRETKEYBYTES = 3168
        CRYPTO_CIPHERTEXTBYTES = 1568
    _, raw_dmem, stat_data = run_sim(operation,
        [(STACK_SIZE + CRYPTO_BYTES, c_bytes),
        (STACK_SIZE + CRYPTO_BYTES + CRYPTO_CIPHERTEXTBYTES, dk_bytes)])

    K_prime = raw_dmem[STACK_SIZE:STACK_SIZE + CRYPTO_BYTES]

    return K_prime, stat_data
