package com.ruouxunau.content.api;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record ArticleRequest(
        @NotBlank @Size(max = 26) String categoryId,
        @Size(max = 26) String featuredMediaId,
        @NotBlank @Size(min = 3, max = 220) String title,
        @NotBlank @Size(max = 240)
        @Pattern(regexp = "[a-z0-9]+(?:-[a-z0-9]+)*", message = "slug chỉ gồm chữ thường, số và dấu gạch ngang")
        String slug,
        @NotBlank @Size(max = 600) String excerpt,
        @NotBlank String content,
        @Size(max = 180) String seoTitle,
        @Size(max = 320) String seoDescription) {
}
