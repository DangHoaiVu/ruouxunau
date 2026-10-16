package com.ruouxunau.content.api;

import com.ruouxunau.catalog.api.MediaResponse;
import com.ruouxunau.content.domain.ArticleStatus;

import java.time.Instant;

public record ArticleSummaryResponse(
        String id,
        String title,
        String slug,
        String excerpt,
        ArticleStatus status,
        ArticleCategoryResponse category,
        MediaResponse featuredMedia,
        String authorId,
        String authorName,
        Instant publishedAt,
        Instant createdAt,
        Instant updatedAt) {
}
