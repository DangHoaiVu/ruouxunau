package com.ruouxunau.catalog.api;

public record ProductImageResponse(
        String mediaId,
        String url,
        String altText,
        Integer width,
        Integer height,
        int sortOrder,
        boolean primary) {
}
