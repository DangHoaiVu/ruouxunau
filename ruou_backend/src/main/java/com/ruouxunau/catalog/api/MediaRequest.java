package com.ruouxunau.catalog.api;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record MediaRequest(
        @NotBlank @Size(max = 2048) String url,
        @NotBlank @Size(max = 100) String mimeType,
        @Min(1) Integer width,
        @Min(1) Integer height,
        @NotBlank @Size(max = 255) String altText,
        @Pattern(regexp = "[A-Fa-f0-9]{64}", message = "checksum phải là SHA-256 dạng hex") String checksum) {
}
