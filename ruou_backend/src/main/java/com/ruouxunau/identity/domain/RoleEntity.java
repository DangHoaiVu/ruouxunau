package com.ruouxunau.identity.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "roles")
public class RoleEntity {

    @Id
    @Column(length = 26, nullable = false, updatable = false)
    private String id;

    @Column(length = 60, nullable = false, unique = true)
    private String code;

    @Column(length = 100, nullable = false)
    private String name;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "role_permissions",
            joinColumns = @JoinColumn(name = "role_id"),
            inverseJoinColumns = @JoinColumn(name = "permission_id"))
    private Set<PermissionEntity> permissions = new HashSet<>();

    protected RoleEntity() {
    }

    public String getCode() {
        return code;
    }

    public Set<PermissionEntity> getPermissions() {
        return Collections.unmodifiableSet(permissions);
    }
}
