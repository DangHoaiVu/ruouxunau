package com.ruouxunau.catalog.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Version;

import java.math.BigDecimal;
import java.time.Instant;

@Entity
@Table(name = "product_variants")
public class ProductVariantEntity {

    @Id
    @Column(length = 26, nullable = false, updatable = false)
    private String id;

    @Column(name = "product_id", length = 26, nullable = false)
    private String productId;

    @Column(length = 80, nullable = false, unique = true)
    private String sku;

    @Column(length = 80, unique = true)
    private String barcode;

    @Column(name = "volume_ml", nullable = false)
    private int volumeMl;

    @Column(name = "alcohol_percent", precision = 5, scale = 2, nullable = false)
    private BigDecimal alcoholPercent;

    @Column(precision = 19, scale = 2, nullable = false)
    private BigDecimal price;

    @Column(name = "compare_price", precision = 19, scale = 2)
    private BigDecimal comparePrice;

    @Column(name = "weight_gram", nullable = false)
    private int weightGram;

    @Enumerated(EnumType.STRING)
    @Column(length = 20, nullable = false)
    private PublicationStatus status;

    @Version
    @Column(nullable = false)
    private long version;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    @Column(name = "deleted_at")
    private Instant deletedAt;

    protected ProductVariantEntity() {
    }

    public ProductVariantEntity(String id, String productId, String sku, String barcode,
                                int volumeMl, BigDecimal alcoholPercent, BigDecimal price,
                                BigDecimal comparePrice, int weightGram,
                                PublicationStatus status, Instant now) {
        this.id = id;
        this.productId = productId;
        this.createdAt = now;
        update(sku, barcode, volumeMl, alcoholPercent, price, comparePrice, weightGram, status, now);
    }

    public void update(String sku, String barcode, int volumeMl, BigDecimal alcoholPercent,
                       BigDecimal price, BigDecimal comparePrice, int weightGram,
                       PublicationStatus status, Instant now) {
        this.sku = sku;
        this.barcode = barcode;
        this.volumeMl = volumeMl;
        this.alcoholPercent = alcoholPercent;
        this.price = price;
        this.comparePrice = comparePrice;
        this.weightGram = weightGram;
        this.status = status;
        this.updatedAt = now;
    }

    public void softDelete(Instant now) {
        this.status = PublicationStatus.INACTIVE;
        this.deletedAt = now;
        this.updatedAt = now;
    }

    public String getId() { return id; }
    public String getProductId() { return productId; }
    public String getSku() { return sku; }
    public String getBarcode() { return barcode; }
    public int getVolumeMl() { return volumeMl; }
    public BigDecimal getAlcoholPercent() { return alcoholPercent; }
    public BigDecimal getPrice() { return price; }
    public BigDecimal getComparePrice() { return comparePrice; }
    public int getWeightGram() { return weightGram; }
    public PublicationStatus getStatus() { return status; }
    public long getVersion() { return version; }
    public Instant getCreatedAt() { return createdAt; }
    public Instant getUpdatedAt() { return updatedAt; }
    public Instant getDeletedAt() { return deletedAt; }
}
