package com.ruouxunau.catalog.service;

import com.ruouxunau.catalog.api.CategoryRequest;
import com.ruouxunau.catalog.api.CategoryResponse;
import com.ruouxunau.catalog.api.ProducerRequest;
import com.ruouxunau.catalog.api.ProducerResponse;
import com.ruouxunau.catalog.api.ProductDetailResponse;
import com.ruouxunau.catalog.api.ProductRequest;
import com.ruouxunau.catalog.api.ProductSummaryResponse;
import com.ruouxunau.catalog.api.VariantRequest;
import com.ruouxunau.catalog.api.VariantResponse;
import com.ruouxunau.catalog.domain.CategoryEntity;
import com.ruouxunau.catalog.domain.ProducerEntity;
import com.ruouxunau.catalog.domain.ProductEntity;
import com.ruouxunau.catalog.domain.ProductVariantEntity;
import com.ruouxunau.catalog.domain.PublicationStatus;
import com.ruouxunau.catalog.repository.CategoryRepository;
import com.ruouxunau.catalog.repository.ProducerRepository;
import com.ruouxunau.catalog.repository.ProductRepository;
import com.ruouxunau.catalog.repository.ProductVariantRepository;
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

import java.math.BigDecimal;
import java.time.Clock;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;

@Service
public class CatalogService {

    private final CategoryRepository categoryRepository;
    private final ProducerRepository producerRepository;
    private final ProductRepository productRepository;
    private final ProductVariantRepository variantRepository;
    private final MediaService mediaService;
    private final AuditService auditService;
    private final Clock clock;

    public CatalogService(CategoryRepository categoryRepository,
                          ProducerRepository producerRepository,
                          ProductRepository productRepository,
                          ProductVariantRepository variantRepository,
                          MediaService mediaService,
                          AuditService auditService,
                          Clock clock) {
        this.categoryRepository = categoryRepository;
        this.producerRepository = producerRepository;
        this.productRepository = productRepository;
        this.variantRepository = variantRepository;
        this.mediaService = mediaService;
        this.auditService = auditService;
        this.clock = clock;
    }

    @Transactional(readOnly = true)
    public List<CategoryResponse> publicCategories() {
        return categoryRepository
                .findAllByStatusAndDeletedAtIsNullOrderBySortOrderAscNameAsc(PublicationStatus.ACTIVE)
                .stream().map(CategoryResponse::from).toList();
    }

    @Transactional(readOnly = true)
    public List<CategoryResponse> adminCategories() {
        return categoryRepository.findAllByDeletedAtIsNullOrderBySortOrderAscNameAsc()
                .stream().map(CategoryResponse::from).toList();
    }

    @Transactional
    public CategoryResponse createCategory(String actorId, CategoryRequest request) {
        ensureCategorySlugAvailable(request.slug(), null);
        Instant now = clock.instant();
        CategoryEntity entity = new CategoryEntity(
                IdGenerator.newUlid(clock), request.name().trim(), request.slug().trim(),
                nullableTrim(request.description()), request.status(), request.sortOrder(), now);
        CategoryResponse response = CategoryResponse.from(categoryRepository.save(entity));
        auditService.record(actorId, "CATEGORY_CREATED", "CATEGORY", entity.getId(), null, response);
        return response;
    }

    @Transactional
    public CategoryResponse updateCategory(String actorId, String id, CategoryRequest request) {
        CategoryEntity entity = loadCategory(id);
        CategoryResponse before = CategoryResponse.from(entity);
        ensureCategorySlugAvailable(request.slug(), id);
        entity.update(request.name().trim(), request.slug().trim(), nullableTrim(request.description()),
                request.status(), request.sortOrder(), clock.instant());
        CategoryResponse response = CategoryResponse.from(entity);
        auditService.record(actorId, "CATEGORY_UPDATED", "CATEGORY", id, before, response);
        return response;
    }

    @Transactional
    public void deleteCategory(String actorId, String id) {
        CategoryEntity entity = loadCategory(id);
        if (productRepository.existsByCategoryIdAndDeletedAtIsNull(id)) {
            throw new ConflictException("CATEGORY_IN_USE", "Danh mục đang có sản phẩm, hãy chuyển sản phẩm trước khi xóa");
        }
        CategoryResponse before = CategoryResponse.from(entity);
        entity.softDelete(clock.instant());
        auditService.record(actorId, "CATEGORY_DELETED", "CATEGORY", id, before, null);
    }

