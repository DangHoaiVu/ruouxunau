package com.ruouxunau.content.repository;

import com.ruouxunau.catalog.domain.PublicationStatus;
import com.ruouxunau.content.domain.ArticleCategoryEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ArticleCategoryRepository extends JpaRepository<ArticleCategoryEntity, String> {
    List<ArticleCategoryEntity> findAllByDeletedAtIsNullOrderBySortOrderAscNameAsc();
    List<ArticleCategoryEntity> findAllByStatusAndDeletedAtIsNullOrderBySortOrderAscNameAsc(PublicationStatus status);
    Optional<ArticleCategoryEntity> findByIdAndDeletedAtIsNull(String id);
    Optional<ArticleCategoryEntity> findBySlugAndDeletedAtIsNull(String slug);
    boolean existsBySlug(String slug);
    boolean existsBySlugAndIdNot(String slug, String id);
}
