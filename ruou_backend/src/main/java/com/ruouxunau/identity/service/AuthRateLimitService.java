package com.ruouxunau.identity.service;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Clock;
import java.time.Duration;
import java.time.Instant;

@Service
public class AuthRateLimitService {

    private final JdbcTemplate jdbcTemplate;
    private final SecureTokenCodec tokenCodec;
    private final Clock clock;

    public AuthRateLimitService(JdbcTemplate jdbcTemplate, SecureTokenCodec tokenCodec, Clock clock) {
        this.jdbcTemplate = jdbcTemplate;
        this.tokenCodec = tokenCodec;
        this.clock = clock;
    }

    @Transactional
    public boolean tryAcquire(String action, String clientKey, int maxAttempts, Duration window) {
        String scopeKey = tokenCodec.hash(action + "|" + clientKey);
        Instant now = clock.instant();
        Instant cutoff = now.minus(window);
        jdbcTemplate.update("""
                INSERT INTO auth_rate_limits (scope_key, window_started_at, attempt_count, updated_at)
                VALUES (?, ?, 1, ?)
                ON DUPLICATE KEY UPDATE
                    attempt_count = IF(window_started_at <= ?, 1, attempt_count + 1),
                    window_started_at = IF(window_started_at <= ?, ?, window_started_at),
                    updated_at = ?
                """, scopeKey, now, now, cutoff, cutoff, now, now);
        Integer attempts = jdbcTemplate.queryForObject(
                "SELECT attempt_count FROM auth_rate_limits WHERE scope_key = ?",
                Integer.class,
                scopeKey);
        return attempts != null && attempts <= maxAttempts;
    }
}
