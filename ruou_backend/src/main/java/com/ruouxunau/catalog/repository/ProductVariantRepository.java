package com.ruouxunau.catalog.repository;

import com.ruouxunau.catalog.domain.ProductVariantEntity;
import com.ruouxunau.catalog.domain.PublicationStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ProductVariantRepository extends JpaRepository<ProductVariantEntity, String> {
    List<ProductVariantEntity> findAllByProductIdAndDeletedAtIsNullOrderByVolumeMlAsc(String productId);
    List<ProductVariantEntity> findAllByProductIdAndStatusAndDeletedAtIsNullOrderByVolumeMlAsc(
            String productId, PublicationStatus status);
    Optional<ProductVariantEntity> findByIdAndDeletedAtIsNull(String id);
    boolean existsBySku(String sku);
    boolean existsBySkuAndIdNot(String sku, String id);
    boolean existsByBarcode(String barcode);
    boolean existsByBarcodeAndIdNot(String barcode, String id);
}
