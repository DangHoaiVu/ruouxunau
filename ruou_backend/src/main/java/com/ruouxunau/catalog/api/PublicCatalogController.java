package com.ruouxunau.catalog.api;

import com.ruouxunau.catalog.service.CatalogService;
import com.ruouxunau.shared.web.PageResponse;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.List;

@Validated
@RestController
@RequestMapping("/api/v1")
public class PublicCatalogController {

    private final CatalogService catalogService;

    public PublicCatalogController(CatalogService catalogService) {
        this.catalogService = catalogService;
    }

    @GetMapping("/categories")
    List<CategoryResponse> categories() {
        return catalogService.publicCategories();
    }

    @GetMapping("/products")
    PageResponse<ProductSummaryResponse> products(
            @RequestParam(required = false, name = "q") String query,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) @DecimalMin("0.00") BigDecimal minPrice,
            @RequestParam(required = false) @DecimalMin("0.00") BigDecimal maxPrice,
            @RequestParam(required = false) @DecimalMin("0.00") BigDecimal minAlcohol,
            @RequestParam(required = false) @DecimalMin("0.00") BigDecimal maxAlcohol,
            @RequestParam(required = false) @Min(1) Integer volume,
            @RequestParam(defaultValue = "0") @Min(0) int page,
            @RequestParam(defaultValue = "20") @Min(1) @Max(100) int size,
            @RequestParam(defaultValue = "newest") String sort) {
        return catalogService.publicProducts(
                query, category, minPrice, maxPrice, minAlcohol, maxAlcohol, volume, page, size, sort);
    }

    @GetMapping("/products/{slug}")
    ProductDetailResponse product(@PathVariable String slug) {
        return catalogService.publicProduct(slug);
    }
}
