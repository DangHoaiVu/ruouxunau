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
@Table(name = "categories")
public class CategoryEntity {

    @Id
    @Column(length = 26, nullable = false, updatable = false)
    private String id;

    @Column(length = 120, nullable = false)
    private String name;

    @Column(length = 140, nullable = false, unique = true)
    private String slug;

    @Column(length = 500)
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(length = 20, nullable = false)
    private PublicationStatus status;

    @Column(name = "sort_order", nullable = false)
    private int sortOrder;

    @Version
    @Column(nullable = false)
    private long version;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    @Column(name = "deleted_at")
    private Instant deletedAt;

    protected CategoryEntity() {
    }

    public CategoryEntity(String id, String name, String slug, String description,
                          PublicationStatus status, int sortOrder, Instant now) {
        this.id = id;
        this.createdAt = now;
        update(name, slug, description, status, sortOrder, now);
    }

    public void update(String name, String slug, String description,
                       PublicationStatus status, int sortOrder, Instant now) {
        this.name = name;
        this.slug = slug;
        this.description = description;
        this.status = status;
        this.sortOrder = sortOrder;
        this.updatedAt = now;
    }

    public void softDelete(Instant now) {
        this.status = PublicationStatus.INACTIVE;
        this.deletedAt = now;
        this.updatedAt = now;
    }

    public String getId() { return id; }
    public String getName() { return name; }
    public String getSlug() { return slug; }
    public String getDescription() { return description; }
    public PublicationStatus getStatus() { return status; }
    public int getSortOrder() { return sortOrder; }
    public long getVersion() { return version; }
    public Instant getCreatedAt() { return createdAt; }
    public Instant getUpdatedAt() { return updatedAt; }
    public Instant getDeletedAt() { return deletedAt; }
}
