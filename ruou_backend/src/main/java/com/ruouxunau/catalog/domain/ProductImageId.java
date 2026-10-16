package com.ruouxunau.catalog.domain;

import java.io.Serializable;
import java.util.Objects;

public class ProductImageId implements Serializable {
    private String productId;
    private String mediaId;

    public ProductImageId() {
    }

    public ProductImageId(String productId, String mediaId) {
        this.productId = productId;
        this.mediaId = mediaId;
    }

    @Override
    public boolean equals(Object value) {
        if (this == value) return true;
        if (!(value instanceof ProductImageId other)) return false;
        return Objects.equals(productId, other.productId) && Objects.equals(mediaId, other.mediaId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(productId, mediaId);
    }
}
