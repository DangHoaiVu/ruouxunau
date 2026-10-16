package com.ruouxunau.content.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Version;

import java.time.Instant;

@Entity
@Table(name = "articles")
public class ArticleEntity {

    @Id
    @Column(length = 26, nullable = false, updatable = false)
    private String id;

    @Column(name = "author_id", length = 26, nullable = false, updatable = false)
    private String authorId;

    @Column(name = "category_id", length = 26, nullable = false)
    private String categoryId;

    @Column(name = "featured_media_id", length = 26)
    private String featuredMediaId;

    @Column(length = 220, nullable = false)
    private String title;

    @Column(length = 240, nullable = false, unique = true)
    private String slug;

    @Column(length = 600, nullable = false)
    private String excerpt;

    @Column(columnDefinition = "LONGTEXT", nullable = false)
    private String content;

    @Enumerated(EnumType.STRING)
    @Column(length = 20, nullable = false)
    private ArticleStatus status;

    @Column(name = "published_at")
    private Instant publishedAt;

    @Column(name = "seo_title", length = 180)
    private String seoTitle;

    @Column(name = "seo_description", length = 320)
    private String seoDescription;

    @Version
    @Column(nullable = false)
    private long version;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    @Column(name = "deleted_at")
    private Instant deletedAt;

    protected ArticleEntity() {
    }

    public ArticleEntity(String id, String authorId, String categoryId, String featuredMediaId,
                         String title, String slug, String excerpt, String content,
                         String seoTitle, String seoDescription, Instant now) {
        this.id = id;
        this.authorId = authorId;
        this.status = ArticleStatus.DRAFT;
        this.createdAt = now;
        update(categoryId, featuredMediaId, title, slug, excerpt, content, seoTitle, seoDescription, now);
    }

    public void update(String categoryId, String featuredMediaId, String title, String slug,
                       String excerpt, String content, String seoTitle, String seoDescription, Instant now) {
        this.categoryId = categoryId;
        this.featuredMediaId = featuredMediaId;
        this.title = title;
        this.slug = slug;
        this.excerpt = excerpt;
        this.content = content;
        this.seoTitle = seoTitle;
        this.seoDescription = seoDescription;
        this.updatedAt = now;
    }

    public void submitForReview(Instant now) {
        status = ArticleStatus.REVIEW;
        updatedAt = now;
    }

    public void publish(Instant now) {
        status = ArticleStatus.PUBLISHED;
        publishedAt = now;
        updatedAt = now;
    }

    public void archive(Instant now) {
        status = ArticleStatus.ARCHIVED;
        updatedAt = now;
    }

    public void softDelete(Instant now) {
        status = ArticleStatus.ARCHIVED;
        deletedAt = now;
        updatedAt = now;
    }

    public String getId() { return id; }
    public String getAuthorId() { return authorId; }
    public String getCategoryId() { return categoryId; }
    public String getFeaturedMediaId() { return featuredMediaId; }
    public String getTitle() { return title; }
    public String getSlug() { return slug; }
    public String getExcerpt() { return excerpt; }
    public String getContent() { return content; }
    public ArticleStatus getStatus() { return status; }
    public Instant getPublishedAt() { return publishedAt; }
    public String getSeoTitle() { return seoTitle; }
    public String getSeoDescription() { return seoDescription; }
    public long getVersion() { return version; }
    public Instant getCreatedAt() { return createdAt; }
    public Instant getUpdatedAt() { return updatedAt; }
    public Instant getDeletedAt() { return deletedAt; }
}
