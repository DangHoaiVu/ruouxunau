package com.ruouxunau.catalog.service;

import com.ruouxunau.catalog.api.MediaRequest;
import com.ruouxunau.catalog.api.MediaResponse;
import com.ruouxunau.catalog.api.ProductImageRequest;
import com.ruouxunau.catalog.api.ProductImageResponse;
import com.ruouxunau.catalog.domain.MediaEntity;
import com.ruouxunau.catalog.domain.MediaCategory;
import com.ruouxunau.catalog.domain.ProductEntity;
import com.ruouxunau.catalog.domain.ProductImageEntity;
import com.ruouxunau.catalog.domain.ProductImageId;
import com.ruouxunau.catalog.repository.MediaRepository;
import com.ruouxunau.catalog.repository.ProductImageRepository;
import com.ruouxunau.catalog.repository.ProductRepository;
import com.ruouxunau.content.repository.ArticleRepository;
import com.ruouxunau.shared.audit.AuditService;
import com.ruouxunau.shared.exception.BadRequestException;
import com.ruouxunau.shared.exception.ConflictException;
import com.ruouxunau.shared.exception.ResourceNotFoundException;
import com.ruouxunau.shared.exception.ServiceUnavailableException;
import com.ruouxunau.shared.persistence.IdGenerator;
import com.ruouxunau.shared.web.PageResponse;
import org.springframework.data.domain.PageRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.Clock;
import java.time.Instant;
import java.util.HexFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@Service
public class MediaService {

    private final MediaRepository mediaRepository;
    private final ProductImageRepository productImageRepository;
    private final ProductRepository productRepository;
    private final ArticleRepository articleRepository;
    private final AuditService auditService;
    private final Clock clock;
    private final Path uploadRoot;

    public MediaService(MediaRepository mediaRepository,
                        ProductImageRepository productImageRepository,
                        ProductRepository productRepository,
                        ArticleRepository articleRepository,
                        AuditService auditService,
                        Clock clock,
                        @Value("${app.media.upload-dir:uploads}") String uploadDirectory) {
        this.mediaRepository = mediaRepository;
        this.productImageRepository = productImageRepository;
        this.productRepository = productRepository;
        this.articleRepository = articleRepository;
        this.auditService = auditService;
        this.clock = clock;
        this.uploadRoot = Path.of(uploadDirectory).toAbsolutePath().normalize();
    }

    @Transactional(readOnly = true)
    public PageResponse<MediaResponse> list(int page, int size) {
        return PageResponse.from(
                mediaRepository.findAllByOrderByCreatedAtDesc(PageRequest.of(page, size)),
                MediaResponse::from);
    }

    @Transactional
    public MediaResponse create(String actorId, MediaRequest request) {
        validateExternalImage(request);
        Instant now = clock.instant();
        MediaEntity entity = new MediaEntity(
                IdGenerator.newUlid(clock), request.url().trim(), null,
                request.mimeType().trim().toLowerCase(Locale.ROOT), MediaCategory.OTHER, null,
                request.width(), request.height(),
                request.altText().trim(), normalizeChecksum(request.checksum()), now);
        MediaResponse response = MediaResponse.from(mediaRepository.save(entity));
        auditService.record(actorId, "MEDIA_CREATED", "MEDIA", entity.getId(), null, response);
        return response;
    }

