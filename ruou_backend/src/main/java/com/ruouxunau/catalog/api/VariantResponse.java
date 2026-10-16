package com.ruouxunau.catalog.api;

import com.ruouxunau.catalog.domain.ProductVariantEntity;
import com.ruouxunau.catalog.domain.PublicationStatus;

import java.math.BigDecimal;
import java.time.Instant;

public record VariantResponse(
        String id,
        String productId,
        String sku,
        String barcode,
        int volumeMl,
        BigDecimal alcoholPercent,
        BigDecimal price,
        BigDecimal comparePrice,
        int weightGram,
        PublicationStatus status,
        long version,
        Instant createdAt,
        Instant updatedAt) {

    public static VariantResponse from(ProductVariantEntity variant) {
        return new VariantResponse(
                variant.getId(), variant.getProductId(), variant.getSku(), variant.getBarcode(),
                variant.getVolumeMl(), variant.getAlcoholPercent(), variant.getPrice(),
                variant.getComparePrice(), variant.getWeightGram(), variant.getStatus(),
                variant.getVersion(), variant.getCreatedAt(), variant.getUpdatedAt());
    }
}
