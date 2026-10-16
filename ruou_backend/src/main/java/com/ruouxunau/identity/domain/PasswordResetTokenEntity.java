package com.ruouxunau.identity.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.time.Instant;

@Entity
@Table(name = "password_reset_tokens")
public class PasswordResetTokenEntity {

    @Id
    @Column(length = 26, nullable = false, updatable = false)
    private String id;

    @Column(name = "user_id", length = 26, nullable = false, updatable = false)
    private String userId;

    @Column(name = "token_hash", length = 64, nullable = false, unique = true, updatable = false)
    private String tokenHash;

    @Column(name = "expires_at", nullable = false, updatable = false)
    private Instant expiresAt;

    @Column(name = "consumed_at")
    private Instant consumedAt;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    protected PasswordResetTokenEntity() {
    }

    public PasswordResetTokenEntity(
            String id, String userId, String tokenHash, Instant expiresAt, Instant createdAt) {
        this.id = id;
        this.userId = userId;
        this.tokenHash = tokenHash;
        this.expiresAt = expiresAt;
        this.createdAt = createdAt;
    }

    public boolean isUsableAt(Instant now) {
        return consumedAt == null && expiresAt.isAfter(now);
    }

    public void consume(Instant now) {
        consumedAt = now;
    }

    public String getUserId() {
        return userId;
    }
}
