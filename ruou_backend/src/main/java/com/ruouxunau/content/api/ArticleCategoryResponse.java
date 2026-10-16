package com.ruouxunau.content.api;

import com.ruouxunau.catalog.domain.PublicationStatus;
import com.ruouxunau.content.domain.ArticleCategoryEntity;

import java.time.Instant;

public record ArticleCategoryResponse(
        String id,
        String name,
        String slug,
        String description,
        PublicationStatus status,
        int sortOrder,
        long version,
        Instant createdAt,
        Instant updatedAt) {

    public static ArticleCategoryResponse from(ArticleCategoryEntity category) {
        return new ArticleCategoryResponse(
                category.getId(), category.getName(), category.getSlug(), category.getDescription(),
                category.getStatus(), category.getSortOrder(), category.getVersion(),
                category.getCreatedAt(), category.getUpdatedAt());
    }
}
