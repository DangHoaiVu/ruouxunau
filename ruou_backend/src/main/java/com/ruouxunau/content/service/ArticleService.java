package com.ruouxunau.content.service;

import com.ruouxunau.catalog.api.MediaResponse;
import com.ruouxunau.catalog.domain.MediaEntity;
import com.ruouxunau.catalog.domain.PublicationStatus;
import com.ruouxunau.catalog.repository.MediaRepository;
import com.ruouxunau.content.api.ArticleCategoryRequest;
import com.ruouxunau.content.api.ArticleCategoryResponse;
import com.ruouxunau.content.api.ArticleDetailResponse;
import com.ruouxunau.content.api.ArticleRequest;
import com.ruouxunau.content.api.ArticleSummaryResponse;
import com.ruouxunau.content.domain.ArticleCategoryEntity;
import com.ruouxunau.content.domain.ArticleEntity;
import com.ruouxunau.content.domain.ArticleStatus;
import com.ruouxunau.content.repository.ArticleCategoryRepository;
import com.ruouxunau.content.repository.ArticleRepository;
import com.ruouxunau.identity.domain.UserEntity;
import com.ruouxunau.identity.repository.UserRepository;
import com.ruouxunau.shared.audit.AuditService;
import com.ruouxunau.shared.exception.BadRequestException;
import com.ruouxunau.shared.exception.ConflictException;
import com.ruouxunau.shared.exception.ResourceNotFoundException;
import com.ruouxunau.shared.persistence.IdGenerator;
import com.ruouxunau.shared.web.PageResponse;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Subquery;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Clock;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@Service
public class ArticleService {

    private final ArticleCategoryRepository categoryRepository;
    private final ArticleRepository articleRepository;
    private final MediaRepository mediaRepository;
    private final UserRepository userRepository;
    private final AuditService auditService;
    private final Clock clock;

    public ArticleService(ArticleCategoryRepository categoryRepository,
                          ArticleRepository articleRepository,
                          MediaRepository mediaRepository,
                          UserRepository userRepository,
                          AuditService auditService,
                          Clock clock) {
        this.categoryRepository = categoryRepository;
        this.articleRepository = articleRepository;
        this.mediaRepository = mediaRepository;
        this.userRepository = userRepository;
        this.auditService = auditService;
        this.clock = clock;
    }

    @Transactional(readOnly = true)
    public List<ArticleCategoryResponse> publicCategories() {
        return categoryRepository
                .findAllByStatusAndDeletedAtIsNullOrderBySortOrderAscNameAsc(PublicationStatus.ACTIVE)
                .stream().map(ArticleCategoryResponse::from).toList();
    }

    @Transactional(readOnly = true)
    public List<ArticleCategoryResponse> adminCategories() {
        return categoryRepository.findAllByDeletedAtIsNullOrderBySortOrderAscNameAsc()
                .stream().map(ArticleCategoryResponse::from).toList();
    }

    @Transactional
    public ArticleCategoryResponse createCategory(String actorId, ArticleCategoryRequest request) {
        ensureCategorySlugAvailable(request.slug(), null);
        Instant now = clock.instant();
        ArticleCategoryEntity entity = new ArticleCategoryEntity(
                IdGenerator.newUlid(clock), request.name().trim(), request.slug().trim(),
                nullableTrim(request.description()), request.status(), request.sortOrder(), now);
        ArticleCategoryResponse response = ArticleCategoryResponse.from(categoryRepository.save(entity));
        auditService.record(actorId, "ARTICLE_CATEGORY_CREATED", "ARTICLE_CATEGORY", entity.getId(), null, response);
        return response;
    }

    @Transactional
    public ArticleCategoryResponse updateCategory(String actorId, String id, ArticleCategoryRequest request) {
        ArticleCategoryEntity entity = loadCategory(id);
        ArticleCategoryResponse before = ArticleCategoryResponse.from(entity);
        ensureCategorySlugAvailable(request.slug(), id);
        entity.update(request.name().trim(), request.slug().trim(), nullableTrim(request.description()),
                request.status(), request.sortOrder(), clock.instant());
        ArticleCategoryResponse response = ArticleCategoryResponse.from(entity);
        auditService.record(actorId, "ARTICLE_CATEGORY_UPDATED", "ARTICLE_CATEGORY", id, before, response);
        return response;
    }

