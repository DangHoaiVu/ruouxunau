package com.ruouxunau.catalog.repository;

import com.ruouxunau.catalog.domain.ProductImageEntity;
import com.ruouxunau.catalog.domain.ProductImageId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ProductImageRepository extends JpaRepository<ProductImageEntity, ProductImageId> {
    List<ProductImageEntity> findAllByProductIdOrderBySortOrderAsc(String productId);
    boolean existsByMediaId(String mediaId);

    @Modifying(flushAutomatically = true)
    @Query("update ProductImageEntity image set image.primary = false where image.productId = :productId and image.primary = true")
    int clearPrimary(@Param("productId") String productId);
}
