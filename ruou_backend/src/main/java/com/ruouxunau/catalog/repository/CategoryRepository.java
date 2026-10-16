package com.ruouxunau.catalog.repository;

import com.ruouxunau.catalog.domain.CategoryEntity;
import com.ruouxunau.catalog.domain.PublicationStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface CategoryRepository extends JpaRepository<CategoryEntity, String> {
    List<CategoryEntity> findAllByDeletedAtIsNullOrderBySortOrderAscNameAsc();
    List<CategoryEntity> findAllByStatusAndDeletedAtIsNullOrderBySortOrderAscNameAsc(PublicationStatus status);
    Optional<CategoryEntity> findByIdAndDeletedAtIsNull(String id);
    Optional<CategoryEntity> findBySlugAndDeletedAtIsNull(String slug);
    boolean existsBySlugAndIdNot(String slug, String id);
    boolean existsBySlug(String slug);
}