    @Transactional(readOnly = true)
    public List<ProducerResponse> adminProducers() {
        return producerRepository.findAllByDeletedAtIsNullOrderByNameAsc()
                .stream().map(ProducerResponse::from).toList();
    }

    @Transactional
    public ProducerResponse createProducer(String actorId, ProducerRequest request) {
        Instant now = clock.instant();
        ProducerEntity entity = new ProducerEntity(
                IdGenerator.newUlid(clock), request.name().trim(), nullableTrim(request.legalName()),
                nullableTrim(request.origin()), nullableTrim(request.contact()), request.status(), now);
        ProducerResponse response = ProducerResponse.from(producerRepository.save(entity));
        auditService.record(actorId, "PRODUCER_CREATED", "PRODUCER", entity.getId(), null, response);
        return response;
    }

    @Transactional
    public ProducerResponse updateProducer(String actorId, String id, ProducerRequest request) {
        ProducerEntity entity = loadProducer(id);
        ProducerResponse before = ProducerResponse.from(entity);
        entity.update(request.name().trim(), nullableTrim(request.legalName()), nullableTrim(request.origin()),
                nullableTrim(request.contact()), request.status(), clock.instant());
        ProducerResponse response = ProducerResponse.from(entity);
        auditService.record(actorId, "PRODUCER_UPDATED", "PRODUCER", id, before, response);
        return response;
    }

    @Transactional
    public void deleteProducer(String actorId, String id) {
        ProducerEntity entity = loadProducer(id);
        if (productRepository.existsByProducerIdAndDeletedAtIsNull(id)) {
            throw new ConflictException("PRODUCER_IN_USE", "Cơ sở sản xuất đang được gắn với sản phẩm");
        }
        ProducerResponse before = ProducerResponse.from(entity);
        entity.softDelete(clock.instant());
        auditService.record(actorId, "PRODUCER_DELETED", "PRODUCER", id, before, null);
    }

    @Transactional(readOnly = true)
    public PageResponse<ProductSummaryResponse> publicProducts(
            String query, String categorySlug, BigDecimal minPrice, BigDecimal maxPrice,
            BigDecimal minAlcohol, BigDecimal maxAlcohol, Integer volumeMl,
            int page, int size, String sort) {
        validateRange(minPrice, maxPrice, "Khoảng giá không hợp lệ");
        validateRange(minAlcohol, maxAlcohol, "Khoảng nồng độ không hợp lệ");
        String categoryId = resolvePublicCategoryId(categorySlug);
        Specification<ProductEntity> specification = publicSpecification(
                query, categoryId, categorySlug != null && categoryId == null,
                minPrice, maxPrice, minAlcohol, maxAlcohol, volumeMl);
        Page<ProductEntity> products = productRepository.findAll(
                specification, PageRequest.of(page, size, productSort(sort)));
        return PageResponse.from(products, product -> summary(product, true));
    }

    @Transactional(readOnly = true)
    public ProductDetailResponse publicProduct(String slug) {
        ProductEntity product = productRepository.findBySlugAndDeletedAtIsNull(slug)
                .filter(item -> item.getStatus() == PublicationStatus.ACTIVE)
                .orElseThrow(() -> new ResourceNotFoundException("PRODUCT_NOT_FOUND", "Không tìm thấy sản phẩm"));
        CategoryEntity category = loadCategory(product.getCategoryId());
        if (category.getStatus() != PublicationStatus.ACTIVE) {
            throw new ResourceNotFoundException("PRODUCT_NOT_FOUND", "Không tìm thấy sản phẩm");
        }
        return detail(product, true);
    }

