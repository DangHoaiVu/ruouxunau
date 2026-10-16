package com.ruouxunau.content.repository;

import com.ruouxunau.content.domain.ArticleEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.Optional;

public interface ArticleRepository extends JpaRepository<ArticleEntity, String>, JpaSpecificationExecutor<ArticleEntity> {
    Optional<ArticleEntity> findByIdAndDeletedAtIsNull(String id);
    Optional<ArticleEntity> findBySlugAndDeletedAtIsNull(String slug);
    boolean existsBySlug(String slug);
    boolean existsBySlugAndIdNot(String slug, String id);
    boolean existsByCategoryIdAndDeletedAtIsNull(String categoryId);
    boolean existsByFeaturedMediaId(String featuredMediaId);
}
