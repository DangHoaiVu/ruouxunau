package com.ruouxunau.catalog.api;

import com.ruouxunau.catalog.domain.CategoryEntity;
import com.ruouxunau.catalog.domain.PublicationStatus;

import java.time.Instant;

public record CategoryResponse(
        String id,
        String name,
        String slug,
        String description,
        PublicationStatus status,
        int sortOrder,
        long version,
        Instant createdAt,
        Instant updatedAt) {

    public static CategoryResponse from(CategoryEntity category) {
        return new CategoryResponse(
                category.getId(), category.getName(), category.getSlug(), category.getDescription(),
                category.getStatus(), category.getSortOrder(), category.getVersion(),
                category.getCreatedAt(), category.getUpdatedAt());
    }
}
