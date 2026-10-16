package com.ruouxunau.identity.domain;

import org.junit.jupiter.api.Test;

import java.time.Duration;
import java.time.Instant;

import static org.assertj.core.api.Assertions.assertThat;

class UserEntityTest {

    @Test
    void locksAccountAfterConfiguredNumberOfFailuresAndClearsOnSuccess() {
        Instant now = Instant.parse("2026-10-14T00:00:00Z");
        UserEntity user = new UserEntity(
                "01K7H8G7Q10000000000000000", "user@example.com", "hash", "Người dùng",
                now, new RoleEntity(), now);

        for (int index = 0; index < 5; index++) {
            user.recordFailedLogin(now, 5, Duration.ofMinutes(15));
        }

        assertThat(user.isLockedAt(now.plusSeconds(1))).isTrue();
        assertThat(user.isLockedAt(now.plus(Duration.ofMinutes(16)))).isFalse();

        user.recordSuccessfulLogin(now.plus(Duration.ofMinutes(16)));
        assertThat(user.isLockedAt(now.plus(Duration.ofMinutes(16)))).isFalse();
    }
}
