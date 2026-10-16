package com.ruouxunau.showcase;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import tools.jackson.core.type.TypeReference;
import tools.jackson.databind.ObjectMapper;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/showcase")
public class ShowcaseController {

    private final JdbcTemplate jdbc;
    private final ObjectMapper json;

    public ShowcaseController(JdbcTemplate jdbc, ObjectMapper json) {
        this.jdbc = jdbc;
        this.json = json;
    }

    @GetMapping
    @Transactional(readOnly = true)
    public ShowcaseResponse showcase() {
        Map<String, List<String>> galleries = new HashMap<>();
        jdbc.query("""
                SELECT pi.product_id, m.url
                FROM product_images pi JOIN media m ON m.id = pi.media_id
                ORDER BY pi.product_id, pi.sort_order, pi.media_id
                """, rs -> {
            galleries.computeIfAbsent(rs.getString("product_id"), ignored -> new ArrayList<>())
                    .add(rs.getString("url"));
        });

        List<ShowcaseProduct> products = jdbc.query("""
                SELECT p.id, v.id AS variant_id, p.slug, p.name, c.name AS category, p.material, p.badge, p.featured,
                       p.tasting_notes, p.short_description, p.description, p.origin,
                       COALESCE(pr.name, '') AS producer, v.sku, v.volume_ml, v.alcohol_percent,
                       v.price, v.compare_price, v.stock_quantity, COALESCE(m.url, '') AS image
                FROM products p
                JOIN categories c ON c.id = p.category_id
                JOIN product_variants v ON v.product_id = p.id AND v.deleted_at IS NULL
                    AND v.status = 'ACTIVE' AND v.id = (
                        SELECT v2.id FROM product_variants v2 WHERE v2.product_id = p.id
                          AND v2.deleted_at IS NULL AND v2.status = 'ACTIVE'
                        ORDER BY v2.volume_ml, v2.id LIMIT 1)
                LEFT JOIN producers pr ON pr.id = p.producer_id
                LEFT JOIN media m ON m.id = p.primary_media_id
                WHERE p.deleted_at IS NULL AND p.status = 'ACTIVE'
                  AND c.deleted_at IS NULL AND c.status = 'ACTIVE'
                ORDER BY p.id
                """, (rs, ignored) -> new ShowcaseProduct(
                rs.getString("id"), rs.getString("variant_id"), rs.getString("sku"), rs.getString("slug"), rs.getString("name"), rs.getString("category"),
                rs.getString("material"), rs.getInt("volume_ml"), rs.getBigDecimal("alcohol_percent"),
                rs.getBigDecimal("price"), rs.getBigDecimal("compare_price"), rs.getInt("stock_quantity"),
                rs.getString("badge"), rs.getBoolean("featured"), rs.getString("image"),
                galleries.getOrDefault(rs.getString("id"), List.of()), rs.getString("short_description"),
                rs.getString("description"), rs.getString("producer"), rs.getString("origin"),
                notes(rs.getString("tasting_notes"))));

        List<ShowcaseStory> stories = jdbc.query("""
                SELECT a.id, a.slug, a.title, a.excerpt, c.name AS category,
                       COALESCE(m.url, '') AS image, COALESCE(a.byline, u.full_name) AS author,
                       DATE_FORMAT(a.published_at, '%d.%m.%Y') AS published_date,
                       COALESCE(a.reading_minutes, 1) AS reading_minutes, a.featured, a.content
                FROM articles a
                JOIN article_categories c ON c.id = a.category_id
                JOIN users u ON u.id = a.author_id
                LEFT JOIN media m ON m.id = a.featured_media_id
                WHERE a.deleted_at IS NULL AND a.status = 'PUBLISHED'
                  AND a.published_at <= UTC_TIMESTAMP(6)
                  AND c.deleted_at IS NULL AND c.status = 'ACTIVE'
                ORDER BY a.published_at DESC, a.id
                """, (rs, ignored) -> new ShowcaseStory(
                rs.getString("id"), rs.getString("slug"), rs.getString("title"), rs.getString("excerpt"),
                rs.getString("category"), rs.getString("image"), rs.getString("author"),
                rs.getString("published_date"), rs.getInt("reading_minutes"), rs.getBoolean("featured"),
                List.of(rs.getString("content").split("\\R\\R"))));

        Map<String, String> assets = new HashMap<>();
        jdbc.query("SELECT sa.asset_key, m.url FROM site_assets sa JOIN media m ON m.id = sa.media_id",
                rs -> { assets.put(rs.getString("asset_key"), rs.getString("url")); });
        return new ShowcaseResponse(products, stories, assets);
    }

    private List<String> notes(String value) {
        return value == null ? List.of() : json.readValue(value, new TypeReference<List<String>>() {});
    }

    public record ShowcaseResponse(List<ShowcaseProduct> products, List<ShowcaseStory> stories,
                                   Map<String, String> assets) {}

    public record ShowcaseProduct(String id, String variantId, String sku, String slug, String name, String category, String material,
                                  int volume, BigDecimal alcohol, BigDecimal price, BigDecimal comparePrice,
                                  int stock, String badge, boolean featured, String image, List<String> gallery,
                                  String shortDescription, String description, String producer, String origin,
                                  List<String> tastingNotes) {}

    public record ShowcaseStory(String id, String slug, String title, String excerpt, String category,
                                String image, String author, String publishedAt, int readTime,
                                boolean featured, List<String> content) {}
}
