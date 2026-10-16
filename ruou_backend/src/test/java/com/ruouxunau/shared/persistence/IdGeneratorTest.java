package com.ruouxunau.shared.persistence;

import org.junit.jupiter.api.Test;

import java.time.Clock;
import java.time.Instant;
import java.time.ZoneOffset;
import java.util.HashSet;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;

class IdGeneratorTest {

    @Test
    void createsUniqueSortableLengthIdentifiers() {
        Clock clock = Clock.fixed(Instant.parse("2026-10-14T00:00:00Z"), ZoneOffset.UTC);
        Set<String> ids = new HashSet<>();

        for (int index = 0; index < 10_000; index++) {
            ids.add(IdGenerator.newUlid(clock));
        }

        assertThat(ids).hasSize(10_000);
        assertThat(ids).allMatch(id -> id.matches("[0-9A-HJKMNP-TV-Z]{26}"));
    }
}
