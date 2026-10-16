package com.ruouxunau.catalog.repository;

import com.ruouxunau.catalog.domain.ProductEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.Optional;

public interface ProductRepository extends JpaRepository<ProductEntity, String>, JpaSpecificationExecutor<ProductEntity> {
    Optional<ProductEntity> findByIdAndDeletedAtIsNull(String id);
    Optional<ProductEntity> findBySlugAndDeletedAtIsNull(String slug);
    boolean existsBySlug(String slug);
    boolean existsBySlugAndIdNot(String slug, String id);
    boolean existsByCategoryIdAndDeletedAtIsNull(String categoryId);
    boolean existsByProducerIdAndDeletedAtIsNull(String producerId);
    boolean existsByPrimaryMediaId(String primaryMediaId);
}
