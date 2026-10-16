package com.ruouxunau.identity.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Version;

import java.time.Instant;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "users")
public class UserEntity {

    @Id
    @Column(length = 26, nullable = false, updatable = false)
    private String id;

    @Column(length = 254, nullable = false, unique = true)
    private String email;

    @Column(name = "password_hash", length = 100, nullable = false)
    private String passwordHash;

    @Column(name = "full_name", length = 150, nullable = false)
    private String fullName;

    @Column(length = 20)
    private String phone;

    @Enumerated(EnumType.STRING)
    @Column(length = 20, nullable = false)
    private UserStatus status;

    @Column(name = "age_confirmed_at", nullable = false)
    private Instant ageConfirmedAt;

    @Column(name = "failed_login_attempts", nullable = false)
    private int failedLoginAttempts;

    @Column(name = "locked_until")
    private Instant lockedUntil;

    @Version
    @Column(nullable = false)
    private long version;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "user_roles",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "role_id"))
    private Set<RoleEntity> roles = new HashSet<>();

    protected UserEntity() {
    }

    public UserEntity(
            String id,
            String email,
            String passwordHash,
            String fullName,
            Instant ageConfirmedAt,
            RoleEntity role,
            Instant now) {
        this.id = id;
        this.email = email;
        this.passwordHash = passwordHash;
        this.fullName = fullName;
        this.status = UserStatus.ACTIVE;
        this.ageConfirmedAt = ageConfirmedAt;
        this.createdAt = now;
        this.updatedAt = now;
        this.roles.add(role);
    }

    public boolean isLockedAt(Instant now) {
        return lockedUntil != null && lockedUntil.isAfter(now);
    }

    public void recordFailedLogin(Instant now, int maxFailures, java.time.Duration lockDuration) {
        failedLoginAttempts++;
        if (failedLoginAttempts >= maxFailures) {
            lockedUntil = now.plus(lockDuration);
            failedLoginAttempts = 0;
        }
        updatedAt = now;
    }

    public void recordSuccessfulLogin(Instant now) {
        failedLoginAttempts = 0;
        lockedUntil = null;
        updatedAt = now;
    }

    public void updateProfile(String fullName, String phone, Instant now) {
        this.fullName = fullName;
        this.phone = phone;
        this.updatedAt = now;
    }

    public void changePassword(String passwordHash, Instant now) {
        this.passwordHash = passwordHash;
        this.failedLoginAttempts = 0;
        this.lockedUntil = null;
        this.updatedAt = now;
    }

    public String getId() {
        return id;
    }

    public String getEmail() {
        return email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public String getFullName() {
        return fullName;
    }

    public String getPhone() {
        return phone;
    }

    public UserStatus getStatus() {
        return status;
    }

    public Set<RoleEntity> getRoles() {
        return Collections.unmodifiableSet(roles);
    }
}
