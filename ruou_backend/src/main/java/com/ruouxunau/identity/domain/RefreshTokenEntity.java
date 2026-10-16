package com.ruouxunau.identity.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.time.Instant;

@Entity
@Table(name = "refresh_tokens")
public class RefreshTokenEntity {

    @Id
    @Column(length = 26, nullable = false, updatable = false)
    private String id;

    @Column(name = "user_id", length = 26, nullable = false, updatable = false)
    private String userId;

    @Column(name = "family_id", length = 26, nullable = false, updatable = false)
    private String familyId;

    @Column(name = "token_hash", length = 64, nullable = false, unique = true, updatable = false)
    private String tokenHash;

    @Column(name = "replaced_by_token_hash", length = 64)
    private String replacedByTokenHash;

    @Column(name = "expires_at", nullable = false, updatable = false)
    private Instant expiresAt;

    @Column(name = "revoked_at")
    private Instant revokedAt;

    @Column(name = "last_used_at")
    private Instant lastUsedAt;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    protected RefreshTokenEntity() {
    }

    public RefreshTokenEntity(
            String id,
            String userId,
            String familyId,
            String tokenHash,
            Instant expiresAt,
            Instant createdAt) {
        this.id = id;
        this.userId = userId;
        this.familyId = familyId;
        this.tokenHash = tokenHash;
        this.expiresAt = expiresAt;
        this.createdAt = createdAt;
    }

    public boolean isUsableAt(Instant now) {
        return revokedAt == null && expiresAt.isAfter(now);
    }

    public void rotateTo(String nextTokenHash, Instant now) {
        revokedAt = now;
        lastUsedAt = now;
        replacedByTokenHash = nextTokenHash;
    }

    public void revoke(Instant now) {
        if (revokedAt == null) {
            revokedAt = now;
        }
    }

    public String getUserId() {
        return userId;
    }

    public String getFamilyId() {
        return familyId;
    }

    public Instant getExpiresAt() {
        return expiresAt;
    }

    public Instant getRevokedAt() {
        return revokedAt;
    }
}
