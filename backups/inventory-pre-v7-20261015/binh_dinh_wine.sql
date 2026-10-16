-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: binh_dinh_wine
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `addresses`
--

DROP TABLE IF EXISTS `addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `addresses` (
  `id` char(26) NOT NULL,
  `user_id` char(26) NOT NULL,
  `receiver_name` varchar(150) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `province_code` varchar(20) NOT NULL,
  `province_name` varchar(100) NOT NULL,
  `district_code` varchar(20) NOT NULL,
  `district_name` varchar(100) NOT NULL,
  `ward_code` varchar(20) NOT NULL,
  `ward_name` varchar(100) NOT NULL,
  `detail` varchar(255) NOT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `version` bigint NOT NULL DEFAULT '0',
  `created_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_addresses_user` (`user_id`),
  CONSTRAINT `fk_addresses_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addresses`
--

LOCK TABLES `addresses` WRITE;
/*!40000 ALTER TABLE `addresses` DISABLE KEYS */;
/*!40000 ALTER TABLE `addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_categories`
--

DROP TABLE IF EXISTS `article_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article_categories` (
  `id` char(26) NOT NULL,
  `name` varchar(120) NOT NULL,
  `slug` varchar(140) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  `version` bigint NOT NULL DEFAULT '0',
  `created_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_article_categories_slug` (`slug`),
  KEY `idx_article_categories_public` (`status`,`deleted_at`,`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_categories`
--

LOCK TABLES `article_categories` WRITE;
/*!40000 ALTER TABLE `article_categories` DISABLE KEYS */;
INSERT INTO `article_categories` VALUES ('25000000000000000000000001','Làng nghề','lang-nghe',NULL,'ACTIVE',1,0,'2026-10-15 09:56:26.527906','2026-10-15 09:56:26.527906',NULL),('25000000000000000000000002','Thưởng thức','thuong-thuc',NULL,'ACTIVE',2,0,'2026-10-15 09:56:26.527906','2026-10-15 09:56:26.527906',NULL),('25000000000000000000000003','Kỹ nghệ','ky-nghe',NULL,'ACTIVE',3,0,'2026-10-15 09:56:26.527906','2026-10-15 09:56:26.527906',NULL),('25000000000000000000000004','Văn hóa','van-hoa',NULL,'ACTIVE',4,0,'2026-10-15 09:56:26.527906','2026-10-15 09:56:26.527906',NULL);
/*!40000 ALTER TABLE `article_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_tags`
--

DROP TABLE IF EXISTS `article_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article_tags` (
  `article_id` char(26) NOT NULL,
  `tag_id` char(26) NOT NULL,
  PRIMARY KEY (`article_id`,`tag_id`),
  KEY `fk_article_tags_tag` (`tag_id`),
  CONSTRAINT `fk_article_tags_article` FOREIGN KEY (`article_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_article_tags_tag` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_tags`
--

