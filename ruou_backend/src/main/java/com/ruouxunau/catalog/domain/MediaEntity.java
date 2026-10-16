package com.ruouxunau.catalog.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.time.Instant;

@Entity
@Table(name = "media")
public class MediaEntity {

    @Id
    @Column(length = 26, nullable = false, updatable = false)
    private String id;

    @Column(length = 2048, nullable = false)
    private String url;

    @Column(name = "storage_key", length = 500, unique = true)
    private String storageKey;

    @Column(name = "mime_type", length = 100, nullable = false)
    private String mimeType;

    @Enumerated(EnumType.STRING)
    @Column(length = 20, nullable = false)
    private MediaCategory category;

    @Column(name = "original_filename", length = 255)
    private String originalFilename;

    private Integer width;
    private Integer height;

    @Column(name = "alt_text", length = 255, nullable = false)
    private String altText;

    @Column(length = 64)
    private String checksum;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    protected MediaEntity() {
    }

    public MediaEntity(String id, String url, String storageKey, String mimeType,
                       MediaCategory category, String originalFilename,
                       Integer width, Integer height, String altText, String checksum, Instant now) {
        this.id = id;
        this.storageKey = storageKey;
        this.category = category;
        this.originalFilename = originalFilename;
        this.createdAt = now;
        update(url, mimeType, width, height, altText, checksum);
    }

    public void update(String url, String mimeType, Integer width, Integer height,
                       String altText, String checksum) {
        this.url = url;
        this.mimeType = mimeType;
        this.width = width;
        this.height = height;
        this.altText = altText;
        this.checksum = checksum;
    }

    public String getId() { return id; }
    public String getUrl() { return url; }
    public String getStorageKey() { return storageKey; }
    public String getMimeType() { return mimeType; }
    public MediaCategory getCategory() { return category; }
    public String getOriginalFilename() { return originalFilename; }
    public Integer getWidth() { return width; }
    public Integer getHeight() { return height; }
    public String getAltText() { return altText; }
    public String getChecksum() { return checksum; }
    public Instant getCreatedAt() { return createdAt; }

    public void updateMetadata(MediaCategory category, String originalFilename, String altText) {
        this.category = category;
        this.originalFilename = originalFilename;
        this.altText = altText;
    }
}
