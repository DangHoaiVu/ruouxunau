package com.ruouxunau.catalog.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Version;

import java.time.Instant;

@Entity
@Table(name = "producers")
public class ProducerEntity {

    @Id
    @Column(length = 26, nullable = false, updatable = false)
    private String id;

    @Column(length = 160, nullable = false)
    private String name;

    @Column(name = "legal_name", length = 200)
    private String legalName;

    @Column(length = 200)
    private String origin;

    @Column(length = 1000)
    private String contact;

    @Enumerated(EnumType.STRING)
    @Column(length = 20, nullable = false)
    private PublicationStatus status;

    @Version
    @Column(nullable = false)
    private long version;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    @Column(name = "deleted_at")
    private Instant deletedAt;

    protected ProducerEntity() {
    }

    public ProducerEntity(String id, String name, String legalName, String origin,
                          String contact, PublicationStatus status, Instant now) {
        this.id = id;
        this.createdAt = now;
        update(name, legalName, origin, contact, status, now);
    }

    public void update(String name, String legalName, String origin, String contact,
                       PublicationStatus status, Instant now) {
        this.name = name;
        this.legalName = legalName;
        this.origin = origin;
        this.contact = contact;
        this.status = status;
        this.updatedAt = now;
    }

    public void softDelete(Instant now) {
        this.status = PublicationStatus.INACTIVE;
        this.deletedAt = now;
        this.updatedAt = now;
    }

    public String getId() { return id; }
    public String getName() { return name; }
    public String getLegalName() { return legalName; }
    public String getOrigin() { return origin; }
    public String getContact() { return contact; }
    public PublicationStatus getStatus() { return status; }
    public long getVersion() { return version; }
    public Instant getCreatedAt() { return createdAt; }
    public Instant getUpdatedAt() { return updatedAt; }
    public Instant getDeletedAt() { return deletedAt; }
}
