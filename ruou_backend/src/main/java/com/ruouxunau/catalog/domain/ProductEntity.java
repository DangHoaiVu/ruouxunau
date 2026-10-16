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
@Table(name = "products")
public class ProductEntity {

    @Id
    @Column(length = 26, nullable = false, updatable = false)
    private String id;

    @Column(name = "category_id", length = 26, nullable = false)
    private String categoryId;

    @Column(name = "producer_id", length = 26)
    private String producerId;

    @Column(length = 180, nullable = false)
    private String name;

    @Column(length = 200, nullable = false, unique = true)
    private String slug;

    @Column(name = "short_description", length = 500)
    private String shortDescription;

    @Column(columnDefinition = "TEXT", nullable = false)
    private String description;

    @Column(name = "storage_instructions", length = 1000)
    private String storageInstructions;

    @Column(length = 200)
    private String origin;

    @Enumerated(EnumType.STRING)
    @Column(length = 20, nullable = false)
    private PublicationStatus status;

    @Column(name = "seo_title", length = 180)
    private String seoTitle;

    @Column(name = "seo_description", length = 320)
    private String seoDescription;

    @Column(name = "primary_media_id", length = 26)
    private String primaryMediaId;

    @Version
    @Column(nullable = false)
    private long version;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    @Column(name = "deleted_at")
    private Instant deletedAt;

    protected ProductEntity() {
    }

    public ProductEntity(String id, String categoryId, String producerId, String name, String slug,
                         String shortDescription, String description, String storageInstructions,
                         String origin, PublicationStatus status, String seoTitle,
                         String seoDescription, Instant now) {
        this.id = id;
        this.createdAt = now;
        update(categoryId, producerId, name, slug, shortDescription, description,
                storageInstructions, origin, status, seoTitle, seoDescription, now);
    }

    public void update(String categoryId, String producerId, String name, String slug,
                       String shortDescription, String description, String storageInstructions,
                       String origin, PublicationStatus status, String seoTitle,
                       String seoDescription, Instant now) {
        this.categoryId = categoryId;
        this.producerId = producerId;
        this.name = name;
        this.slug = slug;
        this.shortDescription = shortDescription;
        this.description = description;
        this.storageInstructions = storageInstructions;
        this.origin = origin;
        this.status = status;
        this.seoTitle = seoTitle;
        this.seoDescription = seoDescription;
        this.updatedAt = now;
    }

    public void softDelete(Instant now) {
        this.status = PublicationStatus.INACTIVE;
        this.deletedAt = now;
        this.updatedAt = now;
    }

    public void setPrimaryMediaId(String primaryMediaId, Instant now) {
        this.primaryMediaId = primaryMediaId;
        this.updatedAt = now;
    }

    public String getId() { return id; }
    public String getCategoryId() { return categoryId; }
    public String getProducerId() { return producerId; }
    public String getName() { return name; }
    public String getSlug() { return slug; }
    public String getShortDescription() { return shortDescription; }
    public String getDescription() { return description; }
    public String getStorageInstructions() { return storageInstructions; }
    public String getOrigin() { return origin; }
    public PublicationStatus getStatus() { return status; }
    public String getSeoTitle() { return seoTitle; }
    public String getSeoDescription() { return seoDescription; }
    public String getPrimaryMediaId() { return primaryMediaId; }
    public long getVersion() { return version; }
    public Instant getCreatedAt() { return createdAt; }
    public Instant getUpdatedAt() { return updatedAt; }
    public Instant getDeletedAt() { return deletedAt; }
}
