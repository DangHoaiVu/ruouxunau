package com.ruouxunau.catalog.api;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record ProductImageRequest(
        @NotBlank @Size(max = 26) String mediaId,
        @Min(0) int sortOrder,
        boolean primary) {
}
