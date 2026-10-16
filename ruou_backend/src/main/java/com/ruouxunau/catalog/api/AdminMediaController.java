package com.ruouxunau.catalog.api;

import com.ruouxunau.catalog.service.MediaService;
import com.ruouxunau.catalog.domain.MediaCategory;
import com.ruouxunau.shared.web.PageResponse;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import org.springframework.http.ResponseEntity;
import org.springframework.http.MediaType;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.multipart.MultipartFile;

import java.net.URI;

@Validated
@RestController
@RequestMapping("/api/v1/admin")
@PreAuthorize("hasAuthority('CATALOG_MANAGE')")
public class AdminMediaController {

    private final MediaService mediaService;

    public AdminMediaController(MediaService mediaService) {
        this.mediaService = mediaService;
    }

    @GetMapping("/media")
    PageResponse<MediaResponse> media(
            @RequestParam(defaultValue = "0") @Min(0) int page,
            @RequestParam(defaultValue = "20") @Min(1) @Max(100) int size) {
        return mediaService.list(page, size);
    }

    @PostMapping("/media")
    ResponseEntity<MediaResponse> createMedia(
            @AuthenticationPrincipal Jwt jwt,
            @Valid @RequestBody MediaRequest request) {
        MediaResponse response = mediaService.create(jwt.getSubject(), request);
        return ResponseEntity.created(URI.create("/api/v1/admin/media/" + response.id())).body(response);
    }

    @PostMapping(value = "/media/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    ResponseEntity<MediaResponse> uploadMedia(
            @AuthenticationPrincipal Jwt jwt,
            @RequestPart("file") MultipartFile file,
            @RequestPart("altText") String altText,
            @RequestPart("category") String category) {
        MediaResponse response = mediaService.upload(jwt.getSubject(), file, altText, MediaCategory.valueOf(category));
        return ResponseEntity.created(URI.create("/api/v1/admin/media/" + response.id())).body(response);
    }

    @PatchMapping("/media/{id}/metadata")
    MediaResponse updateMetadata(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable String id,
            @Valid @RequestBody MediaMetadataRequest request) {
        return mediaService.updateMetadata(jwt.getSubject(), id, request.altText(), request.category());
    }

    @PatchMapping("/media/{id}")
    MediaResponse updateMedia(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable String id,
            @Valid @RequestBody MediaRequest request) {
        return mediaService.update(jwt.getSubject(), id, request);
    }

    @DeleteMapping("/media/{id}")
    ResponseEntity<Void> deleteMedia(@AuthenticationPrincipal Jwt jwt, @PathVariable String id) {
        mediaService.delete(jwt.getSubject(), id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/products/{productId}/images")
    ProductImageResponse attachProductImage(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable String productId,
            @Valid @RequestBody ProductImageRequest request) {
        return mediaService.attachProductImage(jwt.getSubject(), productId, request);
    }

    @DeleteMapping("/products/{productId}/images/{mediaId}")
    ResponseEntity<Void> detachProductImage(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable String productId,
            @PathVariable String mediaId) {
        mediaService.detachProductImage(jwt.getSubject(), productId, mediaId);
        return ResponseEntity.noContent().build();
    }

    public record MediaMetadataRequest(
            @jakarta.validation.constraints.NotBlank @jakarta.validation.constraints.Size(max = 255) String altText,
            @jakarta.validation.constraints.NotNull MediaCategory category) {}
}