    @Transactional
    public MediaResponse upload(String actorId, MultipartFile file, String altText, MediaCategory category) {
        if (file == null || file.isEmpty()) {
            throw new BadRequestException("EMPTY_MEDIA_FILE", "Vui lòng chọn một tệp ảnh");
        }
        if (file.getSize() > 10L * 1024 * 1024) {
            throw new BadRequestException("MEDIA_TOO_LARGE", "Ảnh không được lớn hơn 10 MB");
        }
        String mimeType = file.getContentType() == null ? "" : file.getContentType().toLowerCase(Locale.ROOT);
        String extension = switch (mimeType) {
            case "image/jpeg" -> ".jpg";
            case "image/png" -> ".png";
            case "image/webp" -> ".webp";
            case "image/avif" -> ".avif";
            default -> throw new BadRequestException("INVALID_MEDIA_TYPE", "Chỉ nhận ảnh JPG, PNG, WebP hoặc AVIF");
        };
        String safeAlt = altText == null ? "" : altText.trim();
        if (safeAlt.isBlank() || safeAlt.length() > 255) {
            throw new BadRequestException("INVALID_ALT_TEXT", "Mô tả ảnh phải có từ 1 đến 255 ký tự");
        }
        String originalName = cleanFilename(file.getOriginalFilename());
        String id = IdGenerator.newUlid(clock);
        String storageKey = id.toLowerCase(Locale.ROOT) + extension;
        Path target = uploadRoot.resolve(storageKey).normalize();
        if (!target.startsWith(uploadRoot)) {
            throw new BadRequestException("INVALID_MEDIA_FILE", "Tên tệp ảnh không hợp lệ");
        }
        try {
            byte[] bytes = file.getBytes();
            Files.createDirectories(uploadRoot);
            Files.write(target, bytes, StandardOpenOption.CREATE_NEW);
            int[] dimensions = dimensions(bytes, mimeType);
            MediaEntity entity = new MediaEntity(id, "/uploads/" + storageKey, storageKey, mimeType,
                    category == null ? MediaCategory.OTHER : category, originalName,
                    dimensions[0] == 0 ? null : dimensions[0], dimensions[1] == 0 ? null : dimensions[1],
                    safeAlt, sha256(bytes), clock.instant());
            MediaResponse response = MediaResponse.from(mediaRepository.saveAndFlush(entity));
            auditService.record(actorId, "MEDIA_UPLOADED", "MEDIA", id, null, response);
            return response;
        } catch (IOException exception) {
            throw new ServiceUnavailableException("MEDIA_STORAGE_UNAVAILABLE", "Không thể lưu tệp ảnh trên máy chủ");
        } catch (RuntimeException exception) {
            try { Files.deleteIfExists(target); } catch (IOException ignored) {}
            throw exception;
        }
    }

    @Transactional
    public MediaResponse updateMetadata(String actorId, String id, String altText, MediaCategory category) {
        MediaEntity entity = loadMedia(id);
        MediaResponse before = MediaResponse.from(entity);
        String safeAlt = altText == null ? "" : altText.trim();
        if (safeAlt.isBlank() || safeAlt.length() > 255) {
            throw new BadRequestException("INVALID_ALT_TEXT", "Mô tả ảnh phải có từ 1 đến 255 ký tự");
        }
        entity.updateMetadata(category == null ? MediaCategory.OTHER : category,
                entity.getOriginalFilename(), safeAlt);
        MediaResponse response = MediaResponse.from(entity);
        auditService.record(actorId, "MEDIA_UPDATED", "MEDIA", id, before, response);
        return response;
    }

    @Transactional
    public MediaResponse update(String actorId, String id, MediaRequest request) {
        validateExternalImage(request);
        MediaEntity entity = loadMedia(id);
        MediaResponse before = MediaResponse.from(entity);
        entity.update(request.url().trim(), request.mimeType().trim().toLowerCase(Locale.ROOT),
                request.width(), request.height(), request.altText().trim(), normalizeChecksum(request.checksum()));
        MediaResponse response = MediaResponse.from(entity);
        auditService.record(actorId, "MEDIA_UPDATED", "MEDIA", id, before, response);
        return response;
    }

    @Transactional
    public void delete(String actorId, String id) {
        MediaEntity entity = loadMedia(id);
        if (productImageRepository.existsByMediaId(id) || productRepository.existsByPrimaryMediaId(id)
                || articleRepository.existsByFeaturedMediaId(id)) {
            throw new ConflictException("MEDIA_IN_USE", "Ảnh đang được sử dụng, hãy gỡ liên kết trước khi xóa");
        }
        MediaResponse before = MediaResponse.from(entity);
        String storageKey = entity.getStorageKey();
        mediaRepository.delete(entity);
        mediaRepository.flush();
        if (storageKey != null && !storageKey.isBlank()) {
            try { Files.deleteIfExists(uploadRoot.resolve(storageKey).normalize()); }
            catch (IOException ignored) { }
        }
        auditService.record(actorId, "MEDIA_DELETED", "MEDIA", id, before, null);
    }

    @Transactional
    public ProductImageResponse attachProductImage(
            String actorId, String productId, ProductImageRequest request) {
        ProductEntity product = loadProduct(productId);
        MediaEntity media = loadMedia(request.mediaId());
        ProductImageId id = new ProductImageId(productId, request.mediaId());
        ProductImageEntity image = productImageRepository.findById(id)
                .orElseGet(() -> new ProductImageEntity(productId, request.mediaId(), request.sortOrder(), request.primary()));

        Instant now = clock.instant();
        if (request.primary()) {
            productImageRepository.clearPrimary(productId);
            product.setPrimaryMediaId(request.mediaId(), now);
        } else if (request.mediaId().equals(product.getPrimaryMediaId())) {
            product.setPrimaryMediaId(null, now);
        }
        image.update(request.sortOrder(), request.primary());
        productImageRepository.save(image);
        ProductImageResponse response = imageResponse(image, media);
        auditService.record(actorId, "PRODUCT_IMAGE_ATTACHED", "PRODUCT", productId, null, response);
        return response;
    }

