package com.ruouxunau.catalog.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;

@Entity
@IdClass(ProductImageId.class)
@Table(name = "product_images")
public class ProductImageEntity {

    @Id
    @Column(name = "product_id", length = 26, nullable = false, updatable = false)
    private String productId;

    @Id
    @Column(name = "media_id", length = 26, nullable = false, updatable = false)
    private String mediaId;

    @Column(name = "sort_order", nullable = false)
    private int sortOrder;

    @Column(name = "is_primary", nullable = false)
    private boolean primary;

    protected ProductImageEntity() {
    }

    public ProductImageEntity(String productId, String mediaId, int sortOrder, boolean primary) {
        this.productId = productId;
        this.mediaId = mediaId;
        update(sortOrder, primary);
    }

    public void update(int sortOrder, boolean primary) {
        this.sortOrder = sortOrder;
        this.primary = primary;
    }

    public String getProductId() { return productId; }
    public String getMediaId() { return mediaId; }
    public int getSortOrder() { return sortOrder; }
    public boolean isPrimary() { return primary; }
}
