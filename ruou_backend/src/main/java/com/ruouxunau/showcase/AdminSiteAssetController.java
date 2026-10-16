package com.ruouxunau.showcase;

import com.ruouxunau.shared.audit.AuditService;
import com.ruouxunau.shared.exception.BadRequestException;
import com.ruouxunau.shared.exception.ResourceNotFoundException;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;
import java.util.Set;

@RestController
@RequestMapping("/api/v1/admin/site-assets")
@PreAuthorize("hasAuthority('CATALOG_MANAGE')")
public class AdminSiteAssetController {
    private static final Set<String> ALLOWED_KEYS = Set.of(
            "home.hero", "home.craft", "page.hero", "auth.visual", "contact.hero");

    private final JdbcTemplate jdbc;
    private final AuditService audit;

    public AdminSiteAssetController(JdbcTemplate jdbc, AuditService audit) {
        this.jdbc = jdbc;
        this.audit = audit;
    }

    @PutMapping("/{key}")
    @Transactional
    public AssetResponse replace(@AuthenticationPrincipal Jwt jwt, @PathVariable String key,
                                 @Valid @RequestBody AssetRequest request) {
        if (!ALLOWED_KEYS.contains(key)) {
            throw new BadRequestException("INVALID_SITE_ASSET", "Vị trí ảnh không được hỗ trợ");
        }
        MediaRow selected = jdbc.query("SELECT id, url, alt_text FROM media WHERE id = ?",
                rs -> rs.next() ? new MediaRow(rs.getString(1), rs.getString(2), rs.getString(3)) : null,
                request.mediaId());
        if (selected == null) {
            throw new ResourceNotFoundException("MEDIA_NOT_FOUND", "Không tìm thấy ảnh trong thư viện");
        }
        String previous = jdbc.query("SELECT media_id FROM site_assets WHERE asset_key = ?",
                rs -> rs.next() ? rs.getString(1) : null, key);
        jdbc.update("""
                INSERT INTO site_assets (asset_key, media_id) VALUES (?, ?)
                ON DUPLICATE KEY UPDATE media_id = VALUES(media_id)
                """, key, selected.id());
        audit.record(jwt.getSubject(), "SITE_ASSET_REPLACED", "site_asset", key,
                previous == null ? null : Map.of("mediaId", previous), Map.of("mediaId", selected.id()));
        return new AssetResponse(key, selected.id(), selected.url(), selected.altText());
    }

    public record AssetRequest(@NotBlank @Size(max = 26) String mediaId) {}
    public record AssetResponse(String key, String mediaId, String url, String altText) {}
    private record MediaRow(String id, String url, String altText) {}
}
