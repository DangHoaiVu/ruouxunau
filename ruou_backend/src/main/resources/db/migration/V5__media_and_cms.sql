-- Media ownership and CMS workflow. No sample media, categories or articles.

ALTER TABLE products
    ADD COLUMN primary_media_id CHAR(26) NULL AFTER seo_description,
    ADD INDEX idx_products_primary_media (primary_media_id),
    ADD CONSTRAINT fk_products_primary_media FOREIGN KEY (primary_media_id) REFERENCES media (id);

CREATE TABLE article_categories (
    id          CHAR(26)      NOT NULL,
    name        VARCHAR(120)  NOT NULL,
    slug        VARCHAR(140)  NOT NULL,
    description VARCHAR(500)  NULL,
    status      VARCHAR(20)   NOT NULL,
    sort_order  INT           NOT NULL DEFAULT 0,
    version     BIGINT        NOT NULL DEFAULT 0,
    created_at  TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at  TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    deleted_at  TIMESTAMP(6)  NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_article_categories_slug (slug),
    INDEX idx_article_categories_public (status, deleted_at, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE articles (
    id                  CHAR(26)      NOT NULL,
    author_id           CHAR(26)      NOT NULL,
    category_id         CHAR(26)      NOT NULL,
    featured_media_id   CHAR(26)      NULL,
    title               VARCHAR(220)  NOT NULL,
    slug                VARCHAR(240)  NOT NULL,
    excerpt             VARCHAR(600)  NOT NULL,
    content             LONGTEXT      NOT NULL,
    status              VARCHAR(20)   NOT NULL,
    published_at        TIMESTAMP(6)  NULL,
    seo_title           VARCHAR(180)  NULL,
    seo_description     VARCHAR(320)  NULL,
    version             BIGINT        NOT NULL DEFAULT 0,
    created_at          TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at          TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    deleted_at          TIMESTAMP(6)  NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_articles_slug (slug),
    INDEX idx_articles_public (status, published_at, deleted_at),
    INDEX idx_articles_category (category_id, status, deleted_at),
    INDEX idx_articles_author (author_id),
    CONSTRAINT fk_articles_author FOREIGN KEY (author_id) REFERENCES users (id),
    CONSTRAINT fk_articles_category FOREIGN KEY (category_id) REFERENCES article_categories (id),
    CONSTRAINT fk_articles_featured_media FOREIGN KEY (featured_media_id) REFERENCES media (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE tags (
    id         CHAR(26)     NOT NULL,
    name       VARCHAR(80)  NOT NULL,
    slug       VARCHAR(100) NOT NULL,
    created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    UNIQUE KEY uk_tags_name (name),
    UNIQUE KEY uk_tags_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE article_tags (
    article_id CHAR(26) NOT NULL,
    tag_id     CHAR(26) NOT NULL,
    PRIMARY KEY (article_id, tag_id),
    CONSTRAINT fk_article_tags_article FOREIGN KEY (article_id) REFERENCES articles (id) ON DELETE CASCADE,
    CONSTRAINT fk_article_tags_tag FOREIGN KEY (tag_id) REFERENCES tags (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
