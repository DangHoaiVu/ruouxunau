package com.ruouxunau.identity.service;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class SecureTokenCodecTest {

    private final SecureTokenCodec codec = new SecureTokenCodec();

    @Test
    void createsOpaqueTokenAndOnlyPersistsDeterministicHash() {
        String first = codec.newToken();
        String second = codec.newToken();

        assertThat(first).hasSize(64).doesNotContain("=");
        assertThat(second).isNotEqualTo(first);
        assertThat(codec.hash(first)).hasSize(64).isEqualTo(codec.hash(first));
        assertThat(codec.hash(first)).isNotEqualTo(codec.hash(second));
    }
}
