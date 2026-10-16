package com.ruouxunau.content.api;

import com.ruouxunau.content.domain.ArticleStatus;
import com.ruouxunau.content.service.ArticleService;
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
@PreAuthorize("hasAuthority('ARTICLE_MANAGE')")
public class AdminArticleController {

    private final ArticleService articleService;

    public AdminArticleController(ArticleService articleService) {
        this.articleService = articleService;
    }

    @GetMapping("/article-categories")
    List<ArticleCategoryResponse> categories() {
        return articleService.adminCategories();
    }

    @PostMapping("/article-categories")
    ResponseEntity<ArticleCategoryResponse> createCategory(
            @AuthenticationPrincipal Jwt jwt,
            @Valid @RequestBody ArticleCategoryRequest request) {
        ArticleCategoryResponse response = articleService.createCategory(jwt.getSubject(), request);
        return ResponseEntity.created(URI.create("/api/v1/admin/article-categories/" + response.id())).body(response);
    }

    @PatchMapping("/article-categories/{id}")
    ArticleCategoryResponse updateCategory(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable String id,
            @Valid @RequestBody ArticleCategoryRequest request) {
        return articleService.updateCategory(jwt.getSubject(), id, request);
    }

    @DeleteMapping("/article-categories/{id}")
    ResponseEntity<Void> deleteCategory(@AuthenticationPrincipal Jwt jwt, @PathVariable String id) {
        articleService.deleteCategory(jwt.getSubject(), id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/articles")
    PageResponse<ArticleSummaryResponse> articles(
            @RequestParam(required = false, name = "q") String query,
            @RequestParam(required = false) ArticleStatus status,
            @RequestParam(defaultValue = "0") @Min(0) int page,
            @RequestParam(defaultValue = "20") @Min(1) @Max(100) int size,
            @RequestParam(defaultValue = "newest") String sort) {
        return articleService.adminArticles(query, status, page, size, sort);
    }

    @GetMapping("/articles/{id}")
    ArticleDetailResponse article(@PathVariable String id) {
        return articleService.adminArticle(id);
    }

    @PostMapping("/articles")
    ResponseEntity<ArticleDetailResponse> createArticle(
            @AuthenticationPrincipal Jwt jwt,
            @Valid @RequestBody ArticleRequest request) {
        ArticleDetailResponse response = articleService.create(jwt.getSubject(), request);
        return ResponseEntity.created(URI.create("/api/v1/admin/articles/" + response.id())).body(response);
    }

    @PatchMapping("/articles/{id}")
    ArticleDetailResponse updateArticle(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable String id,
            @Valid @RequestBody ArticleRequest request) {
        return articleService.update(jwt.getSubject(), id, request);
    }

    @PostMapping("/articles/{id}/submit-review")
    ArticleDetailResponse submitForReview(@AuthenticationPrincipal Jwt jwt, @PathVariable String id) {
        return articleService.submitForReview(jwt.getSubject(), id);
    }

    @PostMapping("/articles/{id}/publish")
    ArticleDetailResponse publish(@AuthenticationPrincipal Jwt jwt, @PathVariable String id) {
        return articleService.publish(jwt.getSubject(), id);
    }

    @PostMapping("/articles/{id}/archive")
    ArticleDetailResponse archive(@AuthenticationPrincipal Jwt jwt, @PathVariable String id) {
        return articleService.archive(jwt.getSubject(), id);
    }

    @DeleteMapping("/articles/{id}")
    ResponseEntity<Void> deleteArticle(@AuthenticationPrincipal Jwt jwt, @PathVariable String id) {
        articleService.delete(jwt.getSubject(), id);
        return ResponseEntity.noContent().build();
    }
}
