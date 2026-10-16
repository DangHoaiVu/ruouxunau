package com.ruouxunau.catalog.api;

import com.ruouxunau.catalog.domain.PublicationStatus;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record ProducerRequest(
        @NotBlank @Size(min = 2, max = 160) String name,
        @Size(max = 200) String legalName,
        @Size(max = 200) String origin,
        @Size(max = 1000) String contact,
        @NotNull PublicationStatus status) {
}
