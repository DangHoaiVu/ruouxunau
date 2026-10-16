package com.ruouxunau.catalog.api;

import com.ruouxunau.catalog.domain.PublicationStatus;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record ProductRequest(
        @NotBlank @Size(max = 26) String categoryId,
        @Size(max = 26) String producerId,
        @NotBlank @Size(min = 2, max = 180) String name,
        @NotBlank @Size(max = 200)
        @Pattern(regexp = "[a-z0-9]+(?:-[a-z0-9]+)*", message = "slug chỉ gồm chữ thường, số và dấu gạch ngang")
        String slug,
        @Size(max = 500) String shortDescription,
        @NotBlank String description,
        @Size(max = 1000) String storageInstructions,
        @Size(max = 200) String origin,
        @NotNull PublicationStatus status,
        @Size(max = 180) String seoTitle,
        @Size(max = 320) String seoDescription) {
}
