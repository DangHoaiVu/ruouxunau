package com.ruouxunau.catalog.api;

import com.ruouxunau.catalog.domain.PublicationStatus;

import java.time.Instant;
import java.util.List;

public record ProductDetailResponse(
        String id,
        String name,
        String slug,
        String shortDescription,
        String description,
        String storageInstructions,
        String origin,
        PublicationStatus status,
        String seoTitle,
        String seoDescription,
        CategoryResponse category,
        ProducerResponse producer,
        List<VariantResponse> variants,
        List<ProductImageResponse> images,
        long version,
        Instant createdAt,
        Instant updatedAt) {
}