    @Transactional(readOnly = true)
    public PageResponse<ProductSummaryResponse> adminProducts(String query, PublicationStatus status,
                                                               int page, int size, String sort) {
        Specification<ProductEntity> specification = (root, ignored, builder) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.isNull(root.get("deletedAt")));
            if (status != null) predicates.add(builder.equal(root.get("status"), status));
            if (query != null && !query.isBlank()) {
                String pattern = "%" + query.trim().toLowerCase(Locale.ROOT) + "%";
                predicates.add(builder.or(
                        builder.like(builder.lower(root.get("name")), pattern),
                        builder.like(builder.lower(root.get("slug")), pattern)));
            }
            return builder.and(predicates.toArray(Predicate[]::new));
        };
        Page<ProductEntity> products = productRepository.findAll(
                specification, PageRequest.of(page, size, productSort(sort)));
        return PageResponse.from(products, product -> summary(product, false));
    }

    @Transactional(readOnly = true)
    public ProductDetailResponse adminProduct(String id) {
        return detail(loadProduct(id), false);
    }

    @Transactional
    public ProductDetailResponse createProduct(String actorId, ProductRequest request) {
        validateProductReferences(request.categoryId(), request.producerId());
        ensureProductSlugAvailable(request.slug(), null);
        Instant now = clock.instant();
        ProductEntity entity = new ProductEntity(
                IdGenerator.newUlid(clock), request.categoryId(), nullableTrim(request.producerId()),
                request.name().trim(), request.slug().trim(), nullableTrim(request.shortDescription()),
                request.description().trim(), nullableTrim(request.storageInstructions()), nullableTrim(request.origin()),
                request.status(), nullableTrim(request.seoTitle()), nullableTrim(request.seoDescription()), now);
        productRepository.save(entity);
        ProductDetailResponse response = detail(entity, false);
        auditService.record(actorId, "PRODUCT_CREATED", "PRODUCT", entity.getId(), null, response);
        return response;
    }

    @Transactional
    public ProductDetailResponse updateProduct(String actorId, String id, ProductRequest request) {
        ProductEntity entity = loadProduct(id);
        ProductDetailResponse before = detail(entity, false);
        validateProductReferences(request.categoryId(), request.producerId());
        ensureProductSlugAvailable(request.slug(), id);
        entity.update(request.categoryId(), nullableTrim(request.producerId()), request.name().trim(),
                request.slug().trim(), nullableTrim(request.shortDescription()), request.description().trim(),
                nullableTrim(request.storageInstructions()), nullableTrim(request.origin()), request.status(),
                nullableTrim(request.seoTitle()), nullableTrim(request.seoDescription()), clock.instant());
        ProductDetailResponse response = detail(entity, false);
        auditService.record(actorId, "PRODUCT_UPDATED", "PRODUCT", id, before, response);
        return response;
    }

    @Transactional
    public void deleteProduct(String actorId, String id) {
        ProductEntity entity = loadProduct(id);
        ProductDetailResponse before = detail(entity, false);
        Instant now = clock.instant();
        variantRepository.findAllByProductIdAndDeletedAtIsNullOrderByVolumeMlAsc(id)
                .forEach(variant -> variant.softDelete(now));
        entity.softDelete(now);
        auditService.record(actorId, "PRODUCT_DELETED", "PRODUCT", id, before, null);
    }

    @Transactional
    public VariantResponse createVariant(String actorId, VariantRequest request) {
        loadProduct(request.productId());
        ensureVariantKeysAvailable(request.sku(), request.barcode(), null);
        Instant now = clock.instant();
        ProductVariantEntity entity = new ProductVariantEntity(
                IdGenerator.newUlid(clock), request.productId(), request.sku().trim(), nullableTrim(request.barcode()),
                request.volumeMl(), request.alcoholPercent(), request.price(), request.comparePrice(),
                request.weightGram(), request.status(), now);
        VariantResponse response = VariantResponse.from(variantRepository.save(entity));
        auditService.record(actorId, "VARIANT_CREATED", "PRODUCT_VARIANT", entity.getId(), null, response);
        return response;
    }

    @Transactional
    public VariantResponse updateVariant(String actorId, String id, VariantRequest request) {
        ProductVariantEntity entity = loadVariant(id);
        if (!entity.getProductId().equals(request.productId())) {
            throw new BadRequestException("VARIANT_PRODUCT_IMMUTABLE", "Không thể chuyển biến thể sang sản phẩm khác");
        }
        VariantResponse before = VariantResponse.from(entity);
        ensureVariantKeysAvailable(request.sku(), request.barcode(), id);
        entity.update(request.sku().trim(), nullableTrim(request.barcode()), request.volumeMl(),
                request.alcoholPercent(), request.price(), request.comparePrice(), request.weightGram(),
                request.status(), clock.instant());
        VariantResponse response = VariantResponse.from(entity);
        auditService.record(actorId, "VARIANT_UPDATED", "PRODUCT_VARIANT", id, before, response);
        return response;
    }

    @Transactional
    public void deleteVariant(String actorId, String id) {
        ProductVariantEntity entity = loadVariant(id);
        VariantResponse before = VariantResponse.from(entity);
        entity.softDelete(clock.instant());
        auditService.record(actorId, "VARIANT_DELETED", "PRODUCT_VARIANT", id, before, null);
    }

    private ProductSummaryResponse summary(ProductEntity product, boolean publicOnly) {
        CategoryResponse category = CategoryResponse.from(loadCategory(product.getCategoryId()));
        ProducerResponse producer = product.getProducerId() == null ? null : ProducerResponse.from(loadProducer(product.getProducerId()));
        List<ProductVariantEntity> variants = variants(product.getId(), publicOnly);
        BigDecimal minPrice = variants.stream().map(ProductVariantEntity::getPrice).min(Comparator.naturalOrder()).orElse(null);
        BigDecimal maxPrice = variants.stream().map(ProductVariantEntity::getPrice).max(Comparator.naturalOrder()).orElse(null);
        return new ProductSummaryResponse(
                product.getId(), product.getName(), product.getSlug(), product.getShortDescription(),
                product.getOrigin(), product.getStatus(), category, producer, minPrice, maxPrice,
                variants.size(), mediaService.primaryUrl(product), product.getCreatedAt(), product.getUpdatedAt());
    }

    private ProductDetailResponse detail(ProductEntity product, boolean publicOnly) {
        CategoryResponse category = CategoryResponse.from(loadCategory(product.getCategoryId()));
        ProducerResponse producer = product.getProducerId() == null ? null : ProducerResponse.from(loadProducer(product.getProducerId()));
        List<VariantResponse> variants = variants(product.getId(), publicOnly).stream().map(VariantResponse::from).toList();
        return new ProductDetailResponse(
                product.getId(), product.getName(), product.getSlug(), product.getShortDescription(),
                product.getDescription(), product.getStorageInstructions(), product.getOrigin(), product.getStatus(),
                product.getSeoTitle(), product.getSeoDescription(), category, producer, variants,
                mediaService.images(product.getId()),
                product.getVersion(), product.getCreatedAt(), product.getUpdatedAt());
    }

    private List<ProductVariantEntity> variants(String productId, boolean publicOnly) {
        return publicOnly
                ? variantRepository.findAllByProductIdAndStatusAndDeletedAtIsNullOrderByVolumeMlAsc(productId, PublicationStatus.ACTIVE)
                : variantRepository.findAllByProductIdAndDeletedAtIsNullOrderByVolumeMlAsc(productId);
    }

    private Specification<ProductEntity> publicSpecification(
            String query, String categoryId, boolean unknownCategory,
            BigDecimal minPrice, BigDecimal maxPrice, BigDecimal minAlcohol,
            BigDecimal maxAlcohol, Integer volumeMl) {
        return (root, ignored, builder) -> {
            if (unknownCategory) return builder.disjunction();
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.isNull(root.get("deletedAt")));
            predicates.add(builder.equal(root.get("status"), PublicationStatus.ACTIVE));
            if (categoryId != null) predicates.add(builder.equal(root.get("categoryId"), categoryId));
            if (query != null && !query.isBlank()) {
                String pattern = "%" + query.trim().toLowerCase(Locale.ROOT) + "%";
                predicates.add(builder.or(
                        builder.like(builder.lower(root.get("name")), pattern),
                        builder.like(builder.lower(root.get("shortDescription")), pattern)));
            }

            Subquery<String> activeCategory = ignored.subquery(String.class);
            var category = activeCategory.from(CategoryEntity.class);
            activeCategory.select(category.get("id")).where(
                    builder.equal(category.get("id"), root.get("categoryId")),
                    builder.equal(category.get("status"), PublicationStatus.ACTIVE),
                    builder.isNull(category.get("deletedAt")));
            predicates.add(builder.exists(activeCategory));

            Subquery<String> sellableVariant = ignored.subquery(String.class);
            var variant = sellableVariant.from(ProductVariantEntity.class);
            List<Predicate> variantPredicates = new ArrayList<>();
            variantPredicates.add(builder.equal(variant.get("productId"), root.get("id")));
            variantPredicates.add(builder.isNull(variant.get("deletedAt")));
            variantPredicates.add(builder.equal(variant.get("status"), PublicationStatus.ACTIVE));
            if (minPrice != null) variantPredicates.add(builder.greaterThanOrEqualTo(variant.get("price"), minPrice));
            if (maxPrice != null) variantPredicates.add(builder.lessThanOrEqualTo(variant.get("price"), maxPrice));
            if (minAlcohol != null) variantPredicates.add(builder.greaterThanOrEqualTo(variant.get("alcoholPercent"), minAlcohol));
            if (maxAlcohol != null) variantPredicates.add(builder.lessThanOrEqualTo(variant.get("alcoholPercent"), maxAlcohol));
            if (volumeMl != null) variantPredicates.add(builder.equal(variant.get("volumeMl"), volumeMl));
            sellableVariant.select(variant.get("id")).where(variantPredicates.toArray(Predicate[]::new));
            predicates.add(builder.exists(sellableVariant));
            return builder.and(predicates.toArray(Predicate[]::new));
        };
    }

    private Sort productSort(String sort) {
        return switch (sort == null ? "newest" : sort) {
            case "newest" -> Sort.by(Sort.Direction.DESC, "createdAt");
            case "name-asc" -> Sort.by(Sort.Direction.ASC, "name");
            case "name-desc" -> Sort.by(Sort.Direction.DESC, "name");
            default -> throw new BadRequestException("INVALID_SORT", "Kiểu sắp xếp không được hỗ trợ");
        };
    }

    private String resolvePublicCategoryId(String slug) {
        if (slug == null || slug.isBlank()) return null;
        return categoryRepository.findBySlugAndDeletedAtIsNull(slug.trim())
                .filter(category -> category.getStatus() == PublicationStatus.ACTIVE)
                .map(CategoryEntity::getId).orElse(null);
    }

    private void validateProductReferences(String categoryId, String producerId) {
        loadCategory(categoryId);
        if (producerId != null && !producerId.isBlank()) loadProducer(producerId);
    }

    private void ensureCategorySlugAvailable(String slug, String currentId) {
        boolean exists = currentId == null ? categoryRepository.existsBySlug(slug.trim())
                : categoryRepository.existsBySlugAndIdNot(slug.trim(), currentId);
        if (exists) throw new ConflictException("CATEGORY_SLUG_EXISTS", "Slug danh mục đã tồn tại");
    }

    private void ensureProductSlugAvailable(String slug, String currentId) {
        boolean exists = currentId == null ? productRepository.existsBySlug(slug.trim())
                : productRepository.existsBySlugAndIdNot(slug.trim(), currentId);
        if (exists) throw new ConflictException("PRODUCT_SLUG_EXISTS", "Slug sản phẩm đã tồn tại");
    }

    private void ensureVariantKeysAvailable(String sku, String barcode, String currentId) {
        String normalizedSku = sku.trim();
        boolean skuExists = currentId == null ? variantRepository.existsBySku(normalizedSku)
                : variantRepository.existsBySkuAndIdNot(normalizedSku, currentId);
        if (skuExists) throw new ConflictException("SKU_EXISTS", "SKU đã tồn tại");
        String normalizedBarcode = nullableTrim(barcode);
        if (normalizedBarcode != null) {
            boolean barcodeExists = currentId == null ? variantRepository.existsByBarcode(normalizedBarcode)
                    : variantRepository.existsByBarcodeAndIdNot(normalizedBarcode, currentId);
            if (barcodeExists) throw new ConflictException("BARCODE_EXISTS", "Barcode đã tồn tại");
        }
    }

    private CategoryEntity loadCategory(String id) {
        return categoryRepository.findByIdAndDeletedAtIsNull(id)
                .orElseThrow(() -> new ResourceNotFoundException("CATEGORY_NOT_FOUND", "Không tìm thấy danh mục"));
    }

    private ProducerEntity loadProducer(String id) {
        return producerRepository.findByIdAndDeletedAtIsNull(id)
                .orElseThrow(() -> new ResourceNotFoundException("PRODUCER_NOT_FOUND", "Không tìm thấy cơ sở sản xuất"));
    }

    private ProductEntity loadProduct(String id) {
        return productRepository.findByIdAndDeletedAtIsNull(id)
                .orElseThrow(() -> new ResourceNotFoundException("PRODUCT_NOT_FOUND", "Không tìm thấy sản phẩm"));
    }

    private ProductVariantEntity loadVariant(String id) {
        return variantRepository.findByIdAndDeletedAtIsNull(id)
                .orElseThrow(() -> new ResourceNotFoundException("VARIANT_NOT_FOUND", "Không tìm thấy biến thể sản phẩm"));
    }

    private static String nullableTrim(String value) {
        if (value == null || value.isBlank()) return null;
        return value.trim();
    }

    private static void validateRange(BigDecimal min, BigDecimal max, String message) {
        if (min != null && min.signum() < 0 || max != null && max.signum() < 0
                || min != null && max != null && min.compareTo(max) > 0) {
            throw new BadRequestException("INVALID_RANGE", message);
        }
    }
}
