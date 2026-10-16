package com.ruouxunau.catalog.api;

import com.ruouxunau.catalog.domain.MediaEntity;
import com.ruouxunau.catalog.domain.MediaCategory;

import java.time.Instant;

public record MediaResponse(
        String id,
        String url,
        String mimeType,
        MediaCategory category,
        String originalFilename,
        Integer width,
        Integer height,
        String altText,
        String checksum,
        Instant createdAt) {

    public static MediaResponse from(MediaEntity media) {
        return new MediaResponse(
                media.getId(), media.getUrl(), media.getMimeType(), media.getCategory(), media.getOriginalFilename(), media.getWidth(), media.getHeight(),
                media.getAltText(), media.getChecksum(), media.getCreatedAt());
    }
}