    @Transactional
    public void detachProductImage(String actorId, String productId, String mediaId) {
        ProductEntity product = loadProduct(productId);
        ProductImageId id = new ProductImageId(productId, mediaId);
        ProductImageEntity image = productImageRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("PRODUCT_IMAGE_NOT_FOUND", "Không tìm thấy ảnh của sản phẩm"));
        ProductImageResponse before = imageResponse(image, loadMedia(mediaId));
        productImageRepository.delete(image);
        if (mediaId.equals(product.getPrimaryMediaId())) {
            product.setPrimaryMediaId(null, clock.instant());
        }
        auditService.record(actorId, "PRODUCT_IMAGE_DETACHED", "PRODUCT", productId, before, null);
    }

    @Transactional(readOnly = true)
    public List<ProductImageResponse> images(String productId) {
        List<ProductImageEntity> links = productImageRepository.findAllByProductIdOrderBySortOrderAsc(productId);
        if (links.isEmpty()) return List.of();
        Map<String, MediaEntity> mediaById = new HashMap<>();
        mediaRepository.findAllById(links.stream().map(ProductImageEntity::getMediaId).toList())
                .forEach(media -> mediaById.put(media.getId(), media));
        return links.stream()
                .filter(link -> mediaById.containsKey(link.getMediaId()))
                .map(link -> imageResponse(link, mediaById.get(link.getMediaId())))
                .toList();
    }

    @Transactional(readOnly = true)
    public String primaryUrl(ProductEntity product) {
        if (product.getPrimaryMediaId() == null) return null;
        return mediaRepository.findById(product.getPrimaryMediaId()).map(MediaEntity::getUrl).orElse(null);
    }

    @Transactional(readOnly = true)
    public MediaResponse media(String id) {
        return MediaResponse.from(loadMedia(id));
    }

    private ProductImageResponse imageResponse(ProductImageEntity image, MediaEntity media) {
        return new ProductImageResponse(
                media.getId(), media.getUrl(), media.getAltText(), media.getWidth(), media.getHeight(),
                image.getSortOrder(), image.isPrimary());
    }

    private void validateExternalImage(MediaRequest request) {
        URI uri;
        try {
            uri = URI.create(request.url().trim());
        } catch (IllegalArgumentException exception) {
            throw new BadRequestException("INVALID_MEDIA_URL", "URL ảnh không hợp lệ");
        }
        if (!("http".equalsIgnoreCase(uri.getScheme()) || "https".equalsIgnoreCase(uri.getScheme()))
                || uri.getHost() == null) {
            throw new BadRequestException("INVALID_MEDIA_URL", "URL ảnh phải dùng HTTP hoặc HTTPS và có tên miền hợp lệ");
        }
        if (!request.mimeType().trim().toLowerCase(Locale.ROOT).startsWith("image/")) {
            throw new BadRequestException("INVALID_MEDIA_TYPE", "Chỉ chấp nhận media có MIME type hình ảnh");
        }
    }

    private MediaEntity loadMedia(String id) {
        return mediaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("MEDIA_NOT_FOUND", "Không tìm thấy ảnh"));
    }

    private ProductEntity loadProduct(String id) {
        return productRepository.findByIdAndDeletedAtIsNull(id)
                .orElseThrow(() -> new ResourceNotFoundException("PRODUCT_NOT_FOUND", "Không tìm thấy sản phẩm"));
    }

    private static String normalizeChecksum(String checksum) {
        return checksum == null || checksum.isBlank() ? null : checksum.trim().toLowerCase(Locale.ROOT);
    }

    private static String cleanFilename(String value) {
        if (value == null || value.isBlank()) return "image";
        String name = Path.of(value).getFileName().toString().replaceAll("[\\r\\n]", "");
        return name.length() <= 255 ? name : name.substring(name.length() - 255);
    }

    private static int[] dimensions(byte[] bytes, String mimeType) throws IOException {
        if (!("image/jpeg".equals(mimeType) || "image/png".equals(mimeType))) return new int[] { 0, 0 };
        BufferedImage image = ImageIO.read(new ByteArrayInputStream(bytes));
        return image == null ? new int[] { 0, 0 } : new int[] { image.getWidth(), image.getHeight() };
    }

    private static String sha256(byte[] bytes) {
        try { return HexFormat.of().formatHex(MessageDigest.getInstance("SHA-256").digest(bytes)); }
        catch (NoSuchAlgorithmException exception) { throw new IllegalStateException(exception); }
    }
}
