package com.ruouxunau.identity.domain;

import org.junit.jupiter.api.Test;

import java.time.Instant;

import static org.assertj.core.api.Assertions.assertThat;

class RefreshTokenEntityTest {

    @Test
    void rotationRevokesOldTokenAndRecordsReplacement() {
        Instant now = Instant.parse("2026-10-14T00:00:00Z");
        RefreshTokenEntity token = new RefreshTokenEntity(
                "01K7H8G7Q10000000000000000",
                "01K7H8G7Q10000000000000001",
                "01K7H8G7Q10000000000000002",
                "a".repeat(64), now.plusSeconds(3600), now);

        assertThat(token.isUsableAt(now)).isTrue();

        token.rotateTo("b".repeat(64), now.plusSeconds(30));

        assertThat(token.isUsableAt(now.plusSeconds(31))).isFalse();
        assertThat(token.getRevokedAt()).isEqualTo(now.plusSeconds(30));
    }
}
