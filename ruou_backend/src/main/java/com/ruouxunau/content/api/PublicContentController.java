package com.ruouxunau.content.api;

import com.ruouxunau.content.service.ArticleService;
import com.ruouxunau.shared.web.PageResponse;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Validated
@RestController
@RequestMapping("/api/v1")
public class PublicContentController {

    private final ArticleService articleService;

    public PublicContentController(ArticleService articleService) {
        this.articleService = articleService;
    }

    @GetMapping("/article-categories")
    List<ArticleCategoryResponse> categories() {
        return articleService.publicCategories();
    }

    @GetMapping("/articles")
    PageResponse<ArticleSummaryResponse> articles(
            @RequestParam(required = false, name = "q") String query,
            @RequestParam(required = false) String category,
            @RequestParam(defaultValue = "0") @Min(0) int page,
            @RequestParam(defaultValue = "20") @Min(1) @Max(100) int size,
            @RequestParam(defaultValue = "newest") String sort) {
        return articleService.publicArticles(query, category, page, size, sort);
    }

    @GetMapping("/articles/{slug}")
    ArticleDetailResponse article(@PathVariable String slug) {
        return articleService.publicArticle(slug);
    }
}
