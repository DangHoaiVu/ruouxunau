package com.ruouxunau.catalog.api;

import com.ruouxunau.catalog.domain.PublicationStatus;
import com.ruouxunau.catalog.service.CatalogService;
import com.ruouxunau.shared.web.PageResponse;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import org.springframework.http.ResponseEntity;
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

import java.net.URI;
import java.util.List;

@Validated
@RestController
@RequestMapping("/api/v1/admin")
@PreAuthorize("hasAuthority('CATALOG_MANAGE')")
public class AdminCatalogController {

    private final CatalogService catalogService;

    public AdminCatalogController(CatalogService catalogService) {
        this.catalogService = catalogService;
    }

    @GetMapping("/categories")
    List<CategoryResponse> categories() {
        return catalogService.adminCategories();
    }

    @PostMapping("/categories")
    ResponseEntity<CategoryResponse> createCategory(
            @AuthenticationPrincipal Jwt jwt,
            @Valid @RequestBody CategoryRequest request) {
        CategoryResponse response = catalogService.createCategory(jwt.getSubject(), request);
        return ResponseEntity.created(URI.create("/api/v1/admin/categories/" + response.id())).body(response);
    }

    @PatchMapping("/categories/{id}")
    CategoryResponse updateCategory(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable String id,
            @Valid @RequestBody CategoryRequest request) {
        return catalogService.updateCategory(jwt.getSubject(), id, request);
    }

    @DeleteMapping("/categories/{id}")
    ResponseEntity<Void> deleteCategory(@AuthenticationPrincipal Jwt jwt, @PathVariable String id) {
        catalogService.deleteCategory(jwt.getSubject(), id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/producers")
    List<ProducerResponse> producers() {
        return catalogService.adminProducers();
    }

    @PostMapping("/producers")
    ResponseEntity<ProducerResponse> createProducer(
            @AuthenticationPrincipal Jwt jwt,
            @Valid @RequestBody ProducerRequest request) {
        ProducerResponse response = catalogService.createProducer(jwt.getSubject(), request);
        return ResponseEntity.created(URI.create("/api/v1/admin/producers/" + response.id())).body(response);
    }

    @PatchMapping("/producers/{id}")
    ProducerResponse updateProducer(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable String id,
            @Valid @RequestBody ProducerRequest request) {
        return catalogService.updateProducer(jwt.getSubject(), id, request);
    }

    @DeleteMapping("/producers/{id}")
    ResponseEntity<Void> deleteProducer(@AuthenticationPrincipal Jwt jwt, @PathVariable String id) {
        catalogService.deleteProducer(jwt.getSubject(), id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/products")
    PageResponse<ProductSummaryResponse> products(
            @RequestParam(required = false, name = "q") String query,
            @RequestParam(required = false) PublicationStatus status,
            @RequestParam(defaultValue = "0") @Min(0) int page,
            @RequestParam(defaultValue = "20") @Min(1) @Max(100) int size,
            @RequestParam(defaultValue = "newest") String sort) {
        return catalogService.adminProducts(query, status, page, size, sort);
    }

    @GetMapping("/products/{id}")
    ProductDetailResponse product(@PathVariable String id) {
        return catalogService.adminProduct(id);
    }

    @PostMapping("/products")
    ResponseEntity<ProductDetailResponse> createProduct(
            @AuthenticationPrincipal Jwt jwt,
            @Valid @RequestBody ProductRequest request) {
        ProductDetailResponse response = catalogService.createProduct(jwt.getSubject(), request);
        return ResponseEntity.created(URI.create("/api/v1/admin/products/" + response.id())).body(response);
    }

    @PatchMapping("/products/{id}")
    ProductDetailResponse updateProduct(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable String id,
            @Valid @RequestBody ProductRequest request) {
        return catalogService.updateProduct(jwt.getSubject(), id, request);
    }

    @DeleteMapping("/products/{id}")
    ResponseEntity<Void> deleteProduct(@AuthenticationPrincipal Jwt jwt, @PathVariable String id) {
        catalogService.deleteProduct(jwt.getSubject(), id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/variants")
    ResponseEntity<VariantResponse> createVariant(
            @AuthenticationPrincipal Jwt jwt,
            @Valid @RequestBody VariantRequest request) {
        VariantResponse response = catalogService.createVariant(jwt.getSubject(), request);
        return ResponseEntity.created(URI.create("/api/v1/admin/variants/" + response.id())).body(response);
    }

    @PatchMapping("/variants/{id}")
    VariantResponse updateVariant(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable String id,
            @Valid @RequestBody VariantRequest request) {
        return catalogService.updateVariant(jwt.getSubject(), id, request);
    }

    @DeleteMapping("/variants/{id}")
    ResponseEntity<Void> deleteVariant(@AuthenticationPrincipal Jwt jwt, @PathVariable String id) {
        catalogService.deleteVariant(jwt.getSubject(), id);
        return ResponseEntity.noContent().build();
    }
}
