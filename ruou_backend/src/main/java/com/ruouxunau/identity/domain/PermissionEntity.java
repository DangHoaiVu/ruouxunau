package com.ruouxunau.identity.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "permissions")
public class PermissionEntity {

    @Id
    @Column(length = 26, nullable = false, updatable = false)
    private String id;

    @Column(length = 80, nullable = false, unique = true)
    private String code;

    @Column(length = 255, nullable = false)
    private String description;

    protected PermissionEntity() {
    }

    public String getCode() {
        return code;
    }
}
