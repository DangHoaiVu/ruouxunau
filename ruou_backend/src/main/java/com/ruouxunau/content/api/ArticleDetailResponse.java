package com.ruouxunau.content.api;

import com.ruouxunau.catalog.api.MediaResponse;
import com.ruouxunau.content.domain.ArticleStatus;

import java.time.Instant;

public record ArticleDetailResponse(
        String id,
        String title,
        String slug,
        String excerpt,
        String content,
        ArticleStatus status,
        ArticleCategoryResponse category,
        MediaResponse featuredMedia,
        String authorId,
        String authorName,
        String seoTitle,
        String seoDescription,
        Instant publishedAt,
        long version,
        Instant createdAt,
        Instant updatedAt) {
}