LOCK TABLES `article_tags` WRITE;
/*!40000 ALTER TABLE `article_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `article_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `articles`
--

DROP TABLE IF EXISTS `articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `articles` (
  `id` char(26) NOT NULL,
  `author_id` char(26) NOT NULL,
  `category_id` char(26) NOT NULL,
  `featured_media_id` char(26) DEFAULT NULL,
  `title` varchar(220) NOT NULL,
  `slug` varchar(240) NOT NULL,
  `excerpt` varchar(600) NOT NULL,
  `byline` varchar(150) DEFAULT NULL,
  `reading_minutes` int DEFAULT NULL,
  `featured` tinyint(1) NOT NULL DEFAULT '0',
  `content` longtext NOT NULL,
  `status` varchar(20) NOT NULL,
  `published_at` timestamp(6) NULL DEFAULT NULL,
  `seo_title` varchar(180) DEFAULT NULL,
  `seo_description` varchar(320) DEFAULT NULL,
  `version` bigint NOT NULL DEFAULT '0',
  `created_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_articles_slug` (`slug`),
  KEY `idx_articles_public` (`status`,`published_at`,`deleted_at`),
  KEY `idx_articles_category` (`category_id`,`status`,`deleted_at`),
  KEY `idx_articles_author` (`author_id`),
  KEY `fk_articles_featured_media` (`featured_media_id`),
  CONSTRAINT `fk_articles_author` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_articles_category` FOREIGN KEY (`category_id`) REFERENCES `article_categories` (`id`),
  CONSTRAINT `fk_articles_featured_media` FOREIGN KEY (`featured_media_id`) REFERENCES `media` (`id`),
  CONSTRAINT `ck_articles_reading_minutes` CHECK (((`reading_minutes` is null) or (`reading_minutes` > 0)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `articles`
--

LOCK TABLES `articles` WRITE;
/*!40000 ALTER TABLE `articles` DISABLE KEYS */;
INSERT INTO `articles` VALUES ('26000000000000000000000001','01M4W68N231KS59HYAE86S9PGH','25000000000000000000000001','24000000000000000000000005','Men rượu giữ hồn làng qua những mùa gió nồm','men-ruou-giu-hon-lang','Một buổi sớm ở làng nghề, nơi nồi đồng đỏ lửa và câu chuyện truyền nghề vẫn tiếp tục.','Ban biên tập',6,1,'Giữa miền đất võ, nghề nấu rượu bắt đầu từ những điều rất nhỏ: hạt gạo được chọn kỹ, bánh men được giữ khô và ngọn lửa phải đều suốt nhiều giờ.\n\nMỗi gia đình có một cách lắng nghe nồi rượu riêng. Người thợ không chỉ nhìn đồng hồ; họ nhìn dòng rượu, ngửi mùi men và điều chỉnh lửa bằng kinh nghiệm tích lũy qua nhiều mùa.\n\nBài viết này đang dùng nội dung minh họa. Khi có tư liệu chính thức, ban biên tập có thể thay nội dung trong CMS mà không cần chỉnh sửa giao diện.','PUBLISHED','2026-10-07 17:00:00.000000',NULL,NULL,0,'2026-10-15 09:56:26.608982','2026-10-15 09:56:26.608982',NULL),('26000000000000000000000002','01M4W68N231KS59HYAE86S9PGH','25000000000000000000000002','24000000000000000000000006','Chọn rượu cho một bữa cơm Việt trọn vị','chon-ruou-cho-bua-com-viet','Từ món nướng đến món kho, cách chọn nồng độ và hương vị để bàn ăn cân bằng hơn.','Minh An',5,0,'Rượu ngon không nhất thiết phải mạnh. Một lựa chọn phù hợp là lựa chọn hòa hợp với món ăn, thời tiết và nhịp của bữa cơm.\n\nVới món nướng đậm vị, có thể chọn rượu có thân vị rõ. Với món hấp hoặc món thanh, nên ưu tiên dòng rượu nhẹ và uống ở nhiệt độ mát.','PUBLISHED','2026-10-02 17:00:00.000000',NULL,NULL,0,'2026-10-15 09:56:26.608982','2026-10-15 09:56:26.608982',NULL),('26000000000000000000000003','01M4W68N231KS59HYAE86S9PGH','25000000000000000000000003','24000000000000000000000007','Hành trình của hạt gạo trong một mẻ rượu thủ công','hanh-trinh-hat-gao','Từ ruộng lúa, gian bếp ủ men đến giọt rượu đầu tiên chảy qua ống tre.','Thanh Bình',8,0,'Chất lượng của một mẻ rượu được quyết định từ trước khi nhóm lửa. Độ mới của gạo, độ ẩm của men và nguồn nước đều tạo nên khác biệt.\n\nQuá trình lên men cần được theo dõi ổn định. Khi chưng cất, người thợ tách phần đầu, phần giữa và phần cuối để chọn phần rượu có chất lượng tốt nhất.','PUBLISHED','2026-09-27 17:00:00.000000',NULL,NULL,0,'2026-10-15 09:56:26.608982','2026-10-15 09:56:26.608982',NULL),('26000000000000000000000004','01M4W68N231KS59HYAE86S9PGH','25000000000000000000000004','24000000000000000000000008','Thưởng thức có trách nhiệm là một phần của văn hóa rượu','thuong-thuc-co-trach-nhiem','Uống chậm, hiểu giới hạn và tuyệt đối không lái xe sau khi sử dụng đồ uống có cồn.','Ban biên tập',4,0,'Văn hóa thưởng thức bắt đầu từ sự chừng mực. Rượu nên đồng hành cùng câu chuyện và món ăn, không phải là mục tiêu của cuộc gặp.\n\nLuôn chuẩn bị phương án di chuyển an toàn và không khuyến khích người chưa đủ tuổi sử dụng đồ uống có cồn.','PUBLISHED','2026-09-17 17:00:00.000000',NULL,NULL,0,'2026-10-15 09:56:26.608982','2026-10-15 09:56:26.608982',NULL);
/*!40000 ALTER TABLE `articles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `id` char(26) NOT NULL,
  `actor_id` char(26) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `entity_type` varchar(100) NOT NULL,
  `entity_id` varchar(100) DEFAULT NULL,
  `before_json` json DEFAULT NULL,
  `after_json` json DEFAULT NULL,
  `trace_id` varchar(64) NOT NULL,
  `created_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_audit_entity` (`entity_type`,`entity_id`),
  KEY `idx_audit_actor_created` (`actor_id`,`created_at`),
  KEY `idx_audit_trace` (`trace_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_rate_limits`
--

DROP TABLE IF EXISTS `auth_rate_limits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_rate_limits` (
  `scope_key` char(64) NOT NULL,
  `window_started_at` timestamp(6) NOT NULL,
  `attempt_count` int NOT NULL,
  `updated_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`scope_key`),
  KEY `idx_auth_rate_window` (`window_started_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_rate_limits`
--

LOCK TABLES `auth_rate_limits` WRITE;
/*!40000 ALTER TABLE `auth_rate_limits` DISABLE KEYS */;
INSERT INTO `auth_rate_limits` VALUES ('00d7bdfcbfaa86bc337d479b7cf3820d4801671b20fe707b2af3c5b3a08eefc4','2026-10-13 20:40:08.684611',1,'2026-10-13 20:40:08.684611'),('1429ade8e457feaab350cc00c184f78bb7e0a5982c3329c7e66bb4d79cb63fe6','2026-10-15 07:12:17.260913',1,'2026-10-15 07:12:17.260913'),('6a4947204de50c8fd5e48fe6cf20a8d64a87996b37ae6456902ef484e76f0af1','2026-10-15 07:11:54.770343',2,'2026-10-15 07:12:16.004682');
/*!40000 ALTER TABLE `auth_rate_limits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` char(26) NOT NULL,
  `name` varchar(120) NOT NULL,
  `slug` varchar(140) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  `version` bigint NOT NULL DEFAULT '0',
  `created_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_categories_slug` (`slug`),
  KEY `idx_categories_public` (`status`,`deleted_at`,`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES ('20000000000000000000000001','Rượu gạo','ruou-gao',NULL,'ACTIVE',1,0,'2026-10-15 09:56:26.476877','2026-10-15 09:56:26.476877',NULL),('20000000000000000000000002','Rượu nếp','ruou-nep',NULL,'ACTIVE',2,0,'2026-10-15 09:56:26.476877','2026-10-15 09:56:26.476877',NULL),('20000000000000000000000003','Rượu ủ','ruou-u',NULL,'ACTIVE',3,0,'2026-10-15 09:56:26.476877','2026-10-15 09:56:26.476877',NULL),('20000000000000000000000004','Rượu thảo mộc','ruou-thao-moc',NULL,'ACTIVE',4,0,'2026-10-15 09:56:26.476877','2026-10-15 09:56:26.476877',NULL),('20000000000000000000000005','Quà tặng','qua-tang',NULL,'ACTIVE',5,0,'2026-10-15 09:56:26.476877','2026-10-15 09:56:26.476877',NULL);
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flyway_schema_history`
--

DROP TABLE IF EXISTS `flyway_schema_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flyway_schema_history` (
  `installed_rank` int NOT NULL,
  `version` varchar(50) DEFAULT NULL,
  `description` varchar(200) NOT NULL,
  `type` varchar(20) NOT NULL,
  `script` varchar(1000) NOT NULL,
  `checksum` int DEFAULT NULL,
  `installed_by` varchar(100) NOT NULL,
  `installed_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `execution_time` int NOT NULL,
  `success` tinyint(1) NOT NULL,
  PRIMARY KEY (`installed_rank`),
  KEY `flyway_schema_history_s_idx` (`success`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flyway_schema_history`
--

LOCK TABLES `flyway_schema_history` WRITE;
/*!40000 ALTER TABLE `flyway_schema_history` DISABLE KEYS */;
INSERT INTO `flyway_schema_history` VALUES (1,'1','foundation','SQL','V1__foundation.sql',-2037950191,'root','2026-10-14 02:44:55',139,1),(2,'2','identity','SQL','V2__identity.sql',1814223636,'root','2026-10-14 02:44:55',460,1),(3,'3','identity recovery and rate limit','SQL','V3__identity_recovery_and_rate_limit.sql',-1547661160,'root','2026-10-14 02:55:07',133,1),(4,'4','catalog','SQL','V4__catalog.sql',-2062728440,'root','2026-10-14 03:38:22',370,1),(5,'5','media and cms','SQL','V5__media_and_cms.sql',1913391722,'root','2026-10-14 07:02:42',545,1),(6,'6','showcase content fields','SQL','V6__showcase_content_fields.sql',47446572,'root','2026-10-15 09:55:41',1623,1);
/*!40000 ALTER TABLE `flyway_schema_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `idempotency_records`
--

DROP TABLE IF EXISTS `idempotency_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `idempotency_records` (
  `id` char(26) NOT NULL,
  `idempotency_key` varchar(100) NOT NULL,
  `user_id` char(26) NOT NULL,
  `operation` varchar(100) NOT NULL,
  `request_hash` char(64) NOT NULL,
  `response_status` smallint DEFAULT NULL,
  `response_body` json DEFAULT NULL,
  `expires_at` timestamp(6) NOT NULL,
  `created_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_idempotency_scope` (`user_id`,`operation`,`idempotency_key`),
  KEY `idx_idempotency_expiry` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `idempotency_records`
--

LOCK TABLES `idempotency_records` WRITE;
/*!40000 ALTER TABLE `idempotency_records` DISABLE KEYS */;
/*!40000 ALTER TABLE `idempotency_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media`
--

DROP TABLE IF EXISTS `media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `media` (
  `id` char(26) NOT NULL,
  `url` varchar(2048) NOT NULL,
  `storage_key` varchar(500) DEFAULT NULL,
  `mime_type` varchar(100) NOT NULL,
  `width` int DEFAULT NULL,
  `height` int DEFAULT NULL,
  `alt_text` varchar(255) NOT NULL,
  `checksum` char(64) DEFAULT NULL,
  `created_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_media_storage_key` (`storage_key`),
  KEY `idx_media_checksum` (`checksum`),
  CONSTRAINT `ck_media_height` CHECK (((`height` is null) or (`height` > 0))),
  CONSTRAINT `ck_media_width` CHECK (((`width` is null) or (`width` > 0)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media`
--

LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;
INSERT INTO `media` VALUES ('24000000000000000000000001','https://www.mamashopinc.com/cdn/shop/files/Ruou_Lang_Classic_750ml_2.avif?v=1764663493&width=1445',NULL,'image/avif',NULL,NULL,'Bàu Đá Truyền Thống',NULL,'2026-10-15 09:56:26.510712'),('24000000000000000000000002','https://museawards.world/upload/entry/files/ME214022/small/24151680762805.jpg',NULL,'image/jpeg',NULL,NULL,'Bàu Đá Truyền Thống',NULL,'2026-10-15 09:56:26.510712'),('24000000000000000000000003','https://www.missingumami.com/images/hero/shaoxing-bottle.webp',NULL,'image/webp',NULL,NULL,'Bàu Đá Truyền Thống',NULL,'2026-10-15 09:56:26.510712'),('24000000000000000000000004','https://kokyo-market.com/cdn/shop/files/RV01_2.jpg?v=1757076411',NULL,'image/jpeg',NULL,NULL,'Nếp Cái Hoa Vàng',NULL,'2026-10-15 09:56:26.510712'),('24000000000000000000000005','https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=1600&q=85',NULL,'image/jpeg',NULL,NULL,'Men rượu giữ hồn làng qua những mùa gió nồm',NULL,'2026-10-15 09:56:26.510712'),('24000000000000000000000006','https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?auto=format&fit=crop&w=1200&q=85',NULL,'image/jpeg',NULL,NULL,'Chọn rượu cho một bữa cơm Việt trọn vị',NULL,'2026-10-15 09:56:26.510712'),('24000000000000000000000007','https://images.unsplash.com/photo-1536304993881-ff6e9eefa2a6?auto=format&fit=crop&w=1200&q=85',NULL,'image/jpeg',NULL,NULL,'Hành trình của hạt gạo trong một mẻ rượu thủ công',NULL,'2026-10-15 09:56:26.510712'),('24000000000000000000000008','https://images.unsplash.com/photo-1527281400683-1aae777175f8?auto=format&fit=crop&w=1200&q=85',NULL,'image/jpeg',NULL,NULL,'Thưởng thức có trách nhiệm là một phần của văn hóa rượu',NULL,'2026-10-15 09:56:26.510712'),('24000000000000000000000009','https://images.unsplash.com/photo-1609412058473-c199497c3c5d?auto=format&fit=crop&w=2000&q=88',NULL,'image/jpeg',NULL,NULL,'Banner trang chủ',NULL,'2026-10-15 09:56:26.510712'),('24000000000000000000000010','https://images.unsplash.com/photo-1536304993881-ff6e9eefa2a6?auto=format&fit=crop&w=1600&q=90',NULL,'image/jpeg',NULL,NULL,'Hạt gạo nguyên liệu',NULL,'2026-10-15 09:56:26.510712'),('24000000000000000000000011','https://images.unsplash.com/photo-1516594915697-87eb3b1c14ea?auto=format&fit=crop&w=2000&q=86',NULL,'image/jpeg',NULL,NULL,'Ảnh nền trang nội dung',NULL,'2026-10-15 09:56:26.510712'),('24000000000000000000000012','https://images.unsplash.com/photo-1516594915697-87eb3b1c14ea?auto=format&fit=crop&w=1400&q=85',NULL,'image/jpeg',NULL,NULL,'Ảnh trang đăng nhập',NULL,'2026-10-15 09:56:26.510712'),('24000000000000000000000013','https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=2000&q=85',NULL,'image/jpeg',NULL,NULL,'Ảnh trang liên hệ',NULL,'2026-10-15 09:56:26.510712');
/*!40000 ALTER TABLE `media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `id` char(26) NOT NULL,
  `user_id` char(26) NOT NULL,
  `token_hash` char(64) NOT NULL,
  `expires_at` timestamp(6) NOT NULL,
  `consumed_at` timestamp(6) NULL DEFAULT NULL,
  `created_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_password_reset_hash` (`token_hash`),
  KEY `idx_password_reset_user` (`user_id`),
  KEY `idx_password_reset_expiry` (`expires_at`),
  CONSTRAINT `fk_password_reset_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` char(26) NOT NULL,
  `code` varchar(80) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_permissions_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES ('10000000000000000000000001','ADMIN_ACCESS','Truy cập khu vực quản trị'),('10000000000000000000000002','USER_MANAGE','Quản lý tài khoản và phân quyền'),('10000000000000000000000003','CATALOG_MANAGE','Quản lý danh mục và sản phẩm'),('10000000000000000000000004','INVENTORY_MANAGE','Quản lý kho'),('10000000000000000000000005','ORDER_MANAGE','Quản lý đơn hàng'),('10000000000000000000000006','PAYMENT_RECONCILE','Đối soát thanh toán'),('10000000000000000000000007','PAYMENT_REFUND','Hoàn tiền'),('10000000000000000000000008','ARTICLE_MANAGE','Quản lý và xuất bản bài viết'),('10000000000000000000000009','AUDIT_READ','Xem nhật ký kiểm toán');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `producers`
--

DROP TABLE IF EXISTS `producers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `producers` (
  `id` char(26) NOT NULL,
  `name` varchar(160) NOT NULL,
  `legal_name` varchar(200) DEFAULT NULL,
  `origin` varchar(200) DEFAULT NULL,
  `contact` varchar(1000) DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `version` bigint NOT NULL DEFAULT '0',
  `created_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_producers_status` (`status`,`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `producers`
--

LOCK TABLES `producers` WRITE;
/*!40000 ALTER TABLE `producers` DISABLE KEYS */;
INSERT INTO `producers` VALUES ('01M4WQPSQW8VKGA115SFH4B2M5','Làng nghề Bàu Đá Xứ Nẫu',NULL,'Nhơn Lộc, An Nhơn, Bình Định',NULL,'ACTIVE',0,'2026-10-14 01:15:51.036694','2026-10-14 01:15:51.036694',NULL),('21000000000000000000000001','Cơ sở làng nghề Cù Lâm',NULL,'An Nhơn, Bình Định',NULL,'ACTIVE',0,'2026-10-15 09:56:26.483180','2026-10-15 09:56:26.483180',NULL),('21000000000000000000000002','Xưởng ủ Nhơn Lộc',NULL,'Thị xã An Nhơn, Bình Định',NULL,'ACTIVE',0,'2026-10-15 09:56:26.483180','2026-10-15 09:56:26.483180',NULL),('21000000000000000000000003','Nhà ủ Tây Sơn',NULL,'Tây Sơn, Bình Định',NULL,'ACTIVE',0,'2026-10-15 09:56:26.483180','2026-10-15 09:56:26.483180',NULL),('21000000000000000000000004','Hợp tác xã An Lão',NULL,'An Lão, Bình Định',NULL,'ACTIVE',0,'2026-10-15 09:56:26.483180','2026-10-15 09:56:26.483180',NULL),('21000000000000000000000005','Rượu Xứ Nẫu',NULL,'Bình Định',NULL,'ACTIVE',0,'2026-10-15 09:56:26.483180','2026-10-15 09:56:26.483180',NULL);
/*!40000 ALTER TABLE `producers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_images`
--

DROP TABLE IF EXISTS `product_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_images` (
  `product_id` char(26) NOT NULL,
  `media_id` char(26) NOT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  `is_primary` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`product_id`,`media_id`),
  KEY `idx_product_images_order` (`product_id`,`sort_order`),
  KEY `idx_product_images_primary` (`product_id`,`is_primary`),
  KEY `fk_product_images_media` (`media_id`),
  CONSTRAINT `fk_product_images_media` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`),
  CONSTRAINT `fk_product_images_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_images`
--

LOCK TABLES `product_images` WRITE;
/*!40000 ALTER TABLE `product_images` DISABLE KEYS */;
INSERT INTO `product_images` VALUES ('22000000000000000000000001','24000000000000000000000001',0,1),('22000000000000000000000001','24000000000000000000000002',1,0),('22000000000000000000000001','24000000000000000000000003',2,0),('22000000000000000000000002','24000000000000000000000001',1,0),('22000000000000000000000002','24000000000000000000000003',2,0),('22000000000000000000000002','24000000000000000000000004',0,1),('22000000000000000000000003','24000000000000000000000001',1,0),('22000000000000000000000003','24000000000000000000000002',0,1),('22000000000000000000000003','24000000000000000000000003',2,0),('22000000000000000000000004','24000000000000000000000001',2,0),('22000000000000000000000004','24000000000000000000000003',0,1),('22000000000000000000000004','24000000000000000000000004',1,0),('22000000000000000000000005','24000000000000000000000001',0,1),('22000000000000000000000005','24000000000000000000000002',2,0),('22000000000000000000000005','24000000000000000000000003',1,0),('22000000000000000000000006','24000000000000000000000001',1,0),('22000000000000000000000006','24000000000000000000000002',0,1),('22000000000000000000000006','24000000000000000000000004',2,0);
/*!40000 ALTER TABLE `product_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_variants`
--

DROP TABLE IF EXISTS `product_variants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_variants` (
  `id` char(26) NOT NULL,
  `product_id` char(26) NOT NULL,
  `sku` varchar(80) NOT NULL,
  `barcode` varchar(80) DEFAULT NULL,
  `volume_ml` int NOT NULL,
  `alcohol_percent` decimal(5,2) NOT NULL,
  `price` decimal(19,2) NOT NULL,
  `compare_price` decimal(19,2) DEFAULT NULL,
  `weight_gram` int NOT NULL,
  `stock_quantity` int NOT NULL DEFAULT '0',
  `status` varchar(20) NOT NULL,
  `version` bigint NOT NULL DEFAULT '0',
  `created_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_product_variants_sku` (`sku`),
  UNIQUE KEY `uk_product_variants_barcode` (`barcode`),
  KEY `idx_variants_product` (`product_id`,`status`,`deleted_at`),
  CONSTRAINT `fk_variants_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `ck_variants_alcohol` CHECK (((`alcohol_percent` >= 0) and (`alcohol_percent` <= 100))),
  CONSTRAINT `ck_variants_compare_price` CHECK (((`compare_price` is null) or (`compare_price` >= `price`))),
  CONSTRAINT `ck_variants_price` CHECK ((`price` >= 0)),
  CONSTRAINT `ck_variants_stock_nonnegative` CHECK ((`stock_quantity` >= 0)),
  CONSTRAINT `ck_variants_volume` CHECK ((`volume_ml` > 0)),
  CONSTRAINT `ck_variants_weight` CHECK ((`weight_gram` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_variants`
--

LOCK TABLES `product_variants` WRITE;
/*!40000 ALTER TABLE `product_variants` DISABLE KEYS */;
INSERT INTO `product_variants` VALUES ('23000000000000000000000001','22000000000000000000000001','RXN-001',NULL,500,45.00,285000.00,320000.00,0,24,'ACTIVE',0,'2026-10-15 09:56:26.519727','2026-10-15 09:56:26.519727',NULL),('23000000000000000000000002','22000000000000000000000002','RXN-002',NULL,500,29.00,245000.00,NULL,0,18,'ACTIVE',0,'2026-10-15 09:56:26.519727','2026-10-15 09:56:26.519727',NULL),('23000000000000000000000003','22000000000000000000000003','RXN-003',NULL,700,38.00,490000.00,550000.00,0,8,'ACTIVE',0,'2026-10-15 09:56:26.519727','2026-10-15 09:56:26.519727',NULL),('23000000000000000000000004','22000000000000000000000004','RXN-004',NULL,500,18.00,210000.00,NULL,0,32,'ACTIVE',0,'2026-10-15 09:56:26.519727','2026-10-15 09:56:26.519727',NULL),('23000000000000000000000005','22000000000000000000000005','RXN-005',NULL,500,35.00,330000.00,NULL,0,14,'ACTIVE',0,'2026-10-15 09:56:26.519727','2026-10-15 09:56:26.519727',NULL),('23000000000000000000000006','22000000000000000000000006','RXN-006',NULL,700,40.00,790000.00,NULL,0,6,'ACTIVE',0,'2026-10-15 09:56:26.519727','2026-10-15 09:56:26.519727',NULL);
/*!40000 ALTER TABLE `product_variants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` char(26) NOT NULL,
  `category_id` char(26) NOT NULL,
  `producer_id` char(26) DEFAULT NULL,
  `name` varchar(180) NOT NULL,
  `slug` varchar(200) NOT NULL,
  `short_description` varchar(500) DEFAULT NULL,
  `material` varchar(255) DEFAULT NULL,
  `badge` varchar(80) DEFAULT NULL,
  `featured` tinyint(1) NOT NULL DEFAULT '0',
  `tasting_notes` json DEFAULT NULL,
  `description` text NOT NULL,
  `storage_instructions` varchar(1000) DEFAULT NULL,
  `origin` varchar(200) DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `seo_title` varchar(180) DEFAULT NULL,
  `seo_description` varchar(320) DEFAULT NULL,
  `primary_media_id` char(26) DEFAULT NULL,
  `version` bigint NOT NULL DEFAULT '0',
  `created_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_products_slug` (`slug`),
  KEY `idx_products_public` (`status`,`deleted_at`,`created_at`),
  KEY `idx_products_category` (`category_id`,`status`,`deleted_at`),
  KEY `idx_products_producer` (`producer_id`),
  KEY `idx_products_primary_media` (`primary_media_id`),
  CONSTRAINT `fk_products_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  CONSTRAINT `fk_products_primary_media` FOREIGN KEY (`primary_media_id`) REFERENCES `media` (`id`),
  CONSTRAINT `fk_products_producer` FOREIGN KEY (`producer_id`) REFERENCES `producers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES ('22000000000000000000000001','20000000000000000000000001','21000000000000000000000001','Bàu Đá Truyền Thống','bau-da-truyen-thong','Vị nồng ấm, hậu ngọt sâu, chưng cất thủ công theo lối xưa.','Gạo lứt và men gia truyền','Bán chạy',1,'[\"Gạo rang\", \"Thảo mộc\", \"Hậu ngọt\"]','Một phiên bản gợi nhắc tinh thần rượu Bàu Đá Bình Định: mạnh mẽ ở ngụm đầu, êm dần và để lại hậu vị của hạt gạo rang. Nội dung và bao bì hiện là dữ liệu mẫu để hoàn thiện trải nghiệm.',NULL,'An Nhơn, Bình Định','ACTIVE',NULL,NULL,'24000000000000000000000001',0,'2026-10-15 09:56:26.514508','2026-10-15 09:56:26.514508',NULL),('22000000000000000000000002','20000000000000000000000002','21000000000000000000000002','Nếp Cái Hoa Vàng','nep-cai-hoa-vang','Hương nếp chín dịu, thân rượu mềm và cân bằng.','Nếp cái hoa vàng','Mới',1,'[\"Nếp chín\", \"Hoa trắng\", \"Mật nhẹ\"]','Ủ từ nếp thơm và men truyền thống, dòng rượu nhẹ hơn dành cho những bữa cơm sum họp. Thông tin sản phẩm đang ở chế độ minh họa.',NULL,'Thị xã An Nhơn, Bình Định','ACTIVE',NULL,NULL,'24000000000000000000000004',0,'2026-10-15 09:56:26.514508','2026-10-15 09:56:26.514508',NULL),('22000000000000000000000003','20000000000000000000000003','21000000000000000000000003','Hoàng Kim Hạ Thổ','hoang-kim-ha-tho','Ủ chum hạ thổ cho sắc hổ phách và tầng hương sâu.','Gạo thơm tuyển chọn','Giới hạn',1,'[\"Mơ chín\", \"Gỗ nhẹ\", \"Hạt rang\"]','Dòng rượu ủ giới hạn với hình dung về một phiên bản quà tặng trang trọng, phù hợp dịp lễ và tiếp khách.',NULL,'Tây Sơn, Bình Định','ACTIVE',NULL,NULL,'24000000000000000000000002',0,'2026-10-15 09:56:26.514508','2026-10-15 09:56:26.514508',NULL),('22000000000000000000000004','20000000000000000000000002','21000000000000000000000004','Nếp Than An Lão','ruou-nep-than','Màu đỏ tím tự nhiên, vị chua ngọt hài hòa.','Nếp than',NULL,1,'[\"Mận đỏ\", \"Nếp than\", \"Chua dịu\"]','Dòng rượu lên men nhẹ từ nếp than, hương vị dễ tiếp cận và phù hợp dùng lạnh.',NULL,'An Lão, Bình Định','ACTIVE',NULL,NULL,'24000000000000000000000003',0,'2026-10-15 09:56:26.514508','2026-10-15 09:56:26.514508',NULL),('22000000000000000000000005','20000000000000000000000004','21000000000000000000000003','Men Lá Tây Sơn','men-la-tay-son','Mùi men lá thanh, vị ấm và giàu cá tính núi rừng.','Gạo và men lá','Đặc sản',0,'[\"Lá thơm\", \"Tiêu rừng\", \"Gạo mới\"]','Gợi cảm hứng từ men lá bản địa với cách trình bày hiện đại. Dữ liệu mẫu phục vụ thiết kế giao diện.',NULL,'Tây Sơn, Bình Định','ACTIVE',NULL,NULL,'24000000000000000000000001',0,'2026-10-15 09:56:26.514508','2026-10-15 09:56:26.514508',NULL),('22000000000000000000000006','20000000000000000000000005','21000000000000000000000005','Hộp Quà Xứ Nẫu','qua-tang-xu-nau','Hộp quà trang nhã cho lễ Tết và đối tác.','Bàu Đá tuyển chọn','Quà tặng',0,'[\"Gạo thơm\", \"Vani\", \"Hậu dài\"]','Bộ quà tặng mẫu gồm rượu tuyển chọn và ly thưởng thức, hướng tới khách hàng doanh nghiệp.',NULL,'Bình Định','ACTIVE',NULL,NULL,'24000000000000000000000002',0,'2026-10-15 09:56:26.514508','2026-10-15 09:56:26.514508',NULL);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refresh_tokens`
--

DROP TABLE IF EXISTS `refresh_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `refresh_tokens` (
  `id` char(26) NOT NULL,
  `user_id` char(26) NOT NULL,
  `family_id` char(26) NOT NULL,
  `token_hash` char(64) NOT NULL,
  `replaced_by_token_hash` char(64) DEFAULT NULL,
  `expires_at` timestamp(6) NOT NULL,
  `revoked_at` timestamp(6) NULL DEFAULT NULL,
  `last_used_at` timestamp(6) NULL DEFAULT NULL,
  `created_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_refresh_token_hash` (`token_hash`),
  KEY `idx_refresh_user` (`user_id`),
  KEY `idx_refresh_family` (`family_id`),
  KEY `idx_refresh_expiry` (`expires_at`),
  CONSTRAINT `fk_refresh_tokens_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refresh_tokens`
--

LOCK TABLES `refresh_tokens` WRITE;
/*!40000 ALTER TABLE `refresh_tokens` DISABLE KEYS */;
INSERT INTO `refresh_tokens` VALUES ('01M4W6B3CHYRK168HFN8HMF3BE','01M4W68N231KS59HYAE86S9PGH','01M4W6B3CFQ938Q4TEHBDJAWBQ','40c73f16e59302ecd34637eea022f47223c9195b2a5735d5925ab4456e627e7e',NULL,'2026-11-12 20:12:21.903332',NULL,NULL,'2026-10-13 20:12:21.903332'),('01M4W6P6QYPKDWV9Y6ZYKRRSCP','01M4W68N231KS59HYAE86S9PGH','01M4W6P6QW1FDT7YM4CDFE1JAH','9338cc92c5169c265edc1e38ea52637df599fe10f47fa2bb2e8d06969cdcaae3',NULL,'2026-11-12 20:18:25.788255',NULL,NULL,'2026-10-13 20:18:25.788255'),('01M4W7WFQAHB549G2S7PV4AMKH','01M4W68N231KS59HYAE86S9PGH','01M4W7WFQ8FNNSZWNBB6X6B9DF','3f430710723cc5354d2767b1a14bcbbc3ac1561d4685199818979f00e6b9a070',NULL,'2026-11-12 20:39:20.169484',NULL,NULL,'2026-10-13 20:39:20.169484'),('01M4W7XYVN4XN9SYEW276ARJE9','01M4W68N231KS59HYAE86S9PGH','01M4W7XYVMNE5HZ209GAZPT54K','87fd12cb6541a8eeaac0092d57364e9ea11e8f30c239872d6f9270ae483bda81',NULL,'2026-11-12 20:40:08.437578',NULL,NULL,'2026-10-13 20:40:08.437578'),('01M4WKN65Q9H8EJJMZ55345Q95','01M4W68N231KS59HYAE86S9PGH','01M4WKN65MKGM4JK2FRSVK3321','df98d0f030ca7ecc129387c5327b8fff04c946347032d5a8e611808923fd09ee',NULL,'2026-11-13 00:05:03.925036',NULL,NULL,'2026-10-14 00:05:03.925036'),('01M4ZXYHN2H423Y1T3YA6BDDTJ','01M4W68N231KS59HYAE86S9PGH','01M4ZXYHN2A9CEZDYRZ8G9D7W8','d0b74183523b1028f692c7d3545b6256cd9e79e94e9c42540aad41909f40b2e7',NULL,'2026-11-14 07:02:39.650957',NULL,NULL,'2026-10-15 07:02:39.650957'),('01M4ZYFHBHEFTZKB98VV8SRVQE','01M4W68N231KS59HYAE86S9PGH','01M4ZYFHBCBHP45BHFA537SVGC','0706f678aab9b3106935bb5aa58d6df7f9b7e68eaa6c3226dac00887743099f3',NULL,'2026-11-14 07:11:56.396197',NULL,NULL,'2026-10-15 07:11:56.396197'),('01M4ZYG5N000JAVJARWVQM0C2W','01M4W68N231KS59HYAE86S9PGH','01M4ZYG5N0EXVBD8JJ563WBCFB','ad378c9e54af5f09b65cd58f77e57e702333ec177ff3b874f4d70ba99f7e9593','27ce5ac27709aa4c39827ab90a823ffe42e469a473846b5b974889ccbb50b362','2026-11-14 07:12:17.184541','2026-10-15 07:12:17.276169','2026-10-15 07:12:17.276169','2026-10-15 07:12:17.184541'),('01M4ZYG5S4XETNAYVSZB60HWPM','01M4W68N231KS59HYAE86S9PGH','01M4ZYG5N0EXVBD8JJ563WBCFB','27ce5ac27709aa4c39827ab90a823ffe42e469a473846b5b974889ccbb50b362',NULL,'2026-11-14 07:12:17.276169',NULL,NULL,'2026-10-15 07:12:17.276169');
/*!40000 ALTER TABLE `refresh_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_permissions`
--

DROP TABLE IF EXISTS `role_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_permissions` (
  `role_id` char(26) NOT NULL,
  `permission_id` char(26) NOT NULL,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `fk_role_permissions_permission` (`permission_id`),
  CONSTRAINT `fk_role_permissions_permission` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_role_permissions_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_permissions`
--

LOCK TABLES `role_permissions` WRITE;
/*!40000 ALTER TABLE `role_permissions` DISABLE KEYS */;
INSERT INTO `role_permissions` VALUES ('00000000000000000000000002','10000000000000000000000001'),('00000000000000000000000002','10000000000000000000000002'),('00000000000000000000000002','10000000000000000000000003'),('00000000000000000000000002','10000000000000000000000004'),('00000000000000000000000002','10000000000000000000000005'),('00000000000000000000000002','10000000000000000000000006'),('00000000000000000000000002','10000000000000000000000007'),('00000000000000000000000002','10000000000000000000000008'),('00000000000000000000000002','10000000000000000000000009');
/*!40000 ALTER TABLE `role_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` char(26) NOT NULL,
  `code` varchar(60) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_roles_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES ('00000000000000000000000001','CUSTOMER','Khách hàng'),('00000000000000000000000002','ADMIN','Quản trị viên');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_assets`
--

DROP TABLE IF EXISTS `site_assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `site_assets` (
  `asset_key` varchar(100) NOT NULL,
  `media_id` char(26) NOT NULL,
  `updated_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`asset_key`),
  KEY `fk_site_assets_media` (`media_id`),
  CONSTRAINT `fk_site_assets_media` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_assets`
--

LOCK TABLES `site_assets` WRITE;
/*!40000 ALTER TABLE `site_assets` DISABLE KEYS */;
INSERT INTO `site_assets` VALUES ('auth.visual','24000000000000000000000012','2026-10-15 09:56:26.611160'),('contact.hero','24000000000000000000000013','2026-10-15 09:56:26.611160'),('home.craft','24000000000000000000000010','2026-10-15 09:56:26.611160'),('home.hero','24000000000000000000000009','2026-10-15 09:56:26.611160'),('page.hero','24000000000000000000000011','2026-10-15 09:56:26.611160');
/*!40000 ALTER TABLE `site_assets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tags` (
  `id` char(26) NOT NULL,
  `name` varchar(80) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `created_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tags_name` (`name`),
  UNIQUE KEY `uk_tags_slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_roles` (
  `user_id` char(26) NOT NULL,
  `role_id` char(26) NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `fk_user_roles_role` (`role_id`),
  CONSTRAINT `fk_user_roles_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `fk_user_roles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` VALUES ('01M4W68N231KS59HYAE86S9PGH','00000000000000000000000002');
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` char(26) NOT NULL,
  `email` varchar(254) NOT NULL,
  `password_hash` varchar(100) NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `age_confirmed_at` timestamp(6) NOT NULL,
  `failed_login_attempts` int NOT NULL DEFAULT '0',
  `locked_until` timestamp(6) NULL DEFAULT NULL,
  `version` bigint NOT NULL DEFAULT '0',
  `created_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_users_email` (`email`),
  KEY `idx_users_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('01M4W68N231KS59HYAE86S9PGH','lovehoaivulover@gmail.com','$2a$12$ZYo0lHEFwt2ARPVyJVxP..qNsvhxuiyNjIUwrfRE97abJPu9VsgpG','Đặng Hoài Vũ',NULL,'ACTIVE','2026-10-13 20:11:01.698908',0,NULL,9,'2026-10-13 20:11:01.698908','2026-10-15 07:12:16.034866');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'binh_dinh_wine'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-15 21:14:01