    @Transactional
    public void deleteCategory(String actorId, String id) {
        ArticleCategoryEntity entity = loadCategory(id);
        if (articleRepository.existsByCategoryIdAndDeletedAtIsNull(id)) {
            throw new ConflictException("ARTICLE_CATEGORY_IN_USE", "Chuyên mục đang có bài viết");
        }
        ArticleCategoryResponse before = ArticleCategoryResponse.from(entity);
        entity.softDelete(clock.instant());
        auditService.record(actorId, "ARTICLE_CATEGORY_DELETED", "ARTICLE_CATEGORY", id, before, null);
    }

    @Transactional(readOnly = true)
    public PageResponse<ArticleSummaryResponse> publicArticles(
            String query, String categorySlug, int page, int size, String sort) {
        String categoryId = resolvePublicCategoryId(categorySlug);
        boolean unknownCategory = categorySlug != null && !categorySlug.isBlank() && categoryId == null;
        Instant now = clock.instant();
        Specification<ArticleEntity> specification = (root, ignored, builder) -> {
            if (unknownCategory) return builder.disjunction();
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.isNull(root.get("deletedAt")));
            predicates.add(builder.equal(root.get("status"), ArticleStatus.PUBLISHED));
            predicates.add(builder.lessThanOrEqualTo(root.get("publishedAt"), now));
            if (categoryId != null) predicates.add(builder.equal(root.get("categoryId"), categoryId));
            if (query != null && !query.isBlank()) {
                String pattern = "%" + query.trim().toLowerCase(Locale.ROOT) + "%";
                predicates.add(builder.or(
                        builder.like(builder.lower(root.get("title")), pattern),
                        builder.like(builder.lower(root.get("excerpt")), pattern)));
            }
            Subquery<String> activeCategory = ignored.subquery(String.class);
            var category = activeCategory.from(ArticleCategoryEntity.class);
            activeCategory.select(category.get("id")).where(
                    builder.equal(category.get("id"), root.get("categoryId")),
                    builder.equal(category.get("status"), PublicationStatus.ACTIVE),
                    builder.isNull(category.get("deletedAt")));
            predicates.add(builder.exists(activeCategory));
            return builder.and(predicates.toArray(Predicate[]::new));
        };
        Page<ArticleEntity> articles = articleRepository.findAll(
                specification, PageRequest.of(page, size, articleSort(sort)));
        return PageResponse.from(articles, this::summary);
    }

    @Transactional(readOnly = true)
    public ArticleDetailResponse publicArticle(String slug) {
        Instant now = clock.instant();
        ArticleEntity article = articleRepository.findBySlugAndDeletedAtIsNull(slug)
                .filter(item -> item.getStatus() == ArticleStatus.PUBLISHED)
                .filter(item -> item.getPublishedAt() != null && !item.getPublishedAt().isAfter(now))
                .orElseThrow(() -> new ResourceNotFoundException("ARTICLE_NOT_FOUND", "Không tìm thấy bài viết"));
        ArticleCategoryEntity category = loadCategory(article.getCategoryId());
        if (category.getStatus() != PublicationStatus.ACTIVE) {
            throw new ResourceNotFoundException("ARTICLE_NOT_FOUND", "Không tìm thấy bài viết");
        }
        return detail(article);
    }

    @Transactional(readOnly = true)
    public PageResponse<ArticleSummaryResponse> adminArticles(
            String query, ArticleStatus status, int page, int size, String sort) {
        Specification<ArticleEntity> specification = (root, ignored, builder) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.isNull(root.get("deletedAt")));
            if (status != null) predicates.add(builder.equal(root.get("status"), status));
            if (query != null && !query.isBlank()) {
                String pattern = "%" + query.trim().toLowerCase(Locale.ROOT) + "%";
                predicates.add(builder.or(
                        builder.like(builder.lower(root.get("title")), pattern),
                        builder.like(builder.lower(root.get("slug")), pattern)));
            }
            return builder.and(predicates.toArray(Predicate[]::new));
        };
        Page<ArticleEntity> articles = articleRepository.findAll(
                specification, PageRequest.of(page, size, articleSort(sort)));
        return PageResponse.from(articles, this::summary);
    }

    @Transactional(readOnly = true)
    public ArticleDetailResponse adminArticle(String id) {
        return detail(loadArticle(id));
    }

    @Transactional
    public ArticleDetailResponse create(String actorId, ArticleRequest request) {
        validateReferences(request.categoryId(), request.featuredMediaId());
        ensureArticleSlugAvailable(request.slug(), null);
        Instant now = clock.instant();
        ArticleEntity entity = new ArticleEntity(
                IdGenerator.newUlid(clock), actorId, request.categoryId(), nullableTrim(request.featuredMediaId()),
                request.title().trim(), request.slug().trim(), request.excerpt().trim(), request.content().trim(),
                nullableTrim(request.seoTitle()), nullableTrim(request.seoDescription()), now);
        articleRepository.save(entity);
        ArticleDetailResponse response = detail(entity);
        auditService.record(actorId, "ARTICLE_CREATED", "ARTICLE", entity.getId(), null, response);
        return response;
    }

    @Transactional
    public ArticleDetailResponse update(String actorId, String id, ArticleRequest request) {
        ArticleEntity entity = loadArticle(id);
        ArticleDetailResponse before = detail(entity);
        validateReferences(request.categoryId(), request.featuredMediaId());
        ensureArticleSlugAvailable(request.slug(), id);
        entity.update(request.categoryId(), nullableTrim(request.featuredMediaId()), request.title().trim(),
                request.slug().trim(), request.excerpt().trim(), request.content().trim(),
                nullableTrim(request.seoTitle()), nullableTrim(request.seoDescription()), clock.instant());
        ArticleDetailResponse response = detail(entity);
        auditService.record(actorId, "ARTICLE_UPDATED", "ARTICLE", id, before, response);
        return response;
    }

    @Transactional
    public ArticleDetailResponse submitForReview(String actorId, String id) {
        ArticleEntity entity = loadArticle(id);
        if (entity.getStatus() != ArticleStatus.DRAFT) {
            throw new ConflictException("INVALID_ARTICLE_TRANSITION", "Chỉ bài nháp mới được gửi duyệt");
        }
        ArticleDetailResponse before = detail(entity);
        entity.submitForReview(clock.instant());
        ArticleDetailResponse response = detail(entity);
        auditService.record(actorId, "ARTICLE_SUBMITTED_FOR_REVIEW", "ARTICLE", id, before, response);
        return response;
    }

    @Transactional
    public ArticleDetailResponse publish(String actorId, String id) {
        ArticleEntity entity = loadArticle(id);
        if (entity.getStatus() != ArticleStatus.REVIEW) {
            throw new ConflictException("INVALID_ARTICLE_TRANSITION", "Chỉ bài đang chờ duyệt mới được xuất bản");
        }
        ArticleCategoryEntity category = loadCategory(entity.getCategoryId());
        if (category.getStatus() != PublicationStatus.ACTIVE) {
            throw new ConflictException("ARTICLE_CATEGORY_INACTIVE", "Phải kích hoạt chuyên mục trước khi xuất bản bài viết");
        }
        ArticleDetailResponse before = detail(entity);
        entity.publish(clock.instant());
        ArticleDetailResponse response = detail(entity);
        auditService.record(actorId, "ARTICLE_PUBLISHED", "ARTICLE", id, before, response);
        return response;
    }

    @Transactional
    public ArticleDetailResponse archive(String actorId, String id) {
        ArticleEntity entity = loadArticle(id);
        ArticleDetailResponse before = detail(entity);
        entity.archive(clock.instant());
        ArticleDetailResponse response = detail(entity);
        auditService.record(actorId, "ARTICLE_ARCHIVED", "ARTICLE", id, before, response);
        return response;
    }

    @Transactional
    public void delete(String actorId, String id) {
        ArticleEntity entity = loadArticle(id);
        ArticleDetailResponse before = detail(entity);
        entity.softDelete(clock.instant());
        auditService.record(actorId, "ARTICLE_DELETED", "ARTICLE", id, before, null);
    }

    private ArticleSummaryResponse summary(ArticleEntity article) {
        ArticleCategoryResponse category = ArticleCategoryResponse.from(loadCategory(article.getCategoryId()));
        UserEntity author = loadAuthor(article.getAuthorId());
        return new ArticleSummaryResponse(
                article.getId(), article.getTitle(), article.getSlug(), article.getExcerpt(), article.getStatus(),
                category, media(article.getFeaturedMediaId()), author.getId(), author.getFullName(),
                article.getPublishedAt(), article.getCreatedAt(), article.getUpdatedAt());
    }

    private ArticleDetailResponse detail(ArticleEntity article) {
        ArticleCategoryResponse category = ArticleCategoryResponse.from(loadCategory(article.getCategoryId()));
        UserEntity author = loadAuthor(article.getAuthorId());
        return new ArticleDetailResponse(
                article.getId(), article.getTitle(), article.getSlug(), article.getExcerpt(), article.getContent(),
                article.getStatus(), category, media(article.getFeaturedMediaId()), author.getId(), author.getFullName(),
                article.getSeoTitle(), article.getSeoDescription(), article.getPublishedAt(), article.getVersion(),
                article.getCreatedAt(), article.getUpdatedAt());
    }

    private MediaResponse media(String id) {
        if (id == null) return null;
        return mediaRepository.findById(id).map(MediaResponse::from).orElse(null);
    }

    private void validateReferences(String categoryId, String featuredMediaId) {
        loadCategory(categoryId);
        if (featuredMediaId != null && !featuredMediaId.isBlank() && !mediaRepository.existsById(featuredMediaId)) {
            throw new ResourceNotFoundException("MEDIA_NOT_FOUND", "Không tìm thấy ảnh đại diện");
        }
    }

    private String resolvePublicCategoryId(String slug) {
        if (slug == null || slug.isBlank()) return null;
        return categoryRepository.findBySlugAndDeletedAtIsNull(slug.trim())
                .filter(category -> category.getStatus() == PublicationStatus.ACTIVE)
                .map(ArticleCategoryEntity::getId).orElse(null);
    }

    private Sort articleSort(String sort) {
        return switch (sort == null ? "newest" : sort) {
            case "newest" -> Sort.by(Sort.Direction.DESC, "publishedAt", "createdAt");
            case "oldest" -> Sort.by(Sort.Direction.ASC, "publishedAt", "createdAt");
            case "title-asc" -> Sort.by(Sort.Direction.ASC, "title");
            case "title-desc" -> Sort.by(Sort.Direction.DESC, "title");
            default -> throw new BadRequestException("INVALID_SORT", "Kiểu sắp xếp không được hỗ trợ");
        };
    }

    private void ensureCategorySlugAvailable(String slug, String currentId) {
        boolean exists = currentId == null ? categoryRepository.existsBySlug(slug.trim())
                : categoryRepository.existsBySlugAndIdNot(slug.trim(), currentId);
        if (exists) throw new ConflictException("ARTICLE_CATEGORY_SLUG_EXISTS", "Slug chuyên mục đã tồn tại");
    }

    private void ensureArticleSlugAvailable(String slug, String currentId) {
        boolean exists = currentId == null ? articleRepository.existsBySlug(slug.trim())
                : articleRepository.existsBySlugAndIdNot(slug.trim(), currentId);
        if (exists) throw new ConflictException("ARTICLE_SLUG_EXISTS", "Slug bài viết đã tồn tại");
    }

    private ArticleCategoryEntity loadCategory(String id) {
        return categoryRepository.findByIdAndDeletedAtIsNull(id)
                .orElseThrow(() -> new ResourceNotFoundException("ARTICLE_CATEGORY_NOT_FOUND", "Không tìm thấy chuyên mục"));
    }

    private ArticleEntity loadArticle(String id) {
        return articleRepository.findByIdAndDeletedAtIsNull(id)
                .orElseThrow(() -> new ResourceNotFoundException("ARTICLE_NOT_FOUND", "Không tìm thấy bài viết"));
    }

    private UserEntity loadAuthor(String id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("AUTHOR_NOT_FOUND", "Không tìm thấy tác giả"));
    }

    private static String nullableTrim(String value) {
        return value == null || value.isBlank() ? null : value.trim();
    }
}
