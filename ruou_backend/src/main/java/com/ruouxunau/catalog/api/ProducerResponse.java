package com.ruouxunau.catalog.api;

import com.ruouxunau.catalog.domain.ProducerEntity;
import com.ruouxunau.catalog.domain.PublicationStatus;

import java.time.Instant;

public record ProducerResponse(
        String id,
        String name,
        String legalName,
        String origin,
        String contact,
        PublicationStatus status,
        long version,
        Instant createdAt,
        Instant updatedAt) {

    public static ProducerResponse from(ProducerEntity producer) {
        return new ProducerResponse(
                producer.getId(), producer.getName(), producer.getLegalName(), producer.getOrigin(),
                producer.getContact(), producer.getStatus(), producer.getVersion(),
                producer.getCreatedAt(), producer.getUpdatedAt());
    }
}
