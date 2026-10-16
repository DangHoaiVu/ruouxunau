package com.ruouxunau.catalog.api;

import com.ruouxunau.catalog.domain.PublicationStatus;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record CategoryRequest(
        @NotBlank @Size(min = 2, max = 120) String name,
        @NotBlank @Size(max = 140)
        @Pattern(regexp = "[a-z0-9]+(?:-[a-z0-9]+)*", message = "slug chỉ gồm chữ thường, số và dấu gạch ngang")
        String slug,
        @Size(max = 500) String description,
        @NotNull PublicationStatus status,
        @Min(0) int sortOrder) {
}
