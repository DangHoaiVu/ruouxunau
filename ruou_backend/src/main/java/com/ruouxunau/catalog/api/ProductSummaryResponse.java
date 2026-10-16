package com.ruouxunau.catalog.api;

import com.ruouxunau.catalog.domain.PublicationStatus;

import java.math.BigDecimal;
import java.time.Instant;

public record ProductSummaryResponse(
        String id,
        String name,
        String slug,
        String shortDescription,
        String origin,
        PublicationStatus status,
        CategoryResponse category,
        ProducerResponse producer,
        BigDecimal minPrice,
        BigDecimal maxPrice,
        int variantCount,
        String primaryImageUrl,
        Instant createdAt,
        Instant updatedAt) {
}
