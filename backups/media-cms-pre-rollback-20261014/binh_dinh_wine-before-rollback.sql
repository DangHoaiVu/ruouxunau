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
-- Current Database: `binh_dinh_wine`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `binh_dinh_wine` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `binh_dinh_wine`;

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
INSERT INTO `article_categories` VALUES ('01M4WQPTPQEF7EC3NFBRGPJ2PW','Làng nghề','lang-nghe','Con người và không gian làm nghề.','ACTIVE',1,0,'2026-10-14 01:15:52.023831','2026-10-14 01:15:52.023831',NULL),('01M4WQPTQ8QJP32V0PRT4EAFAS','Kỹ nghệ','ky-nghe','Quy trình, nguyên liệu và kinh nghiệm thủ công.','ACTIVE',2,0,'2026-10-14 01:15:52.040035','2026-10-14 01:15:52.040035',NULL),('01M4WQPTR77TS6NMYP56TJVC9X','Thưởng thức','thuong-thuc','Cách cảm nhận và sử dụng có trách nhiệm.','ACTIVE',3,0,'2026-10-14 01:15:52.071342','2026-10-14 01:15:52.071342',NULL),('01M4WQPTRSEVJKV0M3G1NFZC48','Văn hóa','van-hoa','Rượu trong đời sống văn hóa miền đất võ.','ACTIVE',4,0,'2026-10-14 01:15:52.089463','2026-10-14 01:15:52.089463',NULL);
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
  CONSTRAINT `fk_articles_featured_media` FOREIGN KEY (`featured_media_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `articles`
--

LOCK TABLES `articles` WRITE;
/*!40000 ALTER TABLE `articles` DISABLE KEYS */;
INSERT INTO `articles` VALUES ('01M4WQPTVGQ6FXDG83ZGN31WV7','01M4W68N231KS59HYAE86S9PGH','01M4WQPTPQEF7EC3NFBRGPJ2PW','01M4WQPSG1YHXSAHXNTXFGWJN5','Ngọn lửa không tắt ở làng Bàu Đá','ngon-lua-khong-tat-o-lang-bau-da','Theo chân người thợ gìn giữ nhịp lửa đều qua từng mẻ rượu.','Lửa trong lò không cần bùng lớn, nhưng phải đều và bền. Người thợ nhìn màu lửa, nghe tiếng sôi và điều chỉnh từng thanh củi để dòng rượu ra chậm, trong.\n\nỞ làng nghề, kinh nghiệm ấy được truyền bằng những buổi đứng bếp cùng nhau. Mỗi thế hệ thêm một cách làm sạch hơn, an toàn hơn nhưng vẫn giữ sự kiên nhẫn làm nên hương vị riêng.','PUBLISHED','2026-10-14 01:15:52.288069','Ngọn lửa không tắt ở làng Bàu Đá | Tạp chí Xứ Nẫu','Theo chân người thợ gìn giữ nhịp lửa đều qua từng mẻ rượu.',2,'2026-10-14 01:15:52.176655','2026-10-14 01:15:52.288069',NULL),('01M4WQPTZXPCMS66QBSN7AKB0A','01M4W68N231KS59HYAE86S9PGH','01M4WQPTQ8QJP32V0PRT4EAFAS','01M4WQPSEBJR0ZPEA9MKC93W33','Từ hạt gạo đến giọt rượu trong','tu-hat-gao-den-giot-ruou-trong','Bốn chặng chính tạo nên một mẻ rượu gạo thủ công.','Gạo được chọn theo độ thơm, độ dẻo và sự đồng đều. Sau khi nấu chín, cơm được làm nguội đúng mức trước khi trộn men.\n\nQuá trình ủ tạo hương, còn chưng cất quyết định độ trong và sự cân bằng. Dòng đầu và dòng cuối được kiểm soát kỹ để phần rượu giữ lại có chất lượng ổn định.','PUBLISHED','2026-10-14 01:15:52.390144','Từ hạt gạo đến giọt rượu trong | Tạp chí Xứ Nẫu','Bốn chặng chính tạo nên một mẻ rượu gạo thủ công.',2,'2026-10-14 01:15:52.317413','2026-10-14 01:15:52.390144',NULL),('01M4WQPV34ETTP8BHPPFR3992W','01M4W68N231KS59HYAE86S9PGH','01M4WQPTQ8QJP32V0PRT4EAFAS','01M4WQPSDRQ6R680M22DE9BH8R','Nước nguồn và hương vị Bàu Đá','nuoc-nguon-va-huong-vi-bau-da','Vì sao nguồn nước luôn được nhắc đến khi kể về rượu Bàu Đá.','Nước tham gia vào nhiều công đoạn, từ nấu cơm đến làm nguội hệ thống chưng cất. Độ khoáng và sự sạch của nước ảnh hưởng trực tiếp đến cảm nhận cuối cùng.\n\nNgày nay, người làm nghề kết hợp kinh nghiệm địa phương với kiểm soát chất lượng để bảo đảm mỗi mẻ rượu an toàn và nhất quán hơn.','PUBLISHED','2026-10-14 01:15:52.560989','Nước nguồn và hương vị Bàu Đá | Tạp chí Xứ Nẫu','Vì sao nguồn nước luôn được nhắc đến khi kể về rượu Bàu Đá.',2,'2026-10-14 01:15:52.420921','2026-10-14 01:15:52.560989',NULL),('01M4WQPV8JBFFJQXE3W6A5Y20J','01M4W68N231KS59HYAE86S9PGH','01M4WQPTQ8QJP32V0PRT4EAFAS','01M4WQPSF80WS532EHBFGQ46K4','Nhịp ủ men qua những ngày mưa','nhip-u-men-qua-nhung-ngay-mua','Nhiệt độ và độ ẩm thay đổi buộc người thợ lắng nghe mẻ ủ kỹ hơn.','Men là phần sống động nhất của quy trình. Khi trời ẩm, thời gian và cách giữ nhiệt cần được điều chỉnh để cơm rượu chuyển hóa từ từ.\n\nKhông có một con số cứng cho mọi ngày. Sự ổn định đến từ việc ghi chép, quan sát và kiểm tra thay vì chỉ dựa vào thói quen.','PUBLISHED','2026-10-14 01:15:52.683162','Nhịp ủ men qua những ngày mưa | Tạp chí Xứ Nẫu','Nhiệt độ và độ ẩm thay đổi buộc người thợ lắng nghe mẻ ủ kỹ hơn.',2,'2026-10-14 01:15:52.594603','2026-10-14 01:15:52.683162',NULL),('01M4WQPVC9H7R0VWH2FAH9YNBV','01M4W68N231KS59HYAE86S9PGH','01M4WQPTRSEVJKV0M3G1NFZC48','01M4WQPSGQF4P948QMX685KJVZ','Một chén rượu trong mâm cơm Xứ Nẫu','mot-chen-ruou-trong-mam-com-xu-nau','Rượu hiện diện như lời mời, sự sẻ chia và một giới hạn cần được tôn trọng.','Trong những dịp gặp gỡ, chén rượu nhỏ mở đầu câu chuyện và thể hiện sự hiếu khách. Giá trị nằm ở khoảnh khắc quây quần, không nằm ở việc uống nhiều.\n\nThưởng thức có trách nhiệm là biết dừng đúng lúc, không mời người dưới 18 tuổi và tuyệt đối không lái xe sau khi uống.','PUBLISHED','2026-10-14 01:15:52.793037','Một chén rượu trong mâm cơm Xứ Nẫu | Tạp chí Xứ Nẫu','Rượu hiện diện như lời mời, sự sẻ chia và một giới hạn cần được tôn trọng.',2,'2026-10-14 01:15:52.713702','2026-10-14 01:15:52.793037',NULL),('01M4WQPVFKVQ42Q7JNMVWKDR0P','01M4W68N231KS59HYAE86S9PGH','01M4WQPTR77TS6NMYP56TJVC9X','01M4WQPSBMAB4T74X3KD97HPW8','Chọn bình rượu làm quà miền đất võ','chon-binh-ruou-lam-qua-mien-dat-vo','Gợi ý chọn dung tích, dáng bình và câu chuyện phù hợp người nhận.','Một món quà đẹp bắt đầu từ sự phù hợp. Bình 500 ml gọn cho cuộc gặp thân tình, trong khi bộ song bình phù hợp dịp tri ân hoặc sum họp.\n\nNên giữ nhãn, thông tin nồng độ và nguồn gốc rõ ràng. Bao bì chắc chắn giúp món quà đến tay người nhận trọn vẹn.','PUBLISHED','2026-10-14 01:15:52.901158','Chọn bình rượu làm quà miền đất võ | Tạp chí Xứ Nẫu','Gợi ý chọn dung tích, dáng bình và câu chuyện phù hợp người nhận.',2,'2026-10-14 01:15:52.819358','2026-10-14 01:15:52.901158',NULL),('01M4WQPVJZB55S68AEF1TKDFPV','01M4W68N231KS59HYAE86S9PGH','01M4WQPTR77TS6NMYP56TJVC9X','01M4WQPSA7B6FR3VFK9X426PGC','Cách cảm nhận rượu gạo bằng ba bước','cach-cam-nhan-ruou-gao-bang-ba-buoc','Nhìn độ trong, cảm hương và nhấp một lượng nhỏ để hiểu tính cách mỗi dòng.','Trước hết, quan sát độ trong dưới ánh sáng dịu. Tiếp theo, đưa chén lại gần để cảm nhận hương mà không cần hít quá sâu.\n\nCuối cùng, nhấp một lượng nhỏ và để ý sự chuyển đổi từ vị đầu đến hậu vị. Uống chậm, dùng cùng món ăn và luôn chuẩn bị phương án di chuyển an toàn.','PUBLISHED','2026-10-14 01:15:52.989797','Cách cảm nhận rượu gạo bằng ba bước | Tạp chí Xứ Nẫu','Nhìn độ trong, cảm hương và nhấp một lượng nhỏ để hiểu tính cách mỗi dòng.',2,'2026-10-14 01:15:52.927054','2026-10-14 01:15:52.989797',NULL),('01M4WQPVNX1KQNJQQ5VEX20T6A','01M4W68N231KS59HYAE86S9PGH','01M4WQPTPQEF7EC3NFBRGPJ2PW','01M4WQPSC3HCYRX2NQVF0XAX7M','Người trẻ kể lại chuyện làng nghề','nguoi-tre-ke-lai-chuyen-lang-nghe','Thiết kế, nội dung số và truy xuất nguồn gốc đang tạo một cách tiếp cận mới.','Giữ nghề không có nghĩa là giữ nguyên mọi thứ. Người trẻ đưa hình ảnh, câu chuyện và thông tin sản phẩm lên môi trường số để khách hàng hiểu điều mình đang chọn.\n\nSự đổi mới có giá trị khi đi cùng minh bạch về nguyên liệu, nồng độ, nơi sản xuất và trách nhiệm với người dùng cuối.','PUBLISHED','2026-10-14 01:15:53.094653','Người trẻ kể lại chuyện làng nghề | Tạp chí Xứ Nẫu','Thiết kế, nội dung số và truy xuất nguồn gốc đang tạo một cách tiếp cận mới.',2,'2026-10-14 01:15:53.021570','2026-10-14 01:15:53.094653',NULL);
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
INSERT INTO `audit_logs` VALUES ('01M4WQPSADJME2J7NRTWBRS3ND','01M4W68N231KS59HYAE86S9PGH','MEDIA_CREATED','MEDIA','01M4WQPSA7B6FR3VFK9X426PGC',NULL,'{\"id\": \"01M4WQPSA7B6FR3VFK9X426PGC\", \"url\": \"https://www.chodulich.com.vn/images/2021/ruou-bau-da4.jpg\", \"altText\": \"Bình rượu Bàu Đá truyền thống\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.599236100Z\"}','7aae41764f2a4d3eb5db1f94f60e2f15','2026-10-14 01:15:50.605441'),('01M4WQPSBM8ZHC2GMKT598VGQ0','01M4W68N231KS59HYAE86S9PGH','MEDIA_CREATED','MEDIA','01M4WQPSBMAB4T74X3KD97HPW8',NULL,'{\"id\": \"01M4WQPSBMAB4T74X3KD97HPW8\", \"url\": \"https://chonongsanonline.com/public/uploads/all/zbk2tUCek6Bl34hIDJXXVxrF9q3zjJGMGDaqXLYR.jpg\", \"altText\": \"Bộ sưu tập bình rượu Bàu Đá\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.644918800Z\"}','75598fd4e8174e28ac11e68530802aea','2026-10-14 01:15:50.644919'),('01M4WQPSC3XFVXXS488AHMTQD6','01M4W68N231KS59HYAE86S9PGH','MEDIA_CREATED','MEDIA','01M4WQPSC3HCYRX2NQVF0XAX7M',NULL,'{\"id\": \"01M4WQPSC3HCYRX2NQVF0XAX7M\", \"url\": \"https://www.chodulich.cakhotranluan.com/images/2021/ruou-bau-da1.jpg\", \"altText\": \"Bình sứ họa tiết rồng xanh\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.659863900Z\"}','f7e6f632ce4f4764ab6b74119dabdbb5','2026-10-14 01:15:50.659864'),('01M4WQPSD84DCZB54SHGKWP93F','01M4W68N231KS59HYAE86S9PGH','MEDIA_CREATED','MEDIA','01M4WQPSD3NNQRQB14APPJK29C',NULL,'{\"id\": \"01M4WQPSD3NNQRQB14APPJK29C\", \"url\": \"https://www.chodulich.cakhotranluan.com/images/2021/ruou-bau-da.jpg\", \"altText\": \"Bình rượu Bàu Đá dáng bầu\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.691870300Z\"}','9d762ccc778f4113ba0bd46215193a00','2026-10-14 01:15:50.697099'),('01M4WQPSDRV1ZW91383WHQ67QZ','01M4W68N231KS59HYAE86S9PGH','MEDIA_CREATED','MEDIA','01M4WQPSDRQ6R680M22DE9BH8R',NULL,'{\"id\": \"01M4WQPSDRQ6R680M22DE9BH8R\", \"url\": \"https://peacetour.com.vn/Upload/Article/4bbf1697-0b66-4fff-ae45-e4309605b1d6/du-lich-quy-nhon-nau-ruou.jpeg\", \"altText\": \"Người thợ chưng cất rượu tại làng nghề\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.712161100Z\"}','65872077800b4712ad4fbd2941abf2ef','2026-10-14 01:15:50.712161'),('01M4WQPSEQ0MAYXA89V53ENFB6','01M4W68N231KS59HYAE86S9PGH','MEDIA_CREATED','MEDIA','01M4WQPSEBJR0ZPEA9MKC93W33',NULL,'{\"id\": \"01M4WQPSEBJR0ZPEA9MKC93W33\", \"url\": \"https://cdn2.tuoitre.vn/thumb_w/1200/tto/i/s626/2009/06/21/r57uMZJy.jpg\", \"altText\": \"Bếp chưng cất rượu Bàu Đá\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.731352100Z\"}','63bacb68a0fa4c1299246319bc6f9914','2026-10-14 01:15:50.743799'),('01M4WQPSF8RW3GK6CFA35KVTD8','01M4W68N231KS59HYAE86S9PGH','MEDIA_CREATED','MEDIA','01M4WQPSF80WS532EHBFGQ46K4',NULL,'{\"id\": \"01M4WQPSF80WS532EHBFGQ46K4\", \"url\": \"https://cdn.baogialai.com.vn/images/60e08242b719152671f3736e312ec58c973e88f5d4851a5ab55ad760db8900fd4a05425ab90370a65d8ab075e0bcc262/241828.jpg\", \"altText\": \"Chum ủ rượu truyền thống\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.760005400Z\"}','584d7589fe174de9a8365edc449f8a5c','2026-10-14 01:15:50.760005'),('01M4WQPSG306Z1ZK5QW8PV5Z70','01M4W68N231KS59HYAE86S9PGH','MEDIA_CREATED','MEDIA','01M4WQPSG1YHXSAHXNTXFGWJN5',NULL,'{\"id\": \"01M4WQPSG1YHXSAHXNTXFGWJN5\", \"url\": \"https://media.vietnamplus.vn/images/7255a701687d11cb8c6bbc58a6c807854bcf0cd6242227383ff15377d77f3aabc72ac7da06810d9ace14e4cdbb15319ca74f6b1bfe70b3203772c7979020cefa/ruou_bau_da.jpg\", \"altText\": \"Người thợ giữ lửa lò rượu\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.785566400Z\"}','a460c5240b584000bc5a34b473212c91','2026-10-14 01:15:50.787578'),('01M4WQPSGQFJRMSF0VSHVJ1GH8','01M4W68N231KS59HYAE86S9PGH','MEDIA_CREATED','MEDIA','01M4WQPSGQF4P948QMX685KJVZ',NULL,'{\"id\": \"01M4WQPSGQF4P948QMX685KJVZ\", \"url\": \"https://thanhnien.mediacdn.vn/uploaded/trongnth/2021_02_07/langnghe4_AKFB.jpg?width=500\", \"altText\": \"Làng nghề nấu rượu vào vụ Tết\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.807359200Z\"}','2bc3db26050043f2aa1ccfc0efe6716e','2026-10-14 01:15:50.807359'),('01M4WQPSH78TEH6YJHRBMQZ74G','01M4W68N231KS59HYAE86S9PGH','MEDIA_CREATED','MEDIA','01M4WQPSH7GKSSFNQPYJAA0X7J',NULL,'{\"id\": \"01M4WQPSH7GKSSFNQPYJAA0X7J\", \"url\": \"https://images.baodantoc.vn/uploads/2021/Th%C3%A1ng_12/Ng%C3%A0y%201/TRUNG/R%C6%B0%E1%BB%A3u%20mem%20l%C3%A1/6%20-%20OK.jpg\", \"altText\": \"Chưng cất rượu men lá truyền thống\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.823524Z\"}','0a5c95c84b09475c8d9d018932563219','2026-10-14 01:15:50.823524'),('01M4WQPSKWVXR6JDANTDRG3JW6','01M4W68N231KS59HYAE86S9PGH','CATEGORY_CREATED','CATEGORY','01M4WQPSKP2KC8C6ZWRJD2N8ZD',NULL,'{\"id\": \"01M4WQPSKP2KC8C6ZWRJD2N8ZD\", \"name\": \"Rượu gạo\", \"slug\": \"ruou-gao\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:50.902718900Z\", \"sortOrder\": 1, \"updatedAt\": \"2026-10-14T08:15:50.902718900Z\", \"description\": \"Rượu chưng cất từ gạo tuyển chọn.\"}','8e3f93da134a487086cb869c42dd42d1','2026-10-14 01:15:50.910858'),('01M4WQPSMG5QAJ1N2V4WKANY0S','01M4W68N231KS59HYAE86S9PGH','CATEGORY_CREATED','CATEGORY','01M4WQPSMGJJZV1S8B3ANMD0SW',NULL,'{\"id\": \"01M4WQPSMGJJZV1S8B3ANMD0SW\", \"name\": \"Rượu nếp\", \"slug\": \"ruou-nep\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:50.928848800Z\", \"sortOrder\": 2, \"updatedAt\": \"2026-10-14T08:15:50.928848800Z\", \"description\": \"Hương nếp tròn đầy, hậu vị êm.\"}','337cc113b43f4ae19729c38302238a37','2026-10-14 01:15:50.928849'),('01M4WQPSNG8J3YYT3T4ZQ33Z9W','01M4W68N231KS59HYAE86S9PGH','CATEGORY_CREATED','CATEGORY','01M4WQPSN005H6G8QTM096WD2S',NULL,'{\"id\": \"01M4WQPSN005H6G8QTM096WD2S\", \"name\": \"Rượu đậu xanh\", \"slug\": \"ruou-dau-xanh\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:50.944740700Z\", \"sortOrder\": 3, \"updatedAt\": \"2026-10-14T08:15:50.944740700Z\", \"description\": \"Dòng rượu Bàu Đá phối nguyên liệu đậu xanh.\"}','105aca469ee74eb59db38663b170b80e','2026-10-14 01:15:50.961109'),('01M4WQPSP47FGHZR07TJA4JQJE','01M4W68N231KS59HYAE86S9PGH','CATEGORY_CREATED','CATEGORY','01M4WQPSP4CNSP31A1XNZSQ1XE',NULL,'{\"id\": \"01M4WQPSP4CNSP31A1XNZSQ1XE\", \"name\": \"Quà tặng\", \"slug\": \"qua-tang\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:50.980171100Z\", \"sortOrder\": 4, \"updatedAt\": \"2026-10-14T08:15:50.980171100Z\", \"description\": \"Bình và hộp quà mang dấu ấn Bình Định.\"}','a8c3dbc394c84726a750cc4c25db3739','2026-10-14 01:15:50.980171'),('01M4WQPSR1GFBSNWA4R11X09QY','01M4W68N231KS59HYAE86S9PGH','PRODUCER_CREATED','PRODUCER','01M4WQPSQW8VKGA115SFH4B2M5',NULL,'{\"id\": \"01M4WQPSQW8VKGA115SFH4B2M5\", \"name\": \"Làng nghề Bàu Đá Xứ Nẫu\", \"origin\": \"Nhơn Lộc, An Nhơn, Bình Định\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:51.036694200Z\", \"updatedAt\": \"2026-10-14T08:15:51.036694200Z\"}','a9dd530d3853445491b07d7f4bb85863','2026-10-14 01:15:51.041851'),('01M4WQPSVG9E1XQKQGQEVMJRQ9','01M4W68N231KS59HYAE86S9PGH','PRODUCT_CREATED','PRODUCT','01M4WQPSTHCBPBSHGJJ9SJVFRW',NULL,'{\"id\": \"01M4WQPSTHCBPBSHGJJ9SJVFRW\", \"name\": \"Bàu Đá Gạo Truyền Thống\", \"slug\": \"bau-da-gao-truyen-thong\", \"images\": [], \"origin\": \"Bình Định, Việt Nam\", \"status\": \"ACTIVE\", \"version\": 0, \"category\": {\"id\": \"01M4WQPSKP2KC8C6ZWRJD2N8ZD\", \"name\": \"Rượu gạo\", \"slug\": \"ruou-gao\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:50.902719Z\", \"sortOrder\": 1, \"updatedAt\": \"2026-10-14T08:15:50.902719Z\", \"description\": \"Rượu chưng cất từ gạo tuyển chọn.\"}, \"producer\": {\"id\": \"01M4WQPSQW8VKGA115SFH4B2M5\", \"name\": \"Làng nghề Bàu Đá Xứ Nẫu\", \"origin\": \"Nhơn Lộc, An Nhơn, Bình Định\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:51.036694Z\", \"updatedAt\": \"2026-10-14T08:15:51.036694Z\"}, \"seoTitle\": \"Bàu Đá Gạo Truyền Thống | Rượu Xứ Nẫu\", \"variants\": [], \"createdAt\": \"2026-10-14T08:15:51.121292900Z\", \"updatedAt\": \"2026-10-14T08:15:51.121292900Z\", \"description\": \"Bàu Đá Gạo Truyền Thống được xây dựng như một sản phẩm tiêu biểu của bộ sưu tập Xứ Nẫu, tôn trọng nguyên liệu địa phương, nhịp chưng cất chậm và tinh thần thưởng thức có trách nhiệm.\", \"seoDescription\": \"Trong trẻo, nồng ấm và có hậu vị gạo thanh.\", \"shortDescription\": \"Trong trẻo, nồng ấm và có hậu vị gạo thanh.\", \"storageInstructions\": \"Đậy kín, đặt nơi khô ráo, tránh ánh nắng trực tiếp và nguồn nhiệt.\"}','c84d7d087152465bbb24a817eaf110af','2026-10-14 01:15:51.168603'),('01M4WQPSYG1RNYXFB72Y7099AF','01M4W68N231KS59HYAE86S9PGH','VARIANT_CREATED','PRODUCT_VARIANT','01M4WQPSY1AFQ5MTAWRJ9WEWQK',NULL,'{\"id\": \"01M4WQPSY1AFQ5MTAWRJ9WEWQK\", \"sku\": \"RXN-BDG-500\", \"price\": 260000, \"status\": \"ACTIVE\", \"version\": 0, \"volumeMl\": 500, \"createdAt\": \"2026-10-14T08:15:51.233191100Z\", \"productId\": \"01M4WQPSTHCBPBSHGJJ9SJVFRW\", \"updatedAt\": \"2026-10-14T08:15:51.233191100Z\", \"weightGram\": 950, \"alcoholPercent\": 45}','cd98449d3c494318b3e661c9d8d3bf7d','2026-10-14 01:15:51.248453'),('01M4WQPT14MXMH08EQN4VAF5V7','01M4W68N231KS59HYAE86S9PGH','PRODUCT_IMAGE_ATTACHED','PRODUCT','01M4WQPSTHCBPBSHGJJ9SJVFRW',NULL,'{\"url\": \"https://www.chodulich.com.vn/images/2021/ruou-bau-da4.jpg\", \"altText\": \"Bình rượu Bàu Đá truyền thống\", \"mediaId\": \"01M4WQPSA7B6FR3VFK9X426PGC\", \"primary\": true, \"sortOrder\": 0}','858abf7dfe4a45c196ff637fe19f3be3','2026-10-14 01:15:51.332164'),('01M4WQPT2FQG1PRMQ3KMDNZBX7','01M4W68N231KS59HYAE86S9PGH','PRODUCT_CREATED','PRODUCT','01M4WQPT1ZSYTDWBQKSGKTAG61',NULL,'{\"id\": \"01M4WQPT1ZSYTDWBQKSGKTAG61\", \"name\": \"Bàu Đá Nếp Hương\", \"slug\": \"bau-da-nep-huong\", \"images\": [], \"origin\": \"Bình Định, Việt Nam\", \"status\": \"ACTIVE\", \"version\": 0, \"category\": {\"id\": \"01M4WQPSMGJJZV1S8B3ANMD0SW\", \"name\": \"Rượu nếp\", \"slug\": \"ruou-nep\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:50.928849Z\", \"sortOrder\": 2, \"updatedAt\": \"2026-10-14T08:15:50.928849Z\", \"description\": \"Hương nếp tròn đầy, hậu vị êm.\"}, \"producer\": {\"id\": \"01M4WQPSQW8VKGA115SFH4B2M5\", \"name\": \"Làng nghề Bàu Đá Xứ Nẫu\", \"origin\": \"Nhơn Lộc, An Nhơn, Bình Định\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:51.036694Z\", \"updatedAt\": \"2026-10-14T08:15:51.036694Z\"}, \"seoTitle\": \"Bàu Đá Nếp Hương | Rượu Xứ Nẫu\", \"variants\": [], \"createdAt\": \"2026-10-14T08:15:51.359823300Z\", \"updatedAt\": \"2026-10-14T08:15:51.359823300Z\", \"description\": \"Bàu Đá Nếp Hương được xây dựng như một sản phẩm tiêu biểu của bộ sưu tập Xứ Nẫu, tôn trọng nguyên liệu địa phương, nhịp chưng cất chậm và tinh thần thưởng thức có trách nhiệm.\", \"seoDescription\": \"Hương nếp chín dịu, vị rượu dày và êm.\", \"shortDescription\": \"Hương nếp chín dịu, vị rượu dày và êm.\", \"storageInstructions\": \"Đậy kín, đặt nơi khô ráo, tránh ánh nắng trực tiếp và nguồn nhiệt.\"}','7f8992caf51d4bdca104aee351c306cc','2026-10-14 01:15:51.375476'),('01M4WQPT3B4TYK9HFB884KYDCW','01M4W68N231KS59HYAE86S9PGH','VARIANT_CREATED','PRODUCT_VARIANT','01M4WQPT3BF1FKTJB06Z1TYRQA',NULL,'{\"id\": \"01M4WQPT3BF1FKTJB06Z1TYRQA\", \"sku\": \"RXN-BDN-500\", \"price\": 295000, \"status\": \"ACTIVE\", \"version\": 0, \"volumeMl\": 500, \"createdAt\": \"2026-10-14T08:15:51.403071600Z\", \"productId\": \"01M4WQPT1ZSYTDWBQKSGKTAG61\", \"updatedAt\": \"2026-10-14T08:15:51.403071600Z\", \"weightGram\": 950, \"alcoholPercent\": 48}','6d2d2da9034743c7be91c09bae1029fa','2026-10-14 01:15:51.407262'),('01M4WQPT45HG7QG7TCWAAZ5T49','01M4W68N231KS59HYAE86S9PGH','PRODUCT_IMAGE_ATTACHED','PRODUCT','01M4WQPT1ZSYTDWBQKSGKTAG61',NULL,'{\"url\": \"https://chonongsanonline.com/public/uploads/all/zbk2tUCek6Bl34hIDJXXVxrF9q3zjJGMGDaqXLYR.jpg\", \"altText\": \"Bộ sưu tập bình rượu Bàu Đá\", \"mediaId\": \"01M4WQPSBMAB4T74X3KD97HPW8\", \"primary\": true, \"sortOrder\": 0}','1a4d3dd7b0be4f41b630e4e35ebe824e','2026-10-14 01:15:51.429789'),('01M4WQPT5E3ED8VHTZK1DBR54Z','01M4W68N231KS59HYAE86S9PGH','PRODUCT_CREATED','PRODUCT','01M4WQPT57GMPKCZ6W0Q32RGMC',NULL,'{\"id\": \"01M4WQPT57GMPKCZ6W0Q32RGMC\", \"name\": \"Bàu Đá Đậu Xanh\", \"slug\": \"bau-da-dau-xanh\", \"images\": [], \"origin\": \"Bình Định, Việt Nam\", \"status\": \"ACTIVE\", \"version\": 0, \"category\": {\"id\": \"01M4WQPSN005H6G8QTM096WD2S\", \"name\": \"Rượu đậu xanh\", \"slug\": \"ruou-dau-xanh\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:50.944741Z\", \"sortOrder\": 3, \"updatedAt\": \"2026-10-14T08:15:50.944741Z\", \"description\": \"Dòng rượu Bàu Đá phối nguyên liệu đậu xanh.\"}, \"producer\": {\"id\": \"01M4WQPSQW8VKGA115SFH4B2M5\", \"name\": \"Làng nghề Bàu Đá Xứ Nẫu\", \"origin\": \"Nhơn Lộc, An Nhơn, Bình Định\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:51.036694Z\", \"updatedAt\": \"2026-10-14T08:15:51.036694Z\"}, \"seoTitle\": \"Bàu Đá Đậu Xanh | Rượu Xứ Nẫu\", \"variants\": [], \"createdAt\": \"2026-10-14T08:15:51.463919400Z\", \"updatedAt\": \"2026-10-14T08:15:51.463919400Z\", \"description\": \"Bàu Đá Đậu Xanh được xây dựng như một sản phẩm tiêu biểu của bộ sưu tập Xứ Nẫu, tôn trọng nguyên liệu địa phương, nhịp chưng cất chậm và tinh thần thưởng thức có trách nhiệm.\", \"seoDescription\": \"Thoảng hương đậu xanh, hậu vị bùi và gọn.\", \"shortDescription\": \"Thoảng hương đậu xanh, hậu vị bùi và gọn.\", \"storageInstructions\": \"Đậy kín, đặt nơi khô ráo, tránh ánh nắng trực tiếp và nguồn nhiệt.\"}','2cfa06dc2bb44355a0459f80c99b9a4d','2026-10-14 01:15:51.470545'),('01M4WQPT5Y6QV3E5R7S9HV1PSK','01M4W68N231KS59HYAE86S9PGH','VARIANT_CREATED','PRODUCT_VARIANT','01M4WQPT5Y9QQH3HC7QF6WQTBG',NULL,'{\"id\": \"01M4WQPT5Y9QQH3HC7QF6WQTBG\", \"sku\": \"RXN-BDX-500\", \"price\": 320000, \"status\": \"ACTIVE\", \"version\": 0, \"volumeMl\": 500, \"createdAt\": \"2026-10-14T08:15:51.486481200Z\", \"productId\": \"01M4WQPT57GMPKCZ6W0Q32RGMC\", \"updatedAt\": \"2026-10-14T08:15:51.486481200Z\", \"weightGram\": 950, \"alcoholPercent\": 45}','160b3930bc2f4dff8b8197d3994c5c4c','2026-10-14 01:15:51.486481'),('01M4WQPT6ZY0SVDXWA0VH3FPPA','01M4W68N231KS59HYAE86S9PGH','PRODUCT_IMAGE_ATTACHED','PRODUCT','01M4WQPT57GMPKCZ6W0Q32RGMC',NULL,'{\"url\": \"https://www.chodulich.cakhotranluan.com/images/2021/ruou-bau-da1.jpg\", \"altText\": \"Bình sứ họa tiết rồng xanh\", \"mediaId\": \"01M4WQPSC3HCYRX2NQVF0XAX7M\", \"primary\": true, \"sortOrder\": 0}','82f5064abcfa4b3c882cd1c5017373e5','2026-10-14 01:15:51.519798'),('01M4WQPT8D7Z41XT60KTNW3CC8','01M4W68N231KS59HYAE86S9PGH','PRODUCT_CREATED','PRODUCT','01M4WQPT7Y9YG21RJEN6BD3NVV',NULL,'{\"id\": \"01M4WQPT7Y9YG21RJEN6BD3NVV\", \"name\": \"Bàu Đá Bình Sứ Rồng\", \"slug\": \"bau-da-binh-su-rong\", \"images\": [], \"origin\": \"Bình Định, Việt Nam\", \"status\": \"ACTIVE\", \"version\": 0, \"category\": {\"id\": \"01M4WQPSP4CNSP31A1XNZSQ1XE\", \"name\": \"Quà tặng\", \"slug\": \"qua-tang\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:50.980171Z\", \"sortOrder\": 4, \"updatedAt\": \"2026-10-14T08:15:50.980171Z\", \"description\": \"Bình và hộp quà mang dấu ấn Bình Định.\"}, \"producer\": {\"id\": \"01M4WQPSQW8VKGA115SFH4B2M5\", \"name\": \"Làng nghề Bàu Đá Xứ Nẫu\", \"origin\": \"Nhơn Lộc, An Nhơn, Bình Định\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:51.036694Z\", \"updatedAt\": \"2026-10-14T08:15:51.036694Z\"}, \"seoTitle\": \"Bàu Đá Bình Sứ Rồng | Rượu Xứ Nẫu\", \"variants\": [], \"createdAt\": \"2026-10-14T08:15:51.550061900Z\", \"updatedAt\": \"2026-10-14T08:15:51.550061900Z\", \"description\": \"Bàu Đá Bình Sứ Rồng được xây dựng như một sản phẩm tiêu biểu của bộ sưu tập Xứ Nẫu, tôn trọng nguyên liệu địa phương, nhịp chưng cất chậm và tinh thần thưởng thức có trách nhiệm.\", \"seoDescription\": \"Rượu gạo truyền thống trong bình sứ họa tiết Việt.\", \"shortDescription\": \"Rượu gạo truyền thống trong bình sứ họa tiết Việt.\", \"storageInstructions\": \"Đậy kín, đặt nơi khô ráo, tránh ánh nắng trực tiếp và nguồn nhiệt.\"}','f774328e4eb54e87b4d2af0562e7f3ec','2026-10-14 01:15:51.565891'),('01M4WQPT9BKQ8XVXYXBK4E6JDG','01M4W68N231KS59HYAE86S9PGH','VARIANT_CREATED','PRODUCT_VARIANT','01M4WQPT8XEAJX71D5A1WNZBCR',NULL,'{\"id\": \"01M4WQPT8XEAJX71D5A1WNZBCR\", \"sku\": \"RXN-BSR-500\", \"price\": 390000, \"status\": \"ACTIVE\", \"version\": 0, \"volumeMl\": 500, \"createdAt\": \"2026-10-14T08:15:51.581912800Z\", \"productId\": \"01M4WQPT7Y9YG21RJEN6BD3NVV\", \"updatedAt\": \"2026-10-14T08:15:51.581912800Z\", \"weightGram\": 950, \"alcoholPercent\": 45}','5c9ccc3fa1ee4fa7a007dc901af92b79','2026-10-14 01:15:51.595907'),('01M4WQPT9Y26ZNAWTQN69DDRGC','01M4W68N231KS59HYAE86S9PGH','PRODUCT_IMAGE_ATTACHED','PRODUCT','01M4WQPT7Y9YG21RJEN6BD3NVV',NULL,'{\"url\": \"https://www.chodulich.cakhotranluan.com/images/2021/ruou-bau-da.jpg\", \"altText\": \"Bình rượu Bàu Đá dáng bầu\", \"mediaId\": \"01M4WQPSD3NNQRQB14APPJK29C\", \"primary\": true, \"sortOrder\": 0}','d670de0225bf424fbf10523e71662e83','2026-10-14 01:15:51.614367'),('01M4WQPTBDA5A6DP09SDPHMCRZ','01M4W68N231KS59HYAE86S9PGH','PRODUCT_CREATED','PRODUCT','01M4WQPTAYVK1CB5QCKGXA47PV',NULL,'{\"id\": \"01M4WQPTAYVK1CB5QCKGXA47PV\", \"name\": \"Nếp Lứt Xứ Nẫu\", \"slug\": \"nep-lut-xu-nau\", \"images\": [], \"origin\": \"Bình Định, Việt Nam\", \"status\": \"ACTIVE\", \"version\": 0, \"category\": {\"id\": \"01M4WQPSMGJJZV1S8B3ANMD0SW\", \"name\": \"Rượu nếp\", \"slug\": \"ruou-nep\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:50.928849Z\", \"sortOrder\": 2, \"updatedAt\": \"2026-10-14T08:15:50.928849Z\", \"description\": \"Hương nếp tròn đầy, hậu vị êm.\"}, \"producer\": {\"id\": \"01M4WQPSQW8VKGA115SFH4B2M5\", \"name\": \"Làng nghề Bàu Đá Xứ Nẫu\", \"origin\": \"Nhơn Lộc, An Nhơn, Bình Định\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:51.036694Z\", \"updatedAt\": \"2026-10-14T08:15:51.036694Z\"}, \"seoTitle\": \"Nếp Lứt Xứ Nẫu | Rượu Xứ Nẫu\", \"variants\": [], \"createdAt\": \"2026-10-14T08:15:51.646721900Z\", \"updatedAt\": \"2026-10-14T08:15:51.646721900Z\", \"description\": \"Nếp Lứt Xứ Nẫu được xây dựng như một sản phẩm tiêu biểu của bộ sưu tập Xứ Nẫu, tôn trọng nguyên liệu địa phương, nhịp chưng cất chậm và tinh thần thưởng thức có trách nhiệm.\", \"seoDescription\": \"Dịu hơn dòng truyền thống, hương ngũ cốc rõ nét.\", \"shortDescription\": \"Dịu hơn dòng truyền thống, hương ngũ cốc rõ nét.\", \"storageInstructions\": \"Đậy kín, đặt nơi khô ráo, tránh ánh nắng trực tiếp và nguồn nhiệt.\"}','e0a12542134d48e2ab36c76567f24017','2026-10-14 01:15:51.661397'),('01M4WQPTBXJM453NNXV8Y2YVD5','01M4W68N231KS59HYAE86S9PGH','VARIANT_CREATED','PRODUCT_VARIANT','01M4WQPTBX3QYPFGTJA1MWE5NB',NULL,'{\"id\": \"01M4WQPTBX3QYPFGTJA1MWE5NB\", \"sku\": \"RXN-NLX-500\", \"price\": 275000, \"status\": \"ACTIVE\", \"version\": 0, \"volumeMl\": 500, \"createdAt\": \"2026-10-14T08:15:51.677284900Z\", \"productId\": \"01M4WQPTAYVK1CB5QCKGXA47PV\", \"updatedAt\": \"2026-10-14T08:15:51.677284900Z\", \"weightGram\": 950, \"alcoholPercent\": 35}','b6976f889d894b9e8f6e9bb328fe721c','2026-10-14 01:15:51.677285'),('01M4WQPTD2QY4CB0FX4ETFR1J7','01M4W68N231KS59HYAE86S9PGH','PRODUCT_IMAGE_ATTACHED','PRODUCT','01M4WQPTAYVK1CB5QCKGXA47PV',NULL,'{\"url\": \"https://cdn.baogialai.com.vn/images/60e08242b719152671f3736e312ec58c973e88f5d4851a5ab55ad760db8900fd4a05425ab90370a65d8ab075e0bcc262/241828.jpg\", \"altText\": \"Chum ủ rượu truyền thống\", \"mediaId\": \"01M4WQPSF80WS532EHBFGQ46K4\", \"primary\": true, \"sortOrder\": 0}','56e2394754a9421bb605c17dd78820b7','2026-10-14 01:15:51.714906'),('01M4WQPTE8Z87BXH7AHQM48DNE','01M4W68N231KS59HYAE86S9PGH','PRODUCT_CREATED','PRODUCT','01M4WQPTDX9VR2PM2ZZTVRJWRJ',NULL,'{\"id\": \"01M4WQPTDX9VR2PM2ZZTVRJWRJ\", \"name\": \"Men Lá An Lão\", \"slug\": \"men-la-an-lao\", \"images\": [], \"origin\": \"Bình Định, Việt Nam\", \"status\": \"ACTIVE\", \"version\": 0, \"category\": {\"id\": \"01M4WQPSKP2KC8C6ZWRJD2N8ZD\", \"name\": \"Rượu gạo\", \"slug\": \"ruou-gao\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:50.902719Z\", \"sortOrder\": 1, \"updatedAt\": \"2026-10-14T08:15:50.902719Z\", \"description\": \"Rượu chưng cất từ gạo tuyển chọn.\"}, \"producer\": {\"id\": \"01M4WQPSQW8VKGA115SFH4B2M5\", \"name\": \"Làng nghề Bàu Đá Xứ Nẫu\", \"origin\": \"Nhơn Lộc, An Nhơn, Bình Định\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:51.036694Z\", \"updatedAt\": \"2026-10-14T08:15:51.036694Z\"}, \"seoTitle\": \"Men Lá An Lão | Rượu Xứ Nẫu\", \"variants\": [], \"createdAt\": \"2026-10-14T08:15:51.741454900Z\", \"updatedAt\": \"2026-10-14T08:15:51.741454900Z\", \"description\": \"Men Lá An Lão được xây dựng như một sản phẩm tiêu biểu của bộ sưu tập Xứ Nẫu, tôn trọng nguyên liệu địa phương, nhịp chưng cất chậm và tinh thần thưởng thức có trách nhiệm.\", \"seoDescription\": \"Hương men lá mộc mạc, cân bằng và dễ thưởng thức.\", \"shortDescription\": \"Hương men lá mộc mạc, cân bằng và dễ thưởng thức.\", \"storageInstructions\": \"Đậy kín, đặt nơi khô ráo, tránh ánh nắng trực tiếp và nguồn nhiệt.\"}','73eabf0c8c304e97ab9a925c6b33b530','2026-10-14 01:15:51.752208'),('01M4WQPTF0T9Q5HMYYKXZ9B1X5','01M4W68N231KS59HYAE86S9PGH','VARIANT_CREATED','PRODUCT_VARIANT','01M4WQPTEGQRQRXZSB38NFQCPZ',NULL,'{\"id\": \"01M4WQPTEGQRQRXZSB38NFQCPZ\", \"sku\": \"RXN-MLA-500\", \"price\": 310000, \"status\": \"ACTIVE\", \"version\": 0, \"volumeMl\": 500, \"createdAt\": \"2026-10-14T08:15:51.760744300Z\", \"productId\": \"01M4WQPTDX9VR2PM2ZZTVRJWRJ\", \"updatedAt\": \"2026-10-14T08:15:51.760744300Z\", \"weightGram\": 950, \"alcoholPercent\": 38}','15ac8e99a47545178c95e6b203ecb950','2026-10-14 01:15:51.776265'),('01M4WQPTFW3FAM0RDCGP4JE42N','01M4W68N231KS59HYAE86S9PGH','PRODUCT_IMAGE_ATTACHED','PRODUCT','01M4WQPTDX9VR2PM2ZZTVRJWRJ',NULL,'{\"url\": \"https://images.baodantoc.vn/uploads/2021/Th%C3%A1ng_12/Ng%C3%A0y%201/TRUNG/R%C6%B0%E1%BB%A3u%20mem%20l%C3%A1/6%20-%20OK.jpg\", \"altText\": \"Chưng cất rượu men lá truyền thống\", \"mediaId\": \"01M4WQPSH7GKSSFNQPYJAA0X7J\", \"primary\": true, \"sortOrder\": 0}','a5402f538c38411d8c6cbff8461dd313','2026-10-14 01:15:51.804112'),('01M4WQPTGZ91ZMS4TZPEA8DQ6A','01M4W68N231KS59HYAE86S9PGH','PRODUCT_CREATED','PRODUCT','01M4WQPTGGSP912JDXMV009546',NULL,'{\"id\": \"01M4WQPTGGSP912JDXMV009546\", \"name\": \"Bàu Đá Tuyển Chọn\", \"slug\": \"bau-da-tuyen-chon\", \"images\": [], \"origin\": \"Bình Định, Việt Nam\", \"status\": \"ACTIVE\", \"version\": 0, \"category\": {\"id\": \"01M4WQPSKP2KC8C6ZWRJD2N8ZD\", \"name\": \"Rượu gạo\", \"slug\": \"ruou-gao\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:50.902719Z\", \"sortOrder\": 1, \"updatedAt\": \"2026-10-14T08:15:50.902719Z\", \"description\": \"Rượu chưng cất từ gạo tuyển chọn.\"}, \"producer\": {\"id\": \"01M4WQPSQW8VKGA115SFH4B2M5\", \"name\": \"Làng nghề Bàu Đá Xứ Nẫu\", \"origin\": \"Nhơn Lộc, An Nhơn, Bình Định\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:51.036694Z\", \"updatedAt\": \"2026-10-14T08:15:51.036694Z\"}, \"seoTitle\": \"Bàu Đá Tuyển Chọn | Rượu Xứ Nẫu\", \"variants\": [], \"createdAt\": \"2026-10-14T08:15:51.824252200Z\", \"updatedAt\": \"2026-10-14T08:15:51.824252200Z\", \"description\": \"Bàu Đá Tuyển Chọn được xây dựng như một sản phẩm tiêu biểu của bộ sưu tập Xứ Nẫu, tôn trọng nguyên liệu địa phương, nhịp chưng cất chậm và tinh thần thưởng thức có trách nhiệm.\", \"seoDescription\": \"Mẻ rượu tuyển chọn, đậm vị và kéo dài hậu ấm.\", \"shortDescription\": \"Mẻ rượu tuyển chọn, đậm vị và kéo dài hậu ấm.\", \"storageInstructions\": \"Đậy kín, đặt nơi khô ráo, tránh ánh nắng trực tiếp và nguồn nhiệt.\"}','2c5f28e23c614508a6942a1408224e59','2026-10-14 01:15:51.839272'),('01M4WQPTHF5JCR4SGSSSTBXAT0','01M4W68N231KS59HYAE86S9PGH','VARIANT_CREATED','PRODUCT_VARIANT','01M4WQPTHFT6T7BX7QFWTSKK93',NULL,'{\"id\": \"01M4WQPTHFT6T7BX7QFWTSKK93\", \"sku\": \"RXN-BTC-750\", \"price\": 480000, \"status\": \"ACTIVE\", \"version\": 0, \"volumeMl\": 750, \"createdAt\": \"2026-10-14T08:15:51.855113700Z\", \"productId\": \"01M4WQPTGGSP912JDXMV009546\", \"updatedAt\": \"2026-10-14T08:15:51.855113700Z\", \"weightGram\": 1200, \"alcoholPercent\": 50}','c86a55a636b7496e82a0bbdb0d18dece','2026-10-14 01:15:51.855114'),('01M4WQPTJASGATC9W2FYKZACEP','01M4W68N231KS59HYAE86S9PGH','PRODUCT_IMAGE_ATTACHED','PRODUCT','01M4WQPTGGSP912JDXMV009546',NULL,'{\"url\": \"https://peacetour.com.vn/Upload/Article/4bbf1697-0b66-4fff-ae45-e4309605b1d6/du-lich-quy-nhon-nau-ruou.jpeg\", \"altText\": \"Người thợ chưng cất rượu tại làng nghề\", \"mediaId\": \"01M4WQPSDRQ6R680M22DE9BH8R\", \"primary\": true, \"sortOrder\": 0}','a13db96f072a41709e428e7cd525ca50','2026-10-14 01:15:51.882848'),('01M4WQPTKRQ4WXG07D2S4G99BY','01M4W68N231KS59HYAE86S9PGH','PRODUCT_CREATED','PRODUCT','01M4WQPTKD9DRJYFZ64BYHM102',NULL,'{\"id\": \"01M4WQPTKD9DRJYFZ64BYHM102\", \"name\": \"Song Bình Đất Võ\", \"slug\": \"song-binh-dat-vo\", \"images\": [], \"origin\": \"Bình Định, Việt Nam\", \"status\": \"ACTIVE\", \"version\": 0, \"category\": {\"id\": \"01M4WQPSP4CNSP31A1XNZSQ1XE\", \"name\": \"Quà tặng\", \"slug\": \"qua-tang\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:50.980171Z\", \"sortOrder\": 4, \"updatedAt\": \"2026-10-14T08:15:50.980171Z\", \"description\": \"Bình và hộp quà mang dấu ấn Bình Định.\"}, \"producer\": {\"id\": \"01M4WQPSQW8VKGA115SFH4B2M5\", \"name\": \"Làng nghề Bàu Đá Xứ Nẫu\", \"origin\": \"Nhơn Lộc, An Nhơn, Bình Định\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:51.036694Z\", \"updatedAt\": \"2026-10-14T08:15:51.036694Z\"}, \"seoTitle\": \"Song Bình Đất Võ | Rượu Xứ Nẫu\", \"variants\": [], \"createdAt\": \"2026-10-14T08:15:51.917694Z\", \"updatedAt\": \"2026-10-14T08:15:51.917694Z\", \"description\": \"Song Bình Đất Võ được xây dựng như một sản phẩm tiêu biểu của bộ sưu tập Xứ Nẫu, tôn trọng nguyên liệu địa phương, nhịp chưng cất chậm và tinh thần thưởng thức có trách nhiệm.\", \"seoDescription\": \"Bộ quà hai bình dành cho dịp sum họp và tri ân.\", \"shortDescription\": \"Bộ quà hai bình dành cho dịp sum họp và tri ân.\", \"storageInstructions\": \"Đậy kín, đặt nơi khô ráo, tránh ánh nắng trực tiếp và nguồn nhiệt.\"}','048159b76ca74e2d8170157e259c047c','2026-10-14 01:15:51.928357'),('01M4WQPTM832ZDYQ7M8FGH5CBG','01M4W68N231KS59HYAE86S9PGH','VARIANT_CREATED','PRODUCT_VARIANT','01M4WQPTM8274PN3HAT1XY67Y6',NULL,'{\"id\": \"01M4WQPTM8274PN3HAT1XY67Y6\", \"sku\": \"RXN-SBD-1000\", \"price\": 850000, \"status\": \"ACTIVE\", \"version\": 0, \"volumeMl\": 1000, \"createdAt\": \"2026-10-14T08:15:51.944610300Z\", \"productId\": \"01M4WQPTKD9DRJYFZ64BYHM102\", \"updatedAt\": \"2026-10-14T08:15:51.944610300Z\", \"weightGram\": 1450, \"alcoholPercent\": 45}','903c91f194ef42da996c0ba35a4b29d2','2026-10-14 01:15:51.944610'),('01M4WQPTNDTBP3SZNYS2K9ZSKG','01M4W68N231KS59HYAE86S9PGH','PRODUCT_IMAGE_ATTACHED','PRODUCT','01M4WQPTKD9DRJYFZ64BYHM102',NULL,'{\"url\": \"https://media.vietnamplus.vn/images/7255a701687d11cb8c6bbc58a6c807854bcf0cd6242227383ff15377d77f3aabc72ac7da06810d9ace14e4cdbb15319ca74f6b1bfe70b3203772c7979020cefa/ruou_bau_da.jpg\", \"altText\": \"Người thợ giữ lửa lò rượu\", \"mediaId\": \"01M4WQPSG1YHXSAHXNTXFGWJN5\", \"primary\": true, \"sortOrder\": 0}','a156a36c0ac94dc8bda3e9f39a2fa1d1','2026-10-14 01:15:51.981825'),('01M4WQPTPQCD9DE9C2F8ZF8Y4G','01M4W68N231KS59HYAE86S9PGH','ARTICLE_CATEGORY_CREATED','ARTICLE_CATEGORY','01M4WQPTPQEF7EC3NFBRGPJ2PW',NULL,'{\"id\": \"01M4WQPTPQEF7EC3NFBRGPJ2PW\", \"name\": \"Làng nghề\", \"slug\": \"lang-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.023830600Z\", \"sortOrder\": 1, \"updatedAt\": \"2026-10-14T08:15:52.023830600Z\", \"description\": \"Con người và không gian làm nghề.\"}','a4c8cfc195e541ffa9dd6b4cbffb3e6f','2026-10-14 01:15:52.023831'),('01M4WQPTQQ3DFXP848A5C95X6Z','01M4W68N231KS59HYAE86S9PGH','ARTICLE_CATEGORY_CREATED','ARTICLE_CATEGORY','01M4WQPTQ8QJP32V0PRT4EAFAS',NULL,'{\"id\": \"01M4WQPTQ8QJP32V0PRT4EAFAS\", \"name\": \"Kỹ nghệ\", \"slug\": \"ky-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.040034500Z\", \"sortOrder\": 2, \"updatedAt\": \"2026-10-14T08:15:52.040034500Z\", \"description\": \"Quy trình, nguyên liệu và kinh nghiệm thủ công.\"}','3bae8c503c2f4f859131547c8ee609cc','2026-10-14 01:15:52.055897'),('01M4WQPTR77JRSPRQKV8D9W12X','01M4W68N231KS59HYAE86S9PGH','ARTICLE_CATEGORY_CREATED','ARTICLE_CATEGORY','01M4WQPTR77TS6NMYP56TJVC9X',NULL,'{\"id\": \"01M4WQPTR77TS6NMYP56TJVC9X\", \"name\": \"Thưởng thức\", \"slug\": \"thuong-thuc\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.071341500Z\", \"sortOrder\": 3, \"updatedAt\": \"2026-10-14T08:15:52.071341500Z\", \"description\": \"Cách cảm nhận và sử dụng có trách nhiệm.\"}','7b2e0b728f7042078147c8f5253be3de','2026-10-14 01:15:52.071342'),('01M4WQPTRS60F9MBCGGYF7GH0Q','01M4W68N231KS59HYAE86S9PGH','ARTICLE_CATEGORY_CREATED','ARTICLE_CATEGORY','01M4WQPTRSEVJKV0M3G1NFZC48',NULL,'{\"id\": \"01M4WQPTRSEVJKV0M3G1NFZC48\", \"name\": \"Văn hóa\", \"slug\": \"van-hoa\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.089462600Z\", \"sortOrder\": 4, \"updatedAt\": \"2026-10-14T08:15:52.089462600Z\", \"description\": \"Rượu trong đời sống văn hóa miền đất võ.\"}','0e233f560b1c4131b3e7f6db0c60ee50','2026-10-14 01:15:52.089463'),('01M4WQPTVPTX5BBZ08FB75S1MG','01M4W68N231KS59HYAE86S9PGH','ARTICLE_CREATED','ARTICLE','01M4WQPTVGQ6FXDG83ZGN31WV7',NULL,'{\"id\": \"01M4WQPTVGQ6FXDG83ZGN31WV7\", \"slug\": \"ngon-lua-khong-tat-o-lang-bau-da\", \"title\": \"Ngọn lửa không tắt ở làng Bàu Đá\", \"status\": \"DRAFT\", \"content\": \"Lửa trong lò không cần bùng lớn, nhưng phải đều và bền. Người thợ nhìn màu lửa, nghe tiếng sôi và điều chỉnh từng thanh củi để dòng rượu ra chậm, trong.\\n\\nỞ làng nghề, kinh nghiệm ấy được truyền bằng những buổi đứng bếp cùng nhau. Mỗi thế hệ thêm một cách làm sạch hơn, an toàn hơn nhưng vẫn giữ sự kiên nhẫn làm nên hương vị riêng.\", \"excerpt\": \"Theo chân người thợ gìn giữ nhịp lửa đều qua từng mẻ rượu.\", \"version\": 0, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTPQEF7EC3NFBRGPJ2PW\", \"name\": \"Làng nghề\", \"slug\": \"lang-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.023831Z\", \"sortOrder\": 1, \"updatedAt\": \"2026-10-14T08:15:52.023831Z\", \"description\": \"Con người và không gian làm nghề.\"}, \"seoTitle\": \"Ngọn lửa không tắt ở làng Bàu Đá | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.176655200Z\", \"updatedAt\": \"2026-10-14T08:15:52.176655200Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSG1YHXSAHXNTXFGWJN5\", \"url\": \"https://media.vietnamplus.vn/images/7255a701687d11cb8c6bbc58a6c807854bcf0cd6242227383ff15377d77f3aabc72ac7da06810d9ace14e4cdbb15319ca74f6b1bfe70b3203772c7979020cefa/ruou_bau_da.jpg\", \"altText\": \"Người thợ giữ lửa lò rượu\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.785566Z\"}, \"seoDescription\": \"Theo chân người thợ gìn giữ nhịp lửa đều qua từng mẻ rượu.\"}','be4e401ec22b450ba0ca859325e48fa3','2026-10-14 01:15:52.198458'),('01M4WQPTXPG0YEW9AKZN8NAYT9','01M4W68N231KS59HYAE86S9PGH','ARTICLE_SUBMITTED_FOR_REVIEW','ARTICLE','01M4WQPTVGQ6FXDG83ZGN31WV7','{\"id\": \"01M4WQPTVGQ6FXDG83ZGN31WV7\", \"slug\": \"ngon-lua-khong-tat-o-lang-bau-da\", \"title\": \"Ngọn lửa không tắt ở làng Bàu Đá\", \"status\": \"DRAFT\", \"content\": \"Lửa trong lò không cần bùng lớn, nhưng phải đều và bền. Người thợ nhìn màu lửa, nghe tiếng sôi và điều chỉnh từng thanh củi để dòng rượu ra chậm, trong.\\n\\nỞ làng nghề, kinh nghiệm ấy được truyền bằng những buổi đứng bếp cùng nhau. Mỗi thế hệ thêm một cách làm sạch hơn, an toàn hơn nhưng vẫn giữ sự kiên nhẫn làm nên hương vị riêng.\", \"excerpt\": \"Theo chân người thợ gìn giữ nhịp lửa đều qua từng mẻ rượu.\", \"version\": 0, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTPQEF7EC3NFBRGPJ2PW\", \"name\": \"Làng nghề\", \"slug\": \"lang-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.023831Z\", \"sortOrder\": 1, \"updatedAt\": \"2026-10-14T08:15:52.023831Z\", \"description\": \"Con người và không gian làm nghề.\"}, \"seoTitle\": \"Ngọn lửa không tắt ở làng Bàu Đá | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.176655Z\", \"updatedAt\": \"2026-10-14T08:15:52.176655Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSG1YHXSAHXNTXFGWJN5\", \"url\": \"https://media.vietnamplus.vn/images/7255a701687d11cb8c6bbc58a6c807854bcf0cd6242227383ff15377d77f3aabc72ac7da06810d9ace14e4cdbb15319ca74f6b1bfe70b3203772c7979020cefa/ruou_bau_da.jpg\", \"altText\": \"Người thợ giữ lửa lò rượu\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.785566Z\"}, \"seoDescription\": \"Theo chân người thợ gìn giữ nhịp lửa đều qua từng mẻ rượu.\"}','{\"id\": \"01M4WQPTVGQ6FXDG83ZGN31WV7\", \"slug\": \"ngon-lua-khong-tat-o-lang-bau-da\", \"title\": \"Ngọn lửa không tắt ở làng Bàu Đá\", \"status\": \"REVIEW\", \"content\": \"Lửa trong lò không cần bùng lớn, nhưng phải đều và bền. Người thợ nhìn màu lửa, nghe tiếng sôi và điều chỉnh từng thanh củi để dòng rượu ra chậm, trong.\\n\\nỞ làng nghề, kinh nghiệm ấy được truyền bằng những buổi đứng bếp cùng nhau. Mỗi thế hệ thêm một cách làm sạch hơn, an toàn hơn nhưng vẫn giữ sự kiên nhẫn làm nên hương vị riêng.\", \"excerpt\": \"Theo chân người thợ gìn giữ nhịp lửa đều qua từng mẻ rượu.\", \"version\": 0, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTPQEF7EC3NFBRGPJ2PW\", \"name\": \"Làng nghề\", \"slug\": \"lang-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.023831Z\", \"sortOrder\": 1, \"updatedAt\": \"2026-10-14T08:15:52.023831Z\", \"description\": \"Con người và không gian làm nghề.\"}, \"seoTitle\": \"Ngọn lửa không tắt ở làng Bàu Đá | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.176655Z\", \"updatedAt\": \"2026-10-14T08:15:52.230015800Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSG1YHXSAHXNTXFGWJN5\", \"url\": \"https://media.vietnamplus.vn/images/7255a701687d11cb8c6bbc58a6c807854bcf0cd6242227383ff15377d77f3aabc72ac7da06810d9ace14e4cdbb15319ca74f6b1bfe70b3203772c7979020cefa/ruou_bau_da.jpg\", \"altText\": \"Người thợ giữ lửa lò rượu\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.785566Z\"}, \"seoDescription\": \"Theo chân người thợ gìn giữ nhịp lửa đều qua từng mẻ rượu.\"}','d54c45925c944c0ba8a1a9f365bbc161','2026-10-14 01:15:52.246023'),('01M4WQPTZ4C0QQS513HYKN5DWN','01M4W68N231KS59HYAE86S9PGH','ARTICLE_PUBLISHED','ARTICLE','01M4WQPTVGQ6FXDG83ZGN31WV7','{\"id\": \"01M4WQPTVGQ6FXDG83ZGN31WV7\", \"slug\": \"ngon-lua-khong-tat-o-lang-bau-da\", \"title\": \"Ngọn lửa không tắt ở làng Bàu Đá\", \"status\": \"REVIEW\", \"content\": \"Lửa trong lò không cần bùng lớn, nhưng phải đều và bền. Người thợ nhìn màu lửa, nghe tiếng sôi và điều chỉnh từng thanh củi để dòng rượu ra chậm, trong.\\n\\nỞ làng nghề, kinh nghiệm ấy được truyền bằng những buổi đứng bếp cùng nhau. Mỗi thế hệ thêm một cách làm sạch hơn, an toàn hơn nhưng vẫn giữ sự kiên nhẫn làm nên hương vị riêng.\", \"excerpt\": \"Theo chân người thợ gìn giữ nhịp lửa đều qua từng mẻ rượu.\", \"version\": 1, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTPQEF7EC3NFBRGPJ2PW\", \"name\": \"Làng nghề\", \"slug\": \"lang-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.023831Z\", \"sortOrder\": 1, \"updatedAt\": \"2026-10-14T08:15:52.023831Z\", \"description\": \"Con người và không gian làm nghề.\"}, \"seoTitle\": \"Ngọn lửa không tắt ở làng Bàu Đá | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.176655Z\", \"updatedAt\": \"2026-10-14T08:15:52.230016Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSG1YHXSAHXNTXFGWJN5\", \"url\": \"https://media.vietnamplus.vn/images/7255a701687d11cb8c6bbc58a6c807854bcf0cd6242227383ff15377d77f3aabc72ac7da06810d9ace14e4cdbb15319ca74f6b1bfe70b3203772c7979020cefa/ruou_bau_da.jpg\", \"altText\": \"Người thợ giữ lửa lò rượu\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.785566Z\"}, \"seoDescription\": \"Theo chân người thợ gìn giữ nhịp lửa đều qua từng mẻ rượu.\"}','{\"id\": \"01M4WQPTVGQ6FXDG83ZGN31WV7\", \"slug\": \"ngon-lua-khong-tat-o-lang-bau-da\", \"title\": \"Ngọn lửa không tắt ở làng Bàu Đá\", \"status\": \"PUBLISHED\", \"content\": \"Lửa trong lò không cần bùng lớn, nhưng phải đều và bền. Người thợ nhìn màu lửa, nghe tiếng sôi và điều chỉnh từng thanh củi để dòng rượu ra chậm, trong.\\n\\nỞ làng nghề, kinh nghiệm ấy được truyền bằng những buổi đứng bếp cùng nhau. Mỗi thế hệ thêm một cách làm sạch hơn, an toàn hơn nhưng vẫn giữ sự kiên nhẫn làm nên hương vị riêng.\", \"excerpt\": \"Theo chân người thợ gìn giữ nhịp lửa đều qua từng mẻ rượu.\", \"version\": 1, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTPQEF7EC3NFBRGPJ2PW\", \"name\": \"Làng nghề\", \"slug\": \"lang-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.023831Z\", \"sortOrder\": 1, \"updatedAt\": \"2026-10-14T08:15:52.023831Z\", \"description\": \"Con người và không gian làm nghề.\"}, \"seoTitle\": \"Ngọn lửa không tắt ở làng Bàu Đá | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.176655Z\", \"updatedAt\": \"2026-10-14T08:15:52.288068500Z\", \"authorName\": \"Đặng Hoài Vũ\", \"publishedAt\": \"2026-10-14T08:15:52.288068500Z\", \"featuredMedia\": {\"id\": \"01M4WQPSG1YHXSAHXNTXFGWJN5\", \"url\": \"https://media.vietnamplus.vn/images/7255a701687d11cb8c6bbc58a6c807854bcf0cd6242227383ff15377d77f3aabc72ac7da06810d9ace14e4cdbb15319ca74f6b1bfe70b3203772c7979020cefa/ruou_bau_da.jpg\", \"altText\": \"Người thợ giữ lửa lò rượu\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.785566Z\"}, \"seoDescription\": \"Theo chân người thợ gìn giữ nhịp lửa đều qua từng mẻ rượu.\"}','1ca8815a4f9d45ee83f3e77098a8c018','2026-10-14 01:15:52.292096'),('01M4WQPV0A10TTT1GMXBT65D2T','01M4W68N231KS59HYAE86S9PGH','ARTICLE_CREATED','ARTICLE','01M4WQPTZXPCMS66QBSN7AKB0A',NULL,'{\"id\": \"01M4WQPTZXPCMS66QBSN7AKB0A\", \"slug\": \"tu-hat-gao-den-giot-ruou-trong\", \"title\": \"Từ hạt gạo đến giọt rượu trong\", \"status\": \"DRAFT\", \"content\": \"Gạo được chọn theo độ thơm, độ dẻo và sự đồng đều. Sau khi nấu chín, cơm được làm nguội đúng mức trước khi trộn men.\\n\\nQuá trình ủ tạo hương, còn chưng cất quyết định độ trong và sự cân bằng. Dòng đầu và dòng cuối được kiểm soát kỹ để phần rượu giữ lại có chất lượng ổn định.\", \"excerpt\": \"Bốn chặng chính tạo nên một mẻ rượu gạo thủ công.\", \"version\": 0, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTQ8QJP32V0PRT4EAFAS\", \"name\": \"Kỹ nghệ\", \"slug\": \"ky-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.040035Z\", \"sortOrder\": 2, \"updatedAt\": \"2026-10-14T08:15:52.040035Z\", \"description\": \"Quy trình, nguyên liệu và kinh nghiệm thủ công.\"}, \"seoTitle\": \"Từ hạt gạo đến giọt rượu trong | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.317412600Z\", \"updatedAt\": \"2026-10-14T08:15:52.317412600Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSEBJR0ZPEA9MKC93W33\", \"url\": \"https://cdn2.tuoitre.vn/thumb_w/1200/tto/i/s626/2009/06/21/r57uMZJy.jpg\", \"altText\": \"Bếp chưng cất rượu Bàu Đá\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.731352Z\"}, \"seoDescription\": \"Bốn chặng chính tạo nên một mẻ rượu gạo thủ công.\"}','96b6f5572146481d8fa330c3c39d4690','2026-10-14 01:15:52.330599'),('01M4WQPV1541P82JN7TB57SMVR','01M4W68N231KS59HYAE86S9PGH','ARTICLE_SUBMITTED_FOR_REVIEW','ARTICLE','01M4WQPTZXPCMS66QBSN7AKB0A','{\"id\": \"01M4WQPTZXPCMS66QBSN7AKB0A\", \"slug\": \"tu-hat-gao-den-giot-ruou-trong\", \"title\": \"Từ hạt gạo đến giọt rượu trong\", \"status\": \"DRAFT\", \"content\": \"Gạo được chọn theo độ thơm, độ dẻo và sự đồng đều. Sau khi nấu chín, cơm được làm nguội đúng mức trước khi trộn men.\\n\\nQuá trình ủ tạo hương, còn chưng cất quyết định độ trong và sự cân bằng. Dòng đầu và dòng cuối được kiểm soát kỹ để phần rượu giữ lại có chất lượng ổn định.\", \"excerpt\": \"Bốn chặng chính tạo nên một mẻ rượu gạo thủ công.\", \"version\": 0, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTQ8QJP32V0PRT4EAFAS\", \"name\": \"Kỹ nghệ\", \"slug\": \"ky-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.040035Z\", \"sortOrder\": 2, \"updatedAt\": \"2026-10-14T08:15:52.040035Z\", \"description\": \"Quy trình, nguyên liệu và kinh nghiệm thủ công.\"}, \"seoTitle\": \"Từ hạt gạo đến giọt rượu trong | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.317413Z\", \"updatedAt\": \"2026-10-14T08:15:52.317413Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSEBJR0ZPEA9MKC93W33\", \"url\": \"https://cdn2.tuoitre.vn/thumb_w/1200/tto/i/s626/2009/06/21/r57uMZJy.jpg\", \"altText\": \"Bếp chưng cất rượu Bàu Đá\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.731352Z\"}, \"seoDescription\": \"Bốn chặng chính tạo nên một mẻ rượu gạo thủ công.\"}','{\"id\": \"01M4WQPTZXPCMS66QBSN7AKB0A\", \"slug\": \"tu-hat-gao-den-giot-ruou-trong\", \"title\": \"Từ hạt gạo đến giọt rượu trong\", \"status\": \"REVIEW\", \"content\": \"Gạo được chọn theo độ thơm, độ dẻo và sự đồng đều. Sau khi nấu chín, cơm được làm nguội đúng mức trước khi trộn men.\\n\\nQuá trình ủ tạo hương, còn chưng cất quyết định độ trong và sự cân bằng. Dòng đầu và dòng cuối được kiểm soát kỹ để phần rượu giữ lại có chất lượng ổn định.\", \"excerpt\": \"Bốn chặng chính tạo nên một mẻ rượu gạo thủ công.\", \"version\": 0, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTQ8QJP32V0PRT4EAFAS\", \"name\": \"Kỹ nghệ\", \"slug\": \"ky-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.040035Z\", \"sortOrder\": 2, \"updatedAt\": \"2026-10-14T08:15:52.040035Z\", \"description\": \"Quy trình, nguyên liệu và kinh nghiệm thủ công.\"}, \"seoTitle\": \"Từ hạt gạo đến giọt rượu trong | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.317413Z\", \"updatedAt\": \"2026-10-14T08:15:52.357162600Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSEBJR0ZPEA9MKC93W33\", \"url\": \"https://cdn2.tuoitre.vn/thumb_w/1200/tto/i/s626/2009/06/21/r57uMZJy.jpg\", \"altText\": \"Bếp chưng cất rượu Bàu Đá\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.731352Z\"}, \"seoDescription\": \"Bốn chặng chính tạo nên một mẻ rượu gạo thủ công.\"}','3f63893a5ffa49ba987f979fdc446b38','2026-10-14 01:15:52.357163'),('01M4WQPV2GWWC0MXSBFX27M1CC','01M4W68N231KS59HYAE86S9PGH','ARTICLE_PUBLISHED','ARTICLE','01M4WQPTZXPCMS66QBSN7AKB0A','{\"id\": \"01M4WQPTZXPCMS66QBSN7AKB0A\", \"slug\": \"tu-hat-gao-den-giot-ruou-trong\", \"title\": \"Từ hạt gạo đến giọt rượu trong\", \"status\": \"REVIEW\", \"content\": \"Gạo được chọn theo độ thơm, độ dẻo và sự đồng đều. Sau khi nấu chín, cơm được làm nguội đúng mức trước khi trộn men.\\n\\nQuá trình ủ tạo hương, còn chưng cất quyết định độ trong và sự cân bằng. Dòng đầu và dòng cuối được kiểm soát kỹ để phần rượu giữ lại có chất lượng ổn định.\", \"excerpt\": \"Bốn chặng chính tạo nên một mẻ rượu gạo thủ công.\", \"version\": 1, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTQ8QJP32V0PRT4EAFAS\", \"name\": \"Kỹ nghệ\", \"slug\": \"ky-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.040035Z\", \"sortOrder\": 2, \"updatedAt\": \"2026-10-14T08:15:52.040035Z\", \"description\": \"Quy trình, nguyên liệu và kinh nghiệm thủ công.\"}, \"seoTitle\": \"Từ hạt gạo đến giọt rượu trong | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.317413Z\", \"updatedAt\": \"2026-10-14T08:15:52.357163Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSEBJR0ZPEA9MKC93W33\", \"url\": \"https://cdn2.tuoitre.vn/thumb_w/1200/tto/i/s626/2009/06/21/r57uMZJy.jpg\", \"altText\": \"Bếp chưng cất rượu Bàu Đá\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.731352Z\"}, \"seoDescription\": \"Bốn chặng chính tạo nên một mẻ rượu gạo thủ công.\"}','{\"id\": \"01M4WQPTZXPCMS66QBSN7AKB0A\", \"slug\": \"tu-hat-gao-den-giot-ruou-trong\", \"title\": \"Từ hạt gạo đến giọt rượu trong\", \"status\": \"PUBLISHED\", \"content\": \"Gạo được chọn theo độ thơm, độ dẻo và sự đồng đều. Sau khi nấu chín, cơm được làm nguội đúng mức trước khi trộn men.\\n\\nQuá trình ủ tạo hương, còn chưng cất quyết định độ trong và sự cân bằng. Dòng đầu và dòng cuối được kiểm soát kỹ để phần rượu giữ lại có chất lượng ổn định.\", \"excerpt\": \"Bốn chặng chính tạo nên một mẻ rượu gạo thủ công.\", \"version\": 1, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTQ8QJP32V0PRT4EAFAS\", \"name\": \"Kỹ nghệ\", \"slug\": \"ky-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.040035Z\", \"sortOrder\": 2, \"updatedAt\": \"2026-10-14T08:15:52.040035Z\", \"description\": \"Quy trình, nguyên liệu và kinh nghiệm thủ công.\"}, \"seoTitle\": \"Từ hạt gạo đến giọt rượu trong | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.317413Z\", \"updatedAt\": \"2026-10-14T08:15:52.390143500Z\", \"authorName\": \"Đặng Hoài Vũ\", \"publishedAt\": \"2026-10-14T08:15:52.390143500Z\", \"featuredMedia\": {\"id\": \"01M4WQPSEBJR0ZPEA9MKC93W33\", \"url\": \"https://cdn2.tuoitre.vn/thumb_w/1200/tto/i/s626/2009/06/21/r57uMZJy.jpg\", \"altText\": \"Bếp chưng cất rượu Bàu Đá\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.731352Z\"}, \"seoDescription\": \"Bốn chặng chính tạo nên một mẻ rượu gạo thủ công.\"}','9776ba211a4641df965ff080b9b9f512','2026-10-14 01:15:52.400911'),('01M4WQPV3XYG6VFB20EF58S3BA','01M4W68N231KS59HYAE86S9PGH','ARTICLE_CREATED','ARTICLE','01M4WQPV34ETTP8BHPPFR3992W',NULL,'{\"id\": \"01M4WQPV34ETTP8BHPPFR3992W\", \"slug\": \"nuoc-nguon-va-huong-vi-bau-da\", \"title\": \"Nước nguồn và hương vị Bàu Đá\", \"status\": \"DRAFT\", \"content\": \"Nước tham gia vào nhiều công đoạn, từ nấu cơm đến làm nguội hệ thống chưng cất. Độ khoáng và sự sạch của nước ảnh hưởng trực tiếp đến cảm nhận cuối cùng.\\n\\nNgày nay, người làm nghề kết hợp kinh nghiệm địa phương với kiểm soát chất lượng để bảo đảm mỗi mẻ rượu an toàn và nhất quán hơn.\", \"excerpt\": \"Vì sao nguồn nước luôn được nhắc đến khi kể về rượu Bàu Đá.\", \"version\": 0, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTQ8QJP32V0PRT4EAFAS\", \"name\": \"Kỹ nghệ\", \"slug\": \"ky-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.040035Z\", \"sortOrder\": 2, \"updatedAt\": \"2026-10-14T08:15:52.040035Z\", \"description\": \"Quy trình, nguyên liệu và kinh nghiệm thủ công.\"}, \"seoTitle\": \"Nước nguồn và hương vị Bàu Đá | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.420921200Z\", \"updatedAt\": \"2026-10-14T08:15:52.420921200Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSDRQ6R680M22DE9BH8R\", \"url\": \"https://peacetour.com.vn/Upload/Article/4bbf1697-0b66-4fff-ae45-e4309605b1d6/du-lich-quy-nhon-nau-ruou.jpeg\", \"altText\": \"Người thợ chưng cất rượu tại làng nghề\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.712161Z\"}, \"seoDescription\": \"Vì sao nguồn nước luôn được nhắc đến khi kể về rượu Bàu Đá.\"}','1e8e17762db44555923a2ffac9f3e716','2026-10-14 01:15:52.449234'),('01M4WQPV5H29RWMSZFZ8FCSR9R','01M4W68N231KS59HYAE86S9PGH','ARTICLE_SUBMITTED_FOR_REVIEW','ARTICLE','01M4WQPV34ETTP8BHPPFR3992W','{\"id\": \"01M4WQPV34ETTP8BHPPFR3992W\", \"slug\": \"nuoc-nguon-va-huong-vi-bau-da\", \"title\": \"Nước nguồn và hương vị Bàu Đá\", \"status\": \"DRAFT\", \"content\": \"Nước tham gia vào nhiều công đoạn, từ nấu cơm đến làm nguội hệ thống chưng cất. Độ khoáng và sự sạch của nước ảnh hưởng trực tiếp đến cảm nhận cuối cùng.\\n\\nNgày nay, người làm nghề kết hợp kinh nghiệm địa phương với kiểm soát chất lượng để bảo đảm mỗi mẻ rượu an toàn và nhất quán hơn.\", \"excerpt\": \"Vì sao nguồn nước luôn được nhắc đến khi kể về rượu Bàu Đá.\", \"version\": 0, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTQ8QJP32V0PRT4EAFAS\", \"name\": \"Kỹ nghệ\", \"slug\": \"ky-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.040035Z\", \"sortOrder\": 2, \"updatedAt\": \"2026-10-14T08:15:52.040035Z\", \"description\": \"Quy trình, nguyên liệu và kinh nghiệm thủ công.\"}, \"seoTitle\": \"Nước nguồn và hương vị Bàu Đá | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.420921Z\", \"updatedAt\": \"2026-10-14T08:15:52.420921Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSDRQ6R680M22DE9BH8R\", \"url\": \"https://peacetour.com.vn/Upload/Article/4bbf1697-0b66-4fff-ae45-e4309605b1d6/du-lich-quy-nhon-nau-ruou.jpeg\", \"altText\": \"Người thợ chưng cất rượu tại làng nghề\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.712161Z\"}, \"seoDescription\": \"Vì sao nguồn nước luôn được nhắc đến khi kể về rượu Bàu Đá.\"}','{\"id\": \"01M4WQPV34ETTP8BHPPFR3992W\", \"slug\": \"nuoc-nguon-va-huong-vi-bau-da\", \"title\": \"Nước nguồn và hương vị Bàu Đá\", \"status\": \"REVIEW\", \"content\": \"Nước tham gia vào nhiều công đoạn, từ nấu cơm đến làm nguội hệ thống chưng cất. Độ khoáng và sự sạch của nước ảnh hưởng trực tiếp đến cảm nhận cuối cùng.\\n\\nNgày nay, người làm nghề kết hợp kinh nghiệm địa phương với kiểm soát chất lượng để bảo đảm mỗi mẻ rượu an toàn và nhất quán hơn.\", \"excerpt\": \"Vì sao nguồn nước luôn được nhắc đến khi kể về rượu Bàu Đá.\", \"version\": 0, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTQ8QJP32V0PRT4EAFAS\", \"name\": \"Kỹ nghệ\", \"slug\": \"ky-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.040035Z\", \"sortOrder\": 2, \"updatedAt\": \"2026-10-14T08:15:52.040035Z\", \"description\": \"Quy trình, nguyên liệu và kinh nghiệm thủ công.\"}, \"seoTitle\": \"Nước nguồn và hương vị Bàu Đá | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.420921Z\", \"updatedAt\": \"2026-10-14T08:15:52.484297100Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSDRQ6R680M22DE9BH8R\", \"url\": \"https://peacetour.com.vn/Upload/Article/4bbf1697-0b66-4fff-ae45-e4309605b1d6/du-lich-quy-nhon-nau-ruou.jpeg\", \"altText\": \"Người thợ chưng cất rượu tại làng nghề\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.712161Z\"}, \"seoDescription\": \"Vì sao nguồn nước luôn được nhắc đến khi kể về rượu Bàu Đá.\"}','11d46684ea1c48aba037f315ddcb93d1','2026-10-14 01:15:52.497222'),('01M4WQPV7QMZVFPG2E41SJEE69','01M4W68N231KS59HYAE86S9PGH','ARTICLE_PUBLISHED','ARTICLE','01M4WQPV34ETTP8BHPPFR3992W','{\"id\": \"01M4WQPV34ETTP8BHPPFR3992W\", \"slug\": \"nuoc-nguon-va-huong-vi-bau-da\", \"title\": \"Nước nguồn và hương vị Bàu Đá\", \"status\": \"REVIEW\", \"content\": \"Nước tham gia vào nhiều công đoạn, từ nấu cơm đến làm nguội hệ thống chưng cất. Độ khoáng và sự sạch của nước ảnh hưởng trực tiếp đến cảm nhận cuối cùng.\\n\\nNgày nay, người làm nghề kết hợp kinh nghiệm địa phương với kiểm soát chất lượng để bảo đảm mỗi mẻ rượu an toàn và nhất quán hơn.\", \"excerpt\": \"Vì sao nguồn nước luôn được nhắc đến khi kể về rượu Bàu Đá.\", \"version\": 1, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTQ8QJP32V0PRT4EAFAS\", \"name\": \"Kỹ nghệ\", \"slug\": \"ky-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.040035Z\", \"sortOrder\": 2, \"updatedAt\": \"2026-10-14T08:15:52.040035Z\", \"description\": \"Quy trình, nguyên liệu và kinh nghiệm thủ công.\"}, \"seoTitle\": \"Nước nguồn và hương vị Bàu Đá | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.420921Z\", \"updatedAt\": \"2026-10-14T08:15:52.484297Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSDRQ6R680M22DE9BH8R\", \"url\": \"https://peacetour.com.vn/Upload/Article/4bbf1697-0b66-4fff-ae45-e4309605b1d6/du-lich-quy-nhon-nau-ruou.jpeg\", \"altText\": \"Người thợ chưng cất rượu tại làng nghề\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.712161Z\"}, \"seoDescription\": \"Vì sao nguồn nước luôn được nhắc đến khi kể về rượu Bàu Đá.\"}','{\"id\": \"01M4WQPV34ETTP8BHPPFR3992W\", \"slug\": \"nuoc-nguon-va-huong-vi-bau-da\", \"title\": \"Nước nguồn và hương vị Bàu Đá\", \"status\": \"PUBLISHED\", \"content\": \"Nước tham gia vào nhiều công đoạn, từ nấu cơm đến làm nguội hệ thống chưng cất. Độ khoáng và sự sạch của nước ảnh hưởng trực tiếp đến cảm nhận cuối cùng.\\n\\nNgày nay, người làm nghề kết hợp kinh nghiệm địa phương với kiểm soát chất lượng để bảo đảm mỗi mẻ rượu an toàn và nhất quán hơn.\", \"excerpt\": \"Vì sao nguồn nước luôn được nhắc đến khi kể về rượu Bàu Đá.\", \"version\": 1, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTQ8QJP32V0PRT4EAFAS\", \"name\": \"Kỹ nghệ\", \"slug\": \"ky-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.040035Z\", \"sortOrder\": 2, \"updatedAt\": \"2026-10-14T08:15:52.040035Z\", \"description\": \"Quy trình, nguyên liệu và kinh nghiệm thủ công.\"}, \"seoTitle\": \"Nước nguồn và hương vị Bàu Đá | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.420921Z\", \"updatedAt\": \"2026-10-14T08:15:52.560988500Z\", \"authorName\": \"Đặng Hoài Vũ\", \"publishedAt\": \"2026-10-14T08:15:52.560988500Z\", \"featuredMedia\": {\"id\": \"01M4WQPSDRQ6R680M22DE9BH8R\", \"url\": \"https://peacetour.com.vn/Upload/Article/4bbf1697-0b66-4fff-ae45-e4309605b1d6/du-lich-quy-nhon-nau-ruou.jpeg\", \"altText\": \"Người thợ chưng cất rượu tại làng nghề\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.712161Z\"}, \"seoDescription\": \"Vì sao nguồn nước luôn được nhắc đến khi kể về rượu Bàu Đá.\"}','52318dce2d434a4b8dc870ff911420d8','2026-10-14 01:15:52.567030'),('01M4WQPV927C4ADVW5VXGNJ1X0','01M4W68N231KS59HYAE86S9PGH','ARTICLE_CREATED','ARTICLE','01M4WQPV8JBFFJQXE3W6A5Y20J',NULL,'{\"id\": \"01M4WQPV8JBFFJQXE3W6A5Y20J\", \"slug\": \"nhip-u-men-qua-nhung-ngay-mua\", \"title\": \"Nhịp ủ men qua những ngày mưa\", \"status\": \"DRAFT\", \"content\": \"Men là phần sống động nhất của quy trình. Khi trời ẩm, thời gian và cách giữ nhiệt cần được điều chỉnh để cơm rượu chuyển hóa từ từ.\\n\\nKhông có một con số cứng cho mọi ngày. Sự ổn định đến từ việc ghi chép, quan sát và kiểm tra thay vì chỉ dựa vào thói quen.\", \"excerpt\": \"Nhiệt độ và độ ẩm thay đổi buộc người thợ lắng nghe mẻ ủ kỹ hơn.\", \"version\": 0, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTQ8QJP32V0PRT4EAFAS\", \"name\": \"Kỹ nghệ\", \"slug\": \"ky-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.040035Z\", \"sortOrder\": 2, \"updatedAt\": \"2026-10-14T08:15:52.040035Z\", \"description\": \"Quy trình, nguyên liệu và kinh nghiệm thủ công.\"}, \"seoTitle\": \"Nhịp ủ men qua những ngày mưa | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.594603300Z\", \"updatedAt\": \"2026-10-14T08:15:52.594603300Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSF80WS532EHBFGQ46K4\", \"url\": \"https://cdn.baogialai.com.vn/images/60e08242b719152671f3736e312ec58c973e88f5d4851a5ab55ad760db8900fd4a05425ab90370a65d8ab075e0bcc262/241828.jpg\", \"altText\": \"Chum ủ rượu truyền thống\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.760005Z\"}, \"seoDescription\": \"Nhiệt độ và độ ẩm thay đổi buộc người thợ lắng nghe mẻ ủ kỹ hơn.\"}','d93a4a3df3b94764a0dd8d269007b213','2026-10-14 01:15:52.610458'),('01M4WQPVA5MHM1D77MPMW3EQ2M','01M4W68N231KS59HYAE86S9PGH','ARTICLE_SUBMITTED_FOR_REVIEW','ARTICLE','01M4WQPV8JBFFJQXE3W6A5Y20J','{\"id\": \"01M4WQPV8JBFFJQXE3W6A5Y20J\", \"slug\": \"nhip-u-men-qua-nhung-ngay-mua\", \"title\": \"Nhịp ủ men qua những ngày mưa\", \"status\": \"DRAFT\", \"content\": \"Men là phần sống động nhất của quy trình. Khi trời ẩm, thời gian và cách giữ nhiệt cần được điều chỉnh để cơm rượu chuyển hóa từ từ.\\n\\nKhông có một con số cứng cho mọi ngày. Sự ổn định đến từ việc ghi chép, quan sát và kiểm tra thay vì chỉ dựa vào thói quen.\", \"excerpt\": \"Nhiệt độ và độ ẩm thay đổi buộc người thợ lắng nghe mẻ ủ kỹ hơn.\", \"version\": 0, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTQ8QJP32V0PRT4EAFAS\", \"name\": \"Kỹ nghệ\", \"slug\": \"ky-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.040035Z\", \"sortOrder\": 2, \"updatedAt\": \"2026-10-14T08:15:52.040035Z\", \"description\": \"Quy trình, nguyên liệu và kinh nghiệm thủ công.\"}, \"seoTitle\": \"Nhịp ủ men qua những ngày mưa | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.594603Z\", \"updatedAt\": \"2026-10-14T08:15:52.594603Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSF80WS532EHBFGQ46K4\", \"url\": \"https://cdn.baogialai.com.vn/images/60e08242b719152671f3736e312ec58c973e88f5d4851a5ab55ad760db8900fd4a05425ab90370a65d8ab075e0bcc262/241828.jpg\", \"altText\": \"Chum ủ rượu truyền thống\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.760005Z\"}, \"seoDescription\": \"Nhiệt độ và độ ẩm thay đổi buộc người thợ lắng nghe mẻ ủ kỹ hơn.\"}','{\"id\": \"01M4WQPV8JBFFJQXE3W6A5Y20J\", \"slug\": \"nhip-u-men-qua-nhung-ngay-mua\", \"title\": \"Nhịp ủ men qua những ngày mưa\", \"status\": \"REVIEW\", \"content\": \"Men là phần sống động nhất của quy trình. Khi trời ẩm, thời gian và cách giữ nhiệt cần được điều chỉnh để cơm rượu chuyển hóa từ từ.\\n\\nKhông có một con số cứng cho mọi ngày. Sự ổn định đến từ việc ghi chép, quan sát và kiểm tra thay vì chỉ dựa vào thói quen.\", \"excerpt\": \"Nhiệt độ và độ ẩm thay đổi buộc người thợ lắng nghe mẻ ủ kỹ hơn.\", \"version\": 0, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTQ8QJP32V0PRT4EAFAS\", \"name\": \"Kỹ nghệ\", \"slug\": \"ky-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.040035Z\", \"sortOrder\": 2, \"updatedAt\": \"2026-10-14T08:15:52.040035Z\", \"description\": \"Quy trình, nguyên liệu và kinh nghiệm thủ công.\"}, \"seoTitle\": \"Nhịp ủ men qua những ngày mưa | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.594603Z\", \"updatedAt\": \"2026-10-14T08:15:52.643906500Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSF80WS532EHBFGQ46K4\", \"url\": \"https://cdn.baogialai.com.vn/images/60e08242b719152671f3736e312ec58c973e88f5d4851a5ab55ad760db8900fd4a05425ab90370a65d8ab075e0bcc262/241828.jpg\", \"altText\": \"Chum ủ rượu truyền thống\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.760005Z\"}, \"seoDescription\": \"Nhiệt độ và độ ẩm thay đổi buộc người thợ lắng nghe mẻ ủ kỹ hơn.\"}','5dda6fe188c84e7f934682d98e0a04d1','2026-10-14 01:15:52.645920'),('01M4WQPVBJT3MN5RNW1RPS5PPW','01M4W68N231KS59HYAE86S9PGH','ARTICLE_PUBLISHED','ARTICLE','01M4WQPV8JBFFJQXE3W6A5Y20J','{\"id\": \"01M4WQPV8JBFFJQXE3W6A5Y20J\", \"slug\": \"nhip-u-men-qua-nhung-ngay-mua\", \"title\": \"Nhịp ủ men qua những ngày mưa\", \"status\": \"REVIEW\", \"content\": \"Men là phần sống động nhất của quy trình. Khi trời ẩm, thời gian và cách giữ nhiệt cần được điều chỉnh để cơm rượu chuyển hóa từ từ.\\n\\nKhông có một con số cứng cho mọi ngày. Sự ổn định đến từ việc ghi chép, quan sát và kiểm tra thay vì chỉ dựa vào thói quen.\", \"excerpt\": \"Nhiệt độ và độ ẩm thay đổi buộc người thợ lắng nghe mẻ ủ kỹ hơn.\", \"version\": 1, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTQ8QJP32V0PRT4EAFAS\", \"name\": \"Kỹ nghệ\", \"slug\": \"ky-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.040035Z\", \"sortOrder\": 2, \"updatedAt\": \"2026-10-14T08:15:52.040035Z\", \"description\": \"Quy trình, nguyên liệu và kinh nghiệm thủ công.\"}, \"seoTitle\": \"Nhịp ủ men qua những ngày mưa | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.594603Z\", \"updatedAt\": \"2026-10-14T08:15:52.643907Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSF80WS532EHBFGQ46K4\", \"url\": \"https://cdn.baogialai.com.vn/images/60e08242b719152671f3736e312ec58c973e88f5d4851a5ab55ad760db8900fd4a05425ab90370a65d8ab075e0bcc262/241828.jpg\", \"altText\": \"Chum ủ rượu truyền thống\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.760005Z\"}, \"seoDescription\": \"Nhiệt độ và độ ẩm thay đổi buộc người thợ lắng nghe mẻ ủ kỹ hơn.\"}','{\"id\": \"01M4WQPV8JBFFJQXE3W6A5Y20J\", \"slug\": \"nhip-u-men-qua-nhung-ngay-mua\", \"title\": \"Nhịp ủ men qua những ngày mưa\", \"status\": \"PUBLISHED\", \"content\": \"Men là phần sống động nhất của quy trình. Khi trời ẩm, thời gian và cách giữ nhiệt cần được điều chỉnh để cơm rượu chuyển hóa từ từ.\\n\\nKhông có một con số cứng cho mọi ngày. Sự ổn định đến từ việc ghi chép, quan sát và kiểm tra thay vì chỉ dựa vào thói quen.\", \"excerpt\": \"Nhiệt độ và độ ẩm thay đổi buộc người thợ lắng nghe mẻ ủ kỹ hơn.\", \"version\": 1, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTQ8QJP32V0PRT4EAFAS\", \"name\": \"Kỹ nghệ\", \"slug\": \"ky-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.040035Z\", \"sortOrder\": 2, \"updatedAt\": \"2026-10-14T08:15:52.040035Z\", \"description\": \"Quy trình, nguyên liệu và kinh nghiệm thủ công.\"}, \"seoTitle\": \"Nhịp ủ men qua những ngày mưa | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.594603Z\", \"updatedAt\": \"2026-10-14T08:15:52.683162300Z\", \"authorName\": \"Đặng Hoài Vũ\", \"publishedAt\": \"2026-10-14T08:15:52.683162300Z\", \"featuredMedia\": {\"id\": \"01M4WQPSF80WS532EHBFGQ46K4\", \"url\": \"https://cdn.baogialai.com.vn/images/60e08242b719152671f3736e312ec58c973e88f5d4851a5ab55ad760db8900fd4a05425ab90370a65d8ab075e0bcc262/241828.jpg\", \"altText\": \"Chum ủ rượu truyền thống\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.760005Z\"}, \"seoDescription\": \"Nhiệt độ và độ ẩm thay đổi buộc người thợ lắng nghe mẻ ủ kỹ hơn.\"}','c0e58476373e4ad8915f6bc843c28726','2026-10-14 01:15:52.690267'),('01M4WQPVCQPE27QEDBM2A1WC9E','01M4W68N231KS59HYAE86S9PGH','ARTICLE_CREATED','ARTICLE','01M4WQPVC9H7R0VWH2FAH9YNBV',NULL,'{\"id\": \"01M4WQPVC9H7R0VWH2FAH9YNBV\", \"slug\": \"mot-chen-ruou-trong-mam-com-xu-nau\", \"title\": \"Một chén rượu trong mâm cơm Xứ Nẫu\", \"status\": \"DRAFT\", \"content\": \"Trong những dịp gặp gỡ, chén rượu nhỏ mở đầu câu chuyện và thể hiện sự hiếu khách. Giá trị nằm ở khoảnh khắc quây quần, không nằm ở việc uống nhiều.\\n\\nThưởng thức có trách nhiệm là biết dừng đúng lúc, không mời người dưới 18 tuổi và tuyệt đối không lái xe sau khi uống.\", \"excerpt\": \"Rượu hiện diện như lời mời, sự sẻ chia và một giới hạn cần được tôn trọng.\", \"version\": 0, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTRSEVJKV0M3G1NFZC48\", \"name\": \"Văn hóa\", \"slug\": \"van-hoa\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.089463Z\", \"sortOrder\": 4, \"updatedAt\": \"2026-10-14T08:15:52.089463Z\", \"description\": \"Rượu trong đời sống văn hóa miền đất võ.\"}, \"seoTitle\": \"Một chén rượu trong mâm cơm Xứ Nẫu | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.713701800Z\", \"updatedAt\": \"2026-10-14T08:15:52.713701800Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSGQF4P948QMX685KJVZ\", \"url\": \"https://thanhnien.mediacdn.vn/uploaded/trongnth/2021_02_07/langnghe4_AKFB.jpg?width=500\", \"altText\": \"Làng nghề nấu rượu vào vụ Tết\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.807359Z\"}, \"seoDescription\": \"Rượu hiện diện như lời mời, sự sẻ chia và một giới hạn cần được tôn trọng.\"}','d3889916cedf41e4afddbf4dce5a54a0','2026-10-14 01:15:52.727532'),('01M4WQPVDRFN9YZPSNAZ0RQADX','01M4W68N231KS59HYAE86S9PGH','ARTICLE_SUBMITTED_FOR_REVIEW','ARTICLE','01M4WQPVC9H7R0VWH2FAH9YNBV','{\"id\": \"01M4WQPVC9H7R0VWH2FAH9YNBV\", \"slug\": \"mot-chen-ruou-trong-mam-com-xu-nau\", \"title\": \"Một chén rượu trong mâm cơm Xứ Nẫu\", \"status\": \"DRAFT\", \"content\": \"Trong những dịp gặp gỡ, chén rượu nhỏ mở đầu câu chuyện và thể hiện sự hiếu khách. Giá trị nằm ở khoảnh khắc quây quần, không nằm ở việc uống nhiều.\\n\\nThưởng thức có trách nhiệm là biết dừng đúng lúc, không mời người dưới 18 tuổi và tuyệt đối không lái xe sau khi uống.\", \"excerpt\": \"Rượu hiện diện như lời mời, sự sẻ chia và một giới hạn cần được tôn trọng.\", \"version\": 0, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTRSEVJKV0M3G1NFZC48\", \"name\": \"Văn hóa\", \"slug\": \"van-hoa\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.089463Z\", \"sortOrder\": 4, \"updatedAt\": \"2026-10-14T08:15:52.089463Z\", \"description\": \"Rượu trong đời sống văn hóa miền đất võ.\"}, \"seoTitle\": \"Một chén rượu trong mâm cơm Xứ Nẫu | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.713702Z\", \"updatedAt\": \"2026-10-14T08:15:52.713702Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSGQF4P948QMX685KJVZ\", \"url\": \"https://thanhnien.mediacdn.vn/uploaded/trongnth/2021_02_07/langnghe4_AKFB.jpg?width=500\", \"altText\": \"Làng nghề nấu rượu vào vụ Tết\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.807359Z\"}, \"seoDescription\": \"Rượu hiện diện như lời mời, sự sẻ chia và một giới hạn cần được tôn trọng.\"}','{\"id\": \"01M4WQPVC9H7R0VWH2FAH9YNBV\", \"slug\": \"mot-chen-ruou-trong-mam-com-xu-nau\", \"title\": \"Một chén rượu trong mâm cơm Xứ Nẫu\", \"status\": \"REVIEW\", \"content\": \"Trong những dịp gặp gỡ, chén rượu nhỏ mở đầu câu chuyện và thể hiện sự hiếu khách. Giá trị nằm ở khoảnh khắc quây quần, không nằm ở việc uống nhiều.\\n\\nThưởng thức có trách nhiệm là biết dừng đúng lúc, không mời người dưới 18 tuổi và tuyệt đối không lái xe sau khi uống.\", \"excerpt\": \"Rượu hiện diện như lời mời, sự sẻ chia và một giới hạn cần được tôn trọng.\", \"version\": 0, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTRSEVJKV0M3G1NFZC48\", \"name\": \"Văn hóa\", \"slug\": \"van-hoa\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.089463Z\", \"sortOrder\": 4, \"updatedAt\": \"2026-10-14T08:15:52.089463Z\", \"description\": \"Rượu trong đời sống văn hóa miền đất võ.\"}, \"seoTitle\": \"Một chén rượu trong mâm cơm Xứ Nẫu | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.713702Z\", \"updatedAt\": \"2026-10-14T08:15:52.757914400Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSGQF4P948QMX685KJVZ\", \"url\": \"https://thanhnien.mediacdn.vn/uploaded/trongnth/2021_02_07/langnghe4_AKFB.jpg?width=500\", \"altText\": \"Làng nghề nấu rượu vào vụ Tết\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.807359Z\"}, \"seoDescription\": \"Rượu hiện diện như lời mời, sự sẻ chia và một giới hạn cần được tôn trọng.\"}','da3f8b13eeb641fc99b0f19373fc494a','2026-10-14 01:15:52.761715'),('01M4WQPVESKN35RRCFMXTEFMW1','01M4W68N231KS59HYAE86S9PGH','ARTICLE_PUBLISHED','ARTICLE','01M4WQPVC9H7R0VWH2FAH9YNBV','{\"id\": \"01M4WQPVC9H7R0VWH2FAH9YNBV\", \"slug\": \"mot-chen-ruou-trong-mam-com-xu-nau\", \"title\": \"Một chén rượu trong mâm cơm Xứ Nẫu\", \"status\": \"REVIEW\", \"content\": \"Trong những dịp gặp gỡ, chén rượu nhỏ mở đầu câu chuyện và thể hiện sự hiếu khách. Giá trị nằm ở khoảnh khắc quây quần, không nằm ở việc uống nhiều.\\n\\nThưởng thức có trách nhiệm là biết dừng đúng lúc, không mời người dưới 18 tuổi và tuyệt đối không lái xe sau khi uống.\", \"excerpt\": \"Rượu hiện diện như lời mời, sự sẻ chia và một giới hạn cần được tôn trọng.\", \"version\": 1, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTRSEVJKV0M3G1NFZC48\", \"name\": \"Văn hóa\", \"slug\": \"van-hoa\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.089463Z\", \"sortOrder\": 4, \"updatedAt\": \"2026-10-14T08:15:52.089463Z\", \"description\": \"Rượu trong đời sống văn hóa miền đất võ.\"}, \"seoTitle\": \"Một chén rượu trong mâm cơm Xứ Nẫu | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.713702Z\", \"updatedAt\": \"2026-10-14T08:15:52.757914Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSGQF4P948QMX685KJVZ\", \"url\": \"https://thanhnien.mediacdn.vn/uploaded/trongnth/2021_02_07/langnghe4_AKFB.jpg?width=500\", \"altText\": \"Làng nghề nấu rượu vào vụ Tết\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.807359Z\"}, \"seoDescription\": \"Rượu hiện diện như lời mời, sự sẻ chia và một giới hạn cần được tôn trọng.\"}','{\"id\": \"01M4WQPVC9H7R0VWH2FAH9YNBV\", \"slug\": \"mot-chen-ruou-trong-mam-com-xu-nau\", \"title\": \"Một chén rượu trong mâm cơm Xứ Nẫu\", \"status\": \"PUBLISHED\", \"content\": \"Trong những dịp gặp gỡ, chén rượu nhỏ mở đầu câu chuyện và thể hiện sự hiếu khách. Giá trị nằm ở khoảnh khắc quây quần, không nằm ở việc uống nhiều.\\n\\nThưởng thức có trách nhiệm là biết dừng đúng lúc, không mời người dưới 18 tuổi và tuyệt đối không lái xe sau khi uống.\", \"excerpt\": \"Rượu hiện diện như lời mời, sự sẻ chia và một giới hạn cần được tôn trọng.\", \"version\": 1, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTRSEVJKV0M3G1NFZC48\", \"name\": \"Văn hóa\", \"slug\": \"van-hoa\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.089463Z\", \"sortOrder\": 4, \"updatedAt\": \"2026-10-14T08:15:52.089463Z\", \"description\": \"Rượu trong đời sống văn hóa miền đất võ.\"}, \"seoTitle\": \"Một chén rượu trong mâm cơm Xứ Nẫu | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.713702Z\", \"updatedAt\": \"2026-10-14T08:15:52.793037400Z\", \"authorName\": \"Đặng Hoài Vũ\", \"publishedAt\": \"2026-10-14T08:15:52.793037400Z\", \"featuredMedia\": {\"id\": \"01M4WQPSGQF4P948QMX685KJVZ\", \"url\": \"https://thanhnien.mediacdn.vn/uploaded/trongnth/2021_02_07/langnghe4_AKFB.jpg?width=500\", \"altText\": \"Làng nghề nấu rượu vào vụ Tết\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.807359Z\"}, \"seoDescription\": \"Rượu hiện diện như lời mời, sự sẻ chia và một giới hạn cần được tôn trọng.\"}','7be247923c6e4c3082cce2b46edb6aa7','2026-10-14 01:15:52.793037'),('01M4WQPVG1T0TKDYNG5V5QE2DK','01M4W68N231KS59HYAE86S9PGH','ARTICLE_CREATED','ARTICLE','01M4WQPVFKVQ42Q7JNMVWKDR0P',NULL,'{\"id\": \"01M4WQPVFKVQ42Q7JNMVWKDR0P\", \"slug\": \"chon-binh-ruou-lam-qua-mien-dat-vo\", \"title\": \"Chọn bình rượu làm quà miền đất võ\", \"status\": \"DRAFT\", \"content\": \"Một món quà đẹp bắt đầu từ sự phù hợp. Bình 500 ml gọn cho cuộc gặp thân tình, trong khi bộ song bình phù hợp dịp tri ân hoặc sum họp.\\n\\nNên giữ nhãn, thông tin nồng độ và nguồn gốc rõ ràng. Bao bì chắc chắn giúp món quà đến tay người nhận trọn vẹn.\", \"excerpt\": \"Gợi ý chọn dung tích, dáng bình và câu chuyện phù hợp người nhận.\", \"version\": 0, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTR77TS6NMYP56TJVC9X\", \"name\": \"Thưởng thức\", \"slug\": \"thuong-thuc\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.071342Z\", \"sortOrder\": 3, \"updatedAt\": \"2026-10-14T08:15:52.071342Z\", \"description\": \"Cách cảm nhận và sử dụng có trách nhiệm.\"}, \"seoTitle\": \"Chọn bình rượu làm quà miền đất võ | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.819358300Z\", \"updatedAt\": \"2026-10-14T08:15:52.819358300Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSBMAB4T74X3KD97HPW8\", \"url\": \"https://chonongsanonline.com/public/uploads/all/zbk2tUCek6Bl34hIDJXXVxrF9q3zjJGMGDaqXLYR.jpg\", \"altText\": \"Bộ sưu tập bình rượu Bàu Đá\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.644919Z\"}, \"seoDescription\": \"Gợi ý chọn dung tích, dáng bình và câu chuyện phù hợp người nhận.\"}','7837a1f769dc4c81a0393147376bde33','2026-10-14 01:15:52.835661'),('01M4WQPVGSW4GNKTZJKCV8JC8K','01M4W68N231KS59HYAE86S9PGH','ARTICLE_SUBMITTED_FOR_REVIEW','ARTICLE','01M4WQPVFKVQ42Q7JNMVWKDR0P','{\"id\": \"01M4WQPVFKVQ42Q7JNMVWKDR0P\", \"slug\": \"chon-binh-ruou-lam-qua-mien-dat-vo\", \"title\": \"Chọn bình rượu làm quà miền đất võ\", \"status\": \"DRAFT\", \"content\": \"Một món quà đẹp bắt đầu từ sự phù hợp. Bình 500 ml gọn cho cuộc gặp thân tình, trong khi bộ song bình phù hợp dịp tri ân hoặc sum họp.\\n\\nNên giữ nhãn, thông tin nồng độ và nguồn gốc rõ ràng. Bao bì chắc chắn giúp món quà đến tay người nhận trọn vẹn.\", \"excerpt\": \"Gợi ý chọn dung tích, dáng bình và câu chuyện phù hợp người nhận.\", \"version\": 0, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTR77TS6NMYP56TJVC9X\", \"name\": \"Thưởng thức\", \"slug\": \"thuong-thuc\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.071342Z\", \"sortOrder\": 3, \"updatedAt\": \"2026-10-14T08:15:52.071342Z\", \"description\": \"Cách cảm nhận và sử dụng có trách nhiệm.\"}, \"seoTitle\": \"Chọn bình rượu làm quà miền đất võ | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.819358Z\", \"updatedAt\": \"2026-10-14T08:15:52.819358Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSBMAB4T74X3KD97HPW8\", \"url\": \"https://chonongsanonline.com/public/uploads/all/zbk2tUCek6Bl34hIDJXXVxrF9q3zjJGMGDaqXLYR.jpg\", \"altText\": \"Bộ sưu tập bình rượu Bàu Đá\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.644919Z\"}, \"seoDescription\": \"Gợi ý chọn dung tích, dáng bình và câu chuyện phù hợp người nhận.\"}','{\"id\": \"01M4WQPVFKVQ42Q7JNMVWKDR0P\", \"slug\": \"chon-binh-ruou-lam-qua-mien-dat-vo\", \"title\": \"Chọn bình rượu làm quà miền đất võ\", \"status\": \"REVIEW\", \"content\": \"Một món quà đẹp bắt đầu từ sự phù hợp. Bình 500 ml gọn cho cuộc gặp thân tình, trong khi bộ song bình phù hợp dịp tri ân hoặc sum họp.\\n\\nNên giữ nhãn, thông tin nồng độ và nguồn gốc rõ ràng. Bao bì chắc chắn giúp món quà đến tay người nhận trọn vẹn.\", \"excerpt\": \"Gợi ý chọn dung tích, dáng bình và câu chuyện phù hợp người nhận.\", \"version\": 0, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTR77TS6NMYP56TJVC9X\", \"name\": \"Thưởng thức\", \"slug\": \"thuong-thuc\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.071342Z\", \"sortOrder\": 3, \"updatedAt\": \"2026-10-14T08:15:52.071342Z\", \"description\": \"Cách cảm nhận và sử dụng có trách nhiệm.\"}, \"seoTitle\": \"Chọn bình rượu làm quà miền đất võ | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.819358Z\", \"updatedAt\": \"2026-10-14T08:15:52.857102100Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSBMAB4T74X3KD97HPW8\", \"url\": \"https://chonongsanonline.com/public/uploads/all/zbk2tUCek6Bl34hIDJXXVxrF9q3zjJGMGDaqXLYR.jpg\", \"altText\": \"Bộ sưu tập bình rượu Bàu Đá\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.644919Z\"}, \"seoDescription\": \"Gợi ý chọn dung tích, dáng bình và câu chuyện phù hợp người nhận.\"}','d4d672c2cdbc458f932456771c828e53','2026-10-14 01:15:52.857102'),('01M4WQPVJ85R1DPZHTASY32WQM','01M4W68N231KS59HYAE86S9PGH','ARTICLE_PUBLISHED','ARTICLE','01M4WQPVFKVQ42Q7JNMVWKDR0P','{\"id\": \"01M4WQPVFKVQ42Q7JNMVWKDR0P\", \"slug\": \"chon-binh-ruou-lam-qua-mien-dat-vo\", \"title\": \"Chọn bình rượu làm quà miền đất võ\", \"status\": \"REVIEW\", \"content\": \"Một món quà đẹp bắt đầu từ sự phù hợp. Bình 500 ml gọn cho cuộc gặp thân tình, trong khi bộ song bình phù hợp dịp tri ân hoặc sum họp.\\n\\nNên giữ nhãn, thông tin nồng độ và nguồn gốc rõ ràng. Bao bì chắc chắn giúp món quà đến tay người nhận trọn vẹn.\", \"excerpt\": \"Gợi ý chọn dung tích, dáng bình và câu chuyện phù hợp người nhận.\", \"version\": 1, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTR77TS6NMYP56TJVC9X\", \"name\": \"Thưởng thức\", \"slug\": \"thuong-thuc\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.071342Z\", \"sortOrder\": 3, \"updatedAt\": \"2026-10-14T08:15:52.071342Z\", \"description\": \"Cách cảm nhận và sử dụng có trách nhiệm.\"}, \"seoTitle\": \"Chọn bình rượu làm quà miền đất võ | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.819358Z\", \"updatedAt\": \"2026-10-14T08:15:52.857102Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSBMAB4T74X3KD97HPW8\", \"url\": \"https://chonongsanonline.com/public/uploads/all/zbk2tUCek6Bl34hIDJXXVxrF9q3zjJGMGDaqXLYR.jpg\", \"altText\": \"Bộ sưu tập bình rượu Bàu Đá\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.644919Z\"}, \"seoDescription\": \"Gợi ý chọn dung tích, dáng bình và câu chuyện phù hợp người nhận.\"}','{\"id\": \"01M4WQPVFKVQ42Q7JNMVWKDR0P\", \"slug\": \"chon-binh-ruou-lam-qua-mien-dat-vo\", \"title\": \"Chọn bình rượu làm quà miền đất võ\", \"status\": \"PUBLISHED\", \"content\": \"Một món quà đẹp bắt đầu từ sự phù hợp. Bình 500 ml gọn cho cuộc gặp thân tình, trong khi bộ song bình phù hợp dịp tri ân hoặc sum họp.\\n\\nNên giữ nhãn, thông tin nồng độ và nguồn gốc rõ ràng. Bao bì chắc chắn giúp món quà đến tay người nhận trọn vẹn.\", \"excerpt\": \"Gợi ý chọn dung tích, dáng bình và câu chuyện phù hợp người nhận.\", \"version\": 1, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTR77TS6NMYP56TJVC9X\", \"name\": \"Thưởng thức\", \"slug\": \"thuong-thuc\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.071342Z\", \"sortOrder\": 3, \"updatedAt\": \"2026-10-14T08:15:52.071342Z\", \"description\": \"Cách cảm nhận và sử dụng có trách nhiệm.\"}, \"seoTitle\": \"Chọn bình rượu làm quà miền đất võ | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.819358Z\", \"updatedAt\": \"2026-10-14T08:15:52.901157900Z\", \"authorName\": \"Đặng Hoài Vũ\", \"publishedAt\": \"2026-10-14T08:15:52.901157900Z\", \"featuredMedia\": {\"id\": \"01M4WQPSBMAB4T74X3KD97HPW8\", \"url\": \"https://chonongsanonline.com/public/uploads/all/zbk2tUCek6Bl34hIDJXXVxrF9q3zjJGMGDaqXLYR.jpg\", \"altText\": \"Bộ sưu tập bình rượu Bàu Đá\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.644919Z\"}, \"seoDescription\": \"Gợi ý chọn dung tích, dáng bình và câu chuyện phù hợp người nhận.\"}','194b1783c2aa40eda88795ef1983c607','2026-10-14 01:15:52.904268'),('01M4WQPVJZ7W36ATTMAF5ZKDXK','01M4W68N231KS59HYAE86S9PGH','ARTICLE_CREATED','ARTICLE','01M4WQPVJZB55S68AEF1TKDFPV',NULL,'{\"id\": \"01M4WQPVJZB55S68AEF1TKDFPV\", \"slug\": \"cach-cam-nhan-ruou-gao-bang-ba-buoc\", \"title\": \"Cách cảm nhận rượu gạo bằng ba bước\", \"status\": \"DRAFT\", \"content\": \"Trước hết, quan sát độ trong dưới ánh sáng dịu. Tiếp theo, đưa chén lại gần để cảm nhận hương mà không cần hít quá sâu.\\n\\nCuối cùng, nhấp một lượng nhỏ và để ý sự chuyển đổi từ vị đầu đến hậu vị. Uống chậm, dùng cùng món ăn và luôn chuẩn bị phương án di chuyển an toàn.\", \"excerpt\": \"Nhìn độ trong, cảm hương và nhấp một lượng nhỏ để hiểu tính cách mỗi dòng.\", \"version\": 0, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTR77TS6NMYP56TJVC9X\", \"name\": \"Thưởng thức\", \"slug\": \"thuong-thuc\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.071342Z\", \"sortOrder\": 3, \"updatedAt\": \"2026-10-14T08:15:52.071342Z\", \"description\": \"Cách cảm nhận và sử dụng có trách nhiệm.\"}, \"seoTitle\": \"Cách cảm nhận rượu gạo bằng ba bước | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.927053600Z\", \"updatedAt\": \"2026-10-14T08:15:52.927053600Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSA7B6FR3VFK9X426PGC\", \"url\": \"https://www.chodulich.com.vn/images/2021/ruou-bau-da4.jpg\", \"altText\": \"Bình rượu Bàu Đá truyền thống\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.599236Z\"}, \"seoDescription\": \"Nhìn độ trong, cảm hương và nhấp một lượng nhỏ để hiểu tính cách mỗi dòng.\"}','4db09b2cbc884e3394a0ed83bf941f74','2026-10-14 01:15:52.927054'),('01M4WQPVM7C87T36WF04SZYWD3','01M4W68N231KS59HYAE86S9PGH','ARTICLE_SUBMITTED_FOR_REVIEW','ARTICLE','01M4WQPVJZB55S68AEF1TKDFPV','{\"id\": \"01M4WQPVJZB55S68AEF1TKDFPV\", \"slug\": \"cach-cam-nhan-ruou-gao-bang-ba-buoc\", \"title\": \"Cách cảm nhận rượu gạo bằng ba bước\", \"status\": \"DRAFT\", \"content\": \"Trước hết, quan sát độ trong dưới ánh sáng dịu. Tiếp theo, đưa chén lại gần để cảm nhận hương mà không cần hít quá sâu.\\n\\nCuối cùng, nhấp một lượng nhỏ và để ý sự chuyển đổi từ vị đầu đến hậu vị. Uống chậm, dùng cùng món ăn và luôn chuẩn bị phương án di chuyển an toàn.\", \"excerpt\": \"Nhìn độ trong, cảm hương và nhấp một lượng nhỏ để hiểu tính cách mỗi dòng.\", \"version\": 0, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTR77TS6NMYP56TJVC9X\", \"name\": \"Thưởng thức\", \"slug\": \"thuong-thuc\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.071342Z\", \"sortOrder\": 3, \"updatedAt\": \"2026-10-14T08:15:52.071342Z\", \"description\": \"Cách cảm nhận và sử dụng có trách nhiệm.\"}, \"seoTitle\": \"Cách cảm nhận rượu gạo bằng ba bước | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.927054Z\", \"updatedAt\": \"2026-10-14T08:15:52.927054Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSA7B6FR3VFK9X426PGC\", \"url\": \"https://www.chodulich.com.vn/images/2021/ruou-bau-da4.jpg\", \"altText\": \"Bình rượu Bàu Đá truyền thống\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.599236Z\"}, \"seoDescription\": \"Nhìn độ trong, cảm hương và nhấp một lượng nhỏ để hiểu tính cách mỗi dòng.\"}','{\"id\": \"01M4WQPVJZB55S68AEF1TKDFPV\", \"slug\": \"cach-cam-nhan-ruou-gao-bang-ba-buoc\", \"title\": \"Cách cảm nhận rượu gạo bằng ba bước\", \"status\": \"REVIEW\", \"content\": \"Trước hết, quan sát độ trong dưới ánh sáng dịu. Tiếp theo, đưa chén lại gần để cảm nhận hương mà không cần hít quá sâu.\\n\\nCuối cùng, nhấp một lượng nhỏ và để ý sự chuyển đổi từ vị đầu đến hậu vị. Uống chậm, dùng cùng món ăn và luôn chuẩn bị phương án di chuyển an toàn.\", \"excerpt\": \"Nhìn độ trong, cảm hương và nhấp một lượng nhỏ để hiểu tính cách mỗi dòng.\", \"version\": 0, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTR77TS6NMYP56TJVC9X\", \"name\": \"Thưởng thức\", \"slug\": \"thuong-thuc\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.071342Z\", \"sortOrder\": 3, \"updatedAt\": \"2026-10-14T08:15:52.071342Z\", \"description\": \"Cách cảm nhận và sử dụng có trách nhiệm.\"}, \"seoTitle\": \"Cách cảm nhận rượu gạo bằng ba bước | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.927054Z\", \"updatedAt\": \"2026-10-14T08:15:52.963962700Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSA7B6FR3VFK9X426PGC\", \"url\": \"https://www.chodulich.com.vn/images/2021/ruou-bau-da4.jpg\", \"altText\": \"Bình rượu Bàu Đá truyền thống\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.599236Z\"}, \"seoDescription\": \"Nhìn độ trong, cảm hương và nhấp một lượng nhỏ để hiểu tính cách mỗi dòng.\"}','0b57855f264640389b8c00517cedf417','2026-10-14 01:15:52.967992'),('01M4WQPVN8E55K9NGTXYCCPPJ9','01M4W68N231KS59HYAE86S9PGH','ARTICLE_PUBLISHED','ARTICLE','01M4WQPVJZB55S68AEF1TKDFPV','{\"id\": \"01M4WQPVJZB55S68AEF1TKDFPV\", \"slug\": \"cach-cam-nhan-ruou-gao-bang-ba-buoc\", \"title\": \"Cách cảm nhận rượu gạo bằng ba bước\", \"status\": \"REVIEW\", \"content\": \"Trước hết, quan sát độ trong dưới ánh sáng dịu. Tiếp theo, đưa chén lại gần để cảm nhận hương mà không cần hít quá sâu.\\n\\nCuối cùng, nhấp một lượng nhỏ và để ý sự chuyển đổi từ vị đầu đến hậu vị. Uống chậm, dùng cùng món ăn và luôn chuẩn bị phương án di chuyển an toàn.\", \"excerpt\": \"Nhìn độ trong, cảm hương và nhấp một lượng nhỏ để hiểu tính cách mỗi dòng.\", \"version\": 1, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTR77TS6NMYP56TJVC9X\", \"name\": \"Thưởng thức\", \"slug\": \"thuong-thuc\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.071342Z\", \"sortOrder\": 3, \"updatedAt\": \"2026-10-14T08:15:52.071342Z\", \"description\": \"Cách cảm nhận và sử dụng có trách nhiệm.\"}, \"seoTitle\": \"Cách cảm nhận rượu gạo bằng ba bước | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.927054Z\", \"updatedAt\": \"2026-10-14T08:15:52.963963Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSA7B6FR3VFK9X426PGC\", \"url\": \"https://www.chodulich.com.vn/images/2021/ruou-bau-da4.jpg\", \"altText\": \"Bình rượu Bàu Đá truyền thống\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.599236Z\"}, \"seoDescription\": \"Nhìn độ trong, cảm hương và nhấp một lượng nhỏ để hiểu tính cách mỗi dòng.\"}','{\"id\": \"01M4WQPVJZB55S68AEF1TKDFPV\", \"slug\": \"cach-cam-nhan-ruou-gao-bang-ba-buoc\", \"title\": \"Cách cảm nhận rượu gạo bằng ba bước\", \"status\": \"PUBLISHED\", \"content\": \"Trước hết, quan sát độ trong dưới ánh sáng dịu. Tiếp theo, đưa chén lại gần để cảm nhận hương mà không cần hít quá sâu.\\n\\nCuối cùng, nhấp một lượng nhỏ và để ý sự chuyển đổi từ vị đầu đến hậu vị. Uống chậm, dùng cùng món ăn và luôn chuẩn bị phương án di chuyển an toàn.\", \"excerpt\": \"Nhìn độ trong, cảm hương và nhấp một lượng nhỏ để hiểu tính cách mỗi dòng.\", \"version\": 1, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTR77TS6NMYP56TJVC9X\", \"name\": \"Thưởng thức\", \"slug\": \"thuong-thuc\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.071342Z\", \"sortOrder\": 3, \"updatedAt\": \"2026-10-14T08:15:52.071342Z\", \"description\": \"Cách cảm nhận và sử dụng có trách nhiệm.\"}, \"seoTitle\": \"Cách cảm nhận rượu gạo bằng ba bước | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:52.927054Z\", \"updatedAt\": \"2026-10-14T08:15:52.989797100Z\", \"authorName\": \"Đặng Hoài Vũ\", \"publishedAt\": \"2026-10-14T08:15:52.989797100Z\", \"featuredMedia\": {\"id\": \"01M4WQPSA7B6FR3VFK9X426PGC\", \"url\": \"https://www.chodulich.com.vn/images/2021/ruou-bau-da4.jpg\", \"altText\": \"Bình rượu Bàu Đá truyền thống\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.599236Z\"}, \"seoDescription\": \"Nhìn độ trong, cảm hương và nhấp một lượng nhỏ để hiểu tính cách mỗi dòng.\"}','eb1795495f8e4e0e92c247f0f51b65e5','2026-10-14 01:15:53.000665'),('01M4WQPVNXVEBK1ZYW48KK8XX3','01M4W68N231KS59HYAE86S9PGH','ARTICLE_CREATED','ARTICLE','01M4WQPVNX1KQNJQQ5VEX20T6A',NULL,'{\"id\": \"01M4WQPVNX1KQNJQQ5VEX20T6A\", \"slug\": \"nguoi-tre-ke-lai-chuyen-lang-nghe\", \"title\": \"Người trẻ kể lại chuyện làng nghề\", \"status\": \"DRAFT\", \"content\": \"Giữ nghề không có nghĩa là giữ nguyên mọi thứ. Người trẻ đưa hình ảnh, câu chuyện và thông tin sản phẩm lên môi trường số để khách hàng hiểu điều mình đang chọn.\\n\\nSự đổi mới có giá trị khi đi cùng minh bạch về nguyên liệu, nồng độ, nơi sản xuất và trách nhiệm với người dùng cuối.\", \"excerpt\": \"Thiết kế, nội dung số và truy xuất nguồn gốc đang tạo một cách tiếp cận mới.\", \"version\": 0, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTPQEF7EC3NFBRGPJ2PW\", \"name\": \"Làng nghề\", \"slug\": \"lang-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.023831Z\", \"sortOrder\": 1, \"updatedAt\": \"2026-10-14T08:15:52.023831Z\", \"description\": \"Con người và không gian làm nghề.\"}, \"seoTitle\": \"Người trẻ kể lại chuyện làng nghề | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:53.021570300Z\", \"updatedAt\": \"2026-10-14T08:15:53.021570300Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSC3HCYRX2NQVF0XAX7M\", \"url\": \"https://www.chodulich.cakhotranluan.com/images/2021/ruou-bau-da1.jpg\", \"altText\": \"Bình sứ họa tiết rồng xanh\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.659864Z\"}, \"seoDescription\": \"Thiết kế, nội dung số và truy xuất nguồn gốc đang tạo một cách tiếp cận mới.\"}','63179428ee8a4e33b09d10f73149c3aa','2026-10-14 01:15:53.021570'),('01M4WQPVPXFTKFG9282KBF57VZ','01M4W68N231KS59HYAE86S9PGH','ARTICLE_SUBMITTED_FOR_REVIEW','ARTICLE','01M4WQPVNX1KQNJQQ5VEX20T6A','{\"id\": \"01M4WQPVNX1KQNJQQ5VEX20T6A\", \"slug\": \"nguoi-tre-ke-lai-chuyen-lang-nghe\", \"title\": \"Người trẻ kể lại chuyện làng nghề\", \"status\": \"DRAFT\", \"content\": \"Giữ nghề không có nghĩa là giữ nguyên mọi thứ. Người trẻ đưa hình ảnh, câu chuyện và thông tin sản phẩm lên môi trường số để khách hàng hiểu điều mình đang chọn.\\n\\nSự đổi mới có giá trị khi đi cùng minh bạch về nguyên liệu, nồng độ, nơi sản xuất và trách nhiệm với người dùng cuối.\", \"excerpt\": \"Thiết kế, nội dung số và truy xuất nguồn gốc đang tạo một cách tiếp cận mới.\", \"version\": 0, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTPQEF7EC3NFBRGPJ2PW\", \"name\": \"Làng nghề\", \"slug\": \"lang-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.023831Z\", \"sortOrder\": 1, \"updatedAt\": \"2026-10-14T08:15:52.023831Z\", \"description\": \"Con người và không gian làm nghề.\"}, \"seoTitle\": \"Người trẻ kể lại chuyện làng nghề | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:53.021570Z\", \"updatedAt\": \"2026-10-14T08:15:53.021570Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSC3HCYRX2NQVF0XAX7M\", \"url\": \"https://www.chodulich.cakhotranluan.com/images/2021/ruou-bau-da1.jpg\", \"altText\": \"Bình sứ họa tiết rồng xanh\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.659864Z\"}, \"seoDescription\": \"Thiết kế, nội dung số và truy xuất nguồn gốc đang tạo một cách tiếp cận mới.\"}','{\"id\": \"01M4WQPVNX1KQNJQQ5VEX20T6A\", \"slug\": \"nguoi-tre-ke-lai-chuyen-lang-nghe\", \"title\": \"Người trẻ kể lại chuyện làng nghề\", \"status\": \"REVIEW\", \"content\": \"Giữ nghề không có nghĩa là giữ nguyên mọi thứ. Người trẻ đưa hình ảnh, câu chuyện và thông tin sản phẩm lên môi trường số để khách hàng hiểu điều mình đang chọn.\\n\\nSự đổi mới có giá trị khi đi cùng minh bạch về nguyên liệu, nồng độ, nơi sản xuất và trách nhiệm với người dùng cuối.\", \"excerpt\": \"Thiết kế, nội dung số và truy xuất nguồn gốc đang tạo một cách tiếp cận mới.\", \"version\": 0, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTPQEF7EC3NFBRGPJ2PW\", \"name\": \"Làng nghề\", \"slug\": \"lang-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.023831Z\", \"sortOrder\": 1, \"updatedAt\": \"2026-10-14T08:15:52.023831Z\", \"description\": \"Con người và không gian làm nghề.\"}, \"seoTitle\": \"Người trẻ kể lại chuyện làng nghề | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:53.021570Z\", \"updatedAt\": \"2026-10-14T08:15:53.053572300Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSC3HCYRX2NQVF0XAX7M\", \"url\": \"https://www.chodulich.cakhotranluan.com/images/2021/ruou-bau-da1.jpg\", \"altText\": \"Bình sứ họa tiết rồng xanh\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.659864Z\"}, \"seoDescription\": \"Thiết kế, nội dung số và truy xuất nguồn gốc đang tạo một cách tiếp cận mới.\"}','484fe2be16d345eaa11f07b96d84555f','2026-10-14 01:15:53.053572'),('01M4WQPVRA6TN4PG295YETEQMJ','01M4W68N231KS59HYAE86S9PGH','ARTICLE_PUBLISHED','ARTICLE','01M4WQPVNX1KQNJQQ5VEX20T6A','{\"id\": \"01M4WQPVNX1KQNJQQ5VEX20T6A\", \"slug\": \"nguoi-tre-ke-lai-chuyen-lang-nghe\", \"title\": \"Người trẻ kể lại chuyện làng nghề\", \"status\": \"REVIEW\", \"content\": \"Giữ nghề không có nghĩa là giữ nguyên mọi thứ. Người trẻ đưa hình ảnh, câu chuyện và thông tin sản phẩm lên môi trường số để khách hàng hiểu điều mình đang chọn.\\n\\nSự đổi mới có giá trị khi đi cùng minh bạch về nguyên liệu, nồng độ, nơi sản xuất và trách nhiệm với người dùng cuối.\", \"excerpt\": \"Thiết kế, nội dung số và truy xuất nguồn gốc đang tạo một cách tiếp cận mới.\", \"version\": 1, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTPQEF7EC3NFBRGPJ2PW\", \"name\": \"Làng nghề\", \"slug\": \"lang-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.023831Z\", \"sortOrder\": 1, \"updatedAt\": \"2026-10-14T08:15:52.023831Z\", \"description\": \"Con người và không gian làm nghề.\"}, \"seoTitle\": \"Người trẻ kể lại chuyện làng nghề | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:53.021570Z\", \"updatedAt\": \"2026-10-14T08:15:53.053572Z\", \"authorName\": \"Đặng Hoài Vũ\", \"featuredMedia\": {\"id\": \"01M4WQPSC3HCYRX2NQVF0XAX7M\", \"url\": \"https://www.chodulich.cakhotranluan.com/images/2021/ruou-bau-da1.jpg\", \"altText\": \"Bình sứ họa tiết rồng xanh\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.659864Z\"}, \"seoDescription\": \"Thiết kế, nội dung số và truy xuất nguồn gốc đang tạo một cách tiếp cận mới.\"}','{\"id\": \"01M4WQPVNX1KQNJQQ5VEX20T6A\", \"slug\": \"nguoi-tre-ke-lai-chuyen-lang-nghe\", \"title\": \"Người trẻ kể lại chuyện làng nghề\", \"status\": \"PUBLISHED\", \"content\": \"Giữ nghề không có nghĩa là giữ nguyên mọi thứ. Người trẻ đưa hình ảnh, câu chuyện và thông tin sản phẩm lên môi trường số để khách hàng hiểu điều mình đang chọn.\\n\\nSự đổi mới có giá trị khi đi cùng minh bạch về nguyên liệu, nồng độ, nơi sản xuất và trách nhiệm với người dùng cuối.\", \"excerpt\": \"Thiết kế, nội dung số và truy xuất nguồn gốc đang tạo một cách tiếp cận mới.\", \"version\": 1, \"authorId\": \"01M4W68N231KS59HYAE86S9PGH\", \"category\": {\"id\": \"01M4WQPTPQEF7EC3NFBRGPJ2PW\", \"name\": \"Làng nghề\", \"slug\": \"lang-nghe\", \"status\": \"ACTIVE\", \"version\": 0, \"createdAt\": \"2026-10-14T08:15:52.023831Z\", \"sortOrder\": 1, \"updatedAt\": \"2026-10-14T08:15:52.023831Z\", \"description\": \"Con người và không gian làm nghề.\"}, \"seoTitle\": \"Người trẻ kể lại chuyện làng nghề | Tạp chí Xứ Nẫu\", \"createdAt\": \"2026-10-14T08:15:53.021570Z\", \"updatedAt\": \"2026-10-14T08:15:53.094652900Z\", \"authorName\": \"Đặng Hoài Vũ\", \"publishedAt\": \"2026-10-14T08:15:53.094652900Z\", \"featuredMedia\": {\"id\": \"01M4WQPSC3HCYRX2NQVF0XAX7M\", \"url\": \"https://www.chodulich.cakhotranluan.com/images/2021/ruou-bau-da1.jpg\", \"altText\": \"Bình sứ họa tiết rồng xanh\", \"mimeType\": \"image/jpeg\", \"createdAt\": \"2026-10-14T08:15:50.659864Z\"}, \"seoDescription\": \"Thiết kế, nội dung số và truy xuất nguồn gốc đang tạo một cách tiếp cận mới.\"}','0fb89b26029845a4a41bbe284edcc418','2026-10-14 01:15:53.098687'),('01M4WQPVSYSMY0QCJ43J8RV2J4','01M4W68N231KS59HYAE86S9PGH','HERO_SLIDE_CREATED','HERO_SLIDE','01M4WQPVSYW35GTG6NTZAPYBHD',NULL,'{\"id\": \"01M4WQPVSYW35GTG6NTZAPYBHD\", \"title\": \"Giọt nồng kể chuyện quê\", \"status\": \"ACTIVE\", \"altText\": \"Người thợ chưng cất rượu tại làng nghề\", \"ctaPath\": \"/san-pham\", \"eyebrow\": \"Từ miền đất võ Bình Định\", \"version\": 0, \"ctaLabel\": \"Khám phá bộ sưu tập\", \"createdAt\": \"2026-10-14T08:15:53.150567Z\", \"sortOrder\": 1, \"updatedAt\": \"2026-10-14T08:15:53.150567Z\", \"description\": \"Một hành trình từ hạt gạo, nguồn nước và bàn tay người thợ.\", \"desktopMediaId\": \"01M4WQPSDRQ6R680M22DE9BH8R\", \"desktopImageUrl\": \"https://peacetour.com.vn/Upload/Article/4bbf1697-0b66-4fff-ae45-e4309605b1d6/du-lich-quy-nhon-nau-ruou.jpeg\"}','973073f58c734f658dfdb6dbd7b703b6','2026-10-14 01:15:53.150567'),('01M4WQPVTV7SQQBW8VJXH3F08P','01M4W68N231KS59HYAE86S9PGH','HERO_SLIDE_CREATED','HERO_SLIDE','01M4WQPVTG6EAR4QVMZ68RX679',NULL,'{\"id\": \"01M4WQPVTG6EAR4QVMZ68RX679\", \"title\": \"Giữ lửa một làng nghề\", \"status\": \"ACTIVE\", \"altText\": \"Người thợ giữ lửa lò rượu\", \"ctaPath\": \"/cau-chuyen\", \"eyebrow\": \"Kỹ nghệ qua nhiều thế hệ\", \"version\": 0, \"ctaLabel\": \"Đọc chuyện làng nghề\", \"createdAt\": \"2026-10-14T08:15:53.168245Z\", \"sortOrder\": 2, \"updatedAt\": \"2026-10-14T08:15:53.168245Z\", \"description\": \"Mỗi mẻ rượu là sự kiên nhẫn với nhiệt độ, thời gian và nguyên liệu.\", \"desktopMediaId\": \"01M4WQPSG1YHXSAHXNTXFGWJN5\", \"desktopImageUrl\": \"https://media.vietnamplus.vn/images/7255a701687d11cb8c6bbc58a6c807854bcf0cd6242227383ff15377d77f3aabc72ac7da06810d9ace14e4cdbb15319ca74f6b1bfe70b3203772c7979020cefa/ruou_bau_da.jpg\"}','31b406d8ebc94033b8082b3664b16130','2026-10-14 01:15:53.179502'),('01M4WQPVVBF98SGJC2CD0VRX30','01M4W68N231KS59HYAE86S9PGH','HERO_SLIDE_CREATED','HERO_SLIDE','01M4WQPVTV3VK0KVCCPBVB2BQD',NULL,'{\"id\": \"01M4WQPVTV3VK0KVCCPBVB2BQD\", \"title\": \"Hương vị cho ngày sum họp\", \"status\": \"ACTIVE\", \"altText\": \"Bình rượu Bàu Đá truyền thống\", \"ctaPath\": \"/san-pham?category=qua-tang\", \"eyebrow\": \"Quà từ Xứ Nẫu\", \"version\": 0, \"ctaLabel\": \"Xem quà tặng\", \"createdAt\": \"2026-10-14T08:15:53.179502Z\", \"sortOrder\": 3, \"updatedAt\": \"2026-10-14T08:15:53.179502Z\", \"description\": \"Chọn một bình rượu mang theo câu chuyện và dấu ấn miền đất võ.\", \"desktopMediaId\": \"01M4WQPSA7B6FR3VFK9X426PGC\", \"desktopImageUrl\": \"https://www.chodulich.com.vn/images/2021/ruou-bau-da4.jpg\"}','82395cf66e5d429e8f572311836449a2','2026-10-14 01:15:53.195310'),('01M4WQPVVV710MQBBH7FCGPHH6','01M4W68N231KS59HYAE86S9PGH','HERO_SLIDE_CREATED','HERO_SLIDE','01M4WQPVVRMTBSTJV2CD5DGCFZ',NULL,'{\"id\": \"01M4WQPVVRMTBSTJV2CD5DGCFZ\", \"title\": \"Trong từng giọt là thời gian\", \"status\": \"ACTIVE\", \"altText\": \"Bếp chưng cất rượu Bàu Đá\", \"ctaPath\": \"/cau-chuyen/tu-hat-gao-den-giot-ruou-trong\", \"eyebrow\": \"Chưng cất thủ công\", \"version\": 0, \"ctaLabel\": \"Xem quy trình\", \"createdAt\": \"2026-10-14T08:15:53.208080Z\", \"sortOrder\": 4, \"updatedAt\": \"2026-10-14T08:15:53.208080Z\", \"description\": \"Dòng rượu đi chậm để giữ lại sự trong trẻo và hậu vị ấm.\", \"desktopMediaId\": \"01M4WQPSEBJR0ZPEA9MKC93W33\", \"desktopImageUrl\": \"https://cdn2.tuoitre.vn/thumb_w/1200/tto/i/s626/2009/06/21/r57uMZJy.jpg\"}','0ddd6e1db9f4416aa31202fce436328d','2026-10-14 01:15:53.211340'),('01M4WQPVWVP39VYMYGCCNCVCC5','01M4W68N231KS59HYAE86S9PGH','PROCESS_STEP_CREATED','PROCESS_STEP','01M4WQPVWVVY05QEM6Z1Z0SGC8',NULL,'{\"id\": \"01M4WQPVWVVY05QEM6Z1Z0SGC8\", \"title\": \"Chọn gạo\", \"status\": \"ACTIVE\", \"altText\": \"Bình rượu Bàu Đá truyền thống\", \"mediaId\": \"01M4WQPSA7B6FR3VFK9X426PGC\", \"version\": 0, \"duration\": \"Chuẩn bị trong ngày\", \"imageUrl\": \"https://www.chodulich.com.vn/images/2021/ruou-bau-da4.jpg\", \"createdAt\": \"2026-10-14T08:15:53.243425Z\", \"sortOrder\": 1, \"updatedAt\": \"2026-10-14T08:15:53.243425Z\", \"longDescription\": \"Nguyên liệu được sàng lọc, làm sạch và định lượng cho từng mẻ để tạo nền hương ổn định.\", \"shortDescription\": \"Hạt gạo đều, thơm và có nguồn gốc rõ ràng.\"}','6667bd69b9f9401d86a0e0c0bc9034cc','2026-10-14 01:15:53.243425'),('01M4WQPVXMCSMGZ8JPHNJCSR37','01M4W68N231KS59HYAE86S9PGH','PROCESS_STEP_CREATED','PROCESS_STEP','01M4WQPVXMHKHXVA1DFDB4SWTE',NULL,'{\"id\": \"01M4WQPVXMHKHXVA1DFDB4SWTE\", \"title\": \"Ủ men\", \"status\": \"ACTIVE\", \"altText\": \"Chum ủ rượu truyền thống\", \"mediaId\": \"01M4WQPSF80WS532EHBFGQ46K4\", \"version\": 0, \"duration\": \"Khoảng 3–5 ngày\", \"imageUrl\": \"https://cdn.baogialai.com.vn/images/60e08242b719152671f3736e312ec58c973e88f5d4851a5ab55ad760db8900fd4a05425ab90370a65d8ab075e0bcc262/241828.jpg\", \"createdAt\": \"2026-10-14T08:15:53.268646Z\", \"sortOrder\": 2, \"updatedAt\": \"2026-10-14T08:15:53.268646Z\", \"longDescription\": \"Men được trộn khi cơm đã nguội đúng mức. Người thợ theo dõi mùi, độ ẩm và thời gian chuyển hóa.\", \"shortDescription\": \"Cơm rượu được giữ ở nhiệt độ và độ ẩm phù hợp.\"}','460a5bb94bc842eeb4889f37f413b1c5','2026-10-14 01:15:53.268646'),('01M4WQPVXVZXP8GPKA4VAGGA8Y','01M4W68N231KS59HYAE86S9PGH','PROCESS_STEP_CREATED','PROCESS_STEP','01M4WQPVXVRHTHPFM1F9V45W1Y',NULL,'{\"id\": \"01M4WQPVXVRHTHPFM1F9V45W1Y\", \"title\": \"Chưng cất\", \"status\": \"ACTIVE\", \"altText\": \"Bếp chưng cất rượu Bàu Đá\", \"mediaId\": \"01M4WQPSEBJR0ZPEA9MKC93W33\", \"version\": 0, \"duration\": \"Nhiều giờ liên tục\", \"imageUrl\": \"https://cdn2.tuoitre.vn/thumb_w/1200/tto/i/s626/2009/06/21/r57uMZJy.jpg\", \"createdAt\": \"2026-10-14T08:15:53.275007Z\", \"sortOrder\": 3, \"updatedAt\": \"2026-10-14T08:15:53.275007Z\", \"longDescription\": \"Hơi rượu đi qua hệ thống làm lạnh rồi ngưng tụ. Từng phần dòng rượu được kiểm soát để giữ chất lượng.\", \"shortDescription\": \"Lửa đều để dòng rượu ra chậm và trong.\"}','13dd8e9d9cac42959899e5afa558d7b8','2026-10-14 01:15:53.275007'),('01M4WQPVYTDT7E09PYEV228END','01M4W68N231KS59HYAE86S9PGH','PROCESS_STEP_CREATED','PROCESS_STEP','01M4WQPVYGX56P63N3G8P3YKFA',NULL,'{\"id\": \"01M4WQPVYGX56P63N3G8P3YKFA\", \"title\": \"Nghỉ rượu\", \"status\": \"ACTIVE\", \"altText\": \"Người thợ giữ lửa lò rượu\", \"mediaId\": \"01M4WQPSG1YHXSAHXNTXFGWJN5\", \"version\": 0, \"duration\": \"Tùy từng dòng rượu\", \"imageUrl\": \"https://media.vietnamplus.vn/images/7255a701687d11cb8c6bbc58a6c807854bcf0cd6242227383ff15377d77f3aabc72ac7da06810d9ace14e4cdbb15319ca74f6b1bfe70b3203772c7979020cefa/ruou_bau_da.jpg\", \"createdAt\": \"2026-10-14T08:15:53.296105Z\", \"sortOrder\": 4, \"updatedAt\": \"2026-10-14T08:15:53.296105Z\", \"longDescription\": \"Rượu sau chưng cất được để nghỉ trong điều kiện phù hợp, kiểm tra cảm quan và thông tin nồng độ trước khi hoàn thiện.\", \"shortDescription\": \"Hương vị ổn định trước khi đóng bình.\"}','d36750f272364d04a1ddba6b472dd974','2026-10-14 01:15:53.306514');
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
INSERT INTO `auth_rate_limits` VALUES ('00d7bdfcbfaa86bc337d479b7cf3820d4801671b20fe707b2af3c5b3a08eefc4','2026-10-13 20:40:08.684611',1,'2026-10-13 20:40:08.684611'),('1429ade8e457feaab350cc00c184f78bb7e0a5982c3329c7e66bb4d79cb63fe6','2026-10-14 01:20:12.963638',2,'2026-10-14 01:20:15.218594'),('6a4947204de50c8fd5e48fe6cf20a8d64a87996b37ae6456902ef484e76f0af1','2026-10-14 01:19:25.986780',1,'2026-10-14 01:19:25.986780');
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
INSERT INTO `categories` VALUES ('01M4WQPSKP2KC8C6ZWRJD2N8ZD','Rượu gạo','ruou-gao','Rượu chưng cất từ gạo tuyển chọn.','ACTIVE',1,0,'2026-10-14 01:15:50.902719','2026-10-14 01:15:50.902719',NULL),('01M4WQPSMGJJZV1S8B3ANMD0SW','Rượu nếp','ruou-nep','Hương nếp tròn đầy, hậu vị êm.','ACTIVE',2,0,'2026-10-14 01:15:50.928849','2026-10-14 01:15:50.928849',NULL),('01M4WQPSN005H6G8QTM096WD2S','Rượu đậu xanh','ruou-dau-xanh','Dòng rượu Bàu Đá phối nguyên liệu đậu xanh.','ACTIVE',3,0,'2026-10-14 01:15:50.944741','2026-10-14 01:15:50.944741',NULL),('01M4WQPSP4CNSP31A1XNZSQ1XE','Quà tặng','qua-tang','Bình và hộp quà mang dấu ấn Bình Định.','ACTIVE',4,0,'2026-10-14 01:15:50.980171','2026-10-14 01:15:50.980171',NULL);
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
INSERT INTO `flyway_schema_history` VALUES (1,'1','foundation','SQL','V1__foundation.sql',-2037950191,'root','2026-10-14 02:44:55',139,1),(2,'2','identity','SQL','V2__identity.sql',1814223636,'root','2026-10-14 02:44:55',460,1),(3,'3','identity recovery and rate limit','SQL','V3__identity_recovery_and_rate_limit.sql',-1547661160,'root','2026-10-14 02:55:07',133,1),(4,'4','catalog','SQL','V4__catalog.sql',-2062728440,'root','2026-10-14 03:38:22',370,1),(5,'5','media and cms','SQL','V5__media_and_cms.sql',1913391722,'root','2026-10-14 07:02:42',545,1),(6,'6','site content','SQL','V6__site_content.sql',-2090297371,'root','2026-10-14 08:03:42',231,1);
/*!40000 ALTER TABLE `flyway_schema_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hero_slides`
--

DROP TABLE IF EXISTS `hero_slides`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hero_slides` (
  `id` char(26) NOT NULL,
  `desktop_media_id` char(26) NOT NULL,
  `mobile_media_id` char(26) DEFAULT NULL,
  `alt_text` varchar(255) NOT NULL,
  `eyebrow` varchar(120) DEFAULT NULL,
  `title` varchar(220) NOT NULL,
  `description` varchar(600) DEFAULT NULL,
  `cta_label` varchar(80) DEFAULT NULL,
  `cta_path` varchar(255) DEFAULT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  `visible_from` timestamp(6) NULL DEFAULT NULL,
  `visible_until` timestamp(6) NULL DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `version` bigint NOT NULL DEFAULT '0',
  `created_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_hero_slides_public` (`status`,`visible_from`,`visible_until`,`deleted_at`,`sort_order`),
  KEY `fk_hero_desktop_media` (`desktop_media_id`),
  KEY `fk_hero_mobile_media` (`mobile_media_id`),
  CONSTRAINT `fk_hero_desktop_media` FOREIGN KEY (`desktop_media_id`) REFERENCES `media` (`id`),
  CONSTRAINT `fk_hero_mobile_media` FOREIGN KEY (`mobile_media_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hero_slides`
--

LOCK TABLES `hero_slides` WRITE;
/*!40000 ALTER TABLE `hero_slides` DISABLE KEYS */;
INSERT INTO `hero_slides` VALUES ('01M4WQPVSYW35GTG6NTZAPYBHD','01M4WQPSDRQ6R680M22DE9BH8R',NULL,'Người thợ chưng cất rượu tại làng nghề','Từ miền đất võ Bình Định','Giọt nồng kể chuyện quê','Một hành trình từ hạt gạo, nguồn nước và bàn tay người thợ.','Khám phá bộ sưu tập','/san-pham',1,NULL,NULL,'ACTIVE',0,'2026-10-14 01:15:53.150567','2026-10-14 01:15:53.150567',NULL),('01M4WQPVTG6EAR4QVMZ68RX679','01M4WQPSG1YHXSAHXNTXFGWJN5',NULL,'Người thợ giữ lửa lò rượu','Kỹ nghệ qua nhiều thế hệ','Giữ lửa một làng nghề','Mỗi mẻ rượu là sự kiên nhẫn với nhiệt độ, thời gian và nguyên liệu.','Đọc chuyện làng nghề','/cau-chuyen',2,NULL,NULL,'ACTIVE',0,'2026-10-14 01:15:53.168245','2026-10-14 01:15:53.168245',NULL),('01M4WQPVTV3VK0KVCCPBVB2BQD','01M4WQPSA7B6FR3VFK9X426PGC',NULL,'Bình rượu Bàu Đá truyền thống','Quà từ Xứ Nẫu','Hương vị cho ngày sum họp','Chọn một bình rượu mang theo câu chuyện và dấu ấn miền đất võ.','Xem quà tặng','/san-pham?category=qua-tang',3,NULL,NULL,'ACTIVE',0,'2026-10-14 01:15:53.179502','2026-10-14 01:15:53.179502',NULL),('01M4WQPVVRMTBSTJV2CD5DGCFZ','01M4WQPSEBJR0ZPEA9MKC93W33',NULL,'Bếp chưng cất rượu Bàu Đá','Chưng cất thủ công','Trong từng giọt là thời gian','Dòng rượu đi chậm để giữ lại sự trong trẻo và hậu vị ấm.','Xem quy trình','/cau-chuyen/tu-hat-gao-den-giot-ruou-trong',4,NULL,NULL,'ACTIVE',0,'2026-10-14 01:15:53.208080','2026-10-14 01:15:53.208080',NULL);
/*!40000 ALTER TABLE `hero_slides` ENABLE KEYS */;
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
INSERT INTO `media` VALUES ('01M4WQPSA7B6FR3VFK9X426PGC','https://www.chodulich.com.vn/images/2021/ruou-bau-da4.jpg',NULL,'image/jpeg',NULL,NULL,'Bình rượu Bàu Đá truyền thống',NULL,'2026-10-14 01:15:50.599236'),('01M4WQPSBMAB4T74X3KD97HPW8','https://chonongsanonline.com/public/uploads/all/zbk2tUCek6Bl34hIDJXXVxrF9q3zjJGMGDaqXLYR.jpg',NULL,'image/jpeg',NULL,NULL,'Bộ sưu tập bình rượu Bàu Đá',NULL,'2026-10-14 01:15:50.644919'),('01M4WQPSC3HCYRX2NQVF0XAX7M','https://www.chodulich.cakhotranluan.com/images/2021/ruou-bau-da1.jpg',NULL,'image/jpeg',NULL,NULL,'Bình sứ họa tiết rồng xanh',NULL,'2026-10-14 01:15:50.659864'),('01M4WQPSD3NNQRQB14APPJK29C','https://www.chodulich.cakhotranluan.com/images/2021/ruou-bau-da.jpg',NULL,'image/jpeg',NULL,NULL,'Bình rượu Bàu Đá dáng bầu',NULL,'2026-10-14 01:15:50.691870'),('01M4WQPSDRQ6R680M22DE9BH8R','https://peacetour.com.vn/Upload/Article/4bbf1697-0b66-4fff-ae45-e4309605b1d6/du-lich-quy-nhon-nau-ruou.jpeg',NULL,'image/jpeg',NULL,NULL,'Người thợ chưng cất rượu tại làng nghề',NULL,'2026-10-14 01:15:50.712161'),('01M4WQPSEBJR0ZPEA9MKC93W33','https://cdn2.tuoitre.vn/thumb_w/1200/tto/i/s626/2009/06/21/r57uMZJy.jpg',NULL,'image/jpeg',NULL,NULL,'Bếp chưng cất rượu Bàu Đá',NULL,'2026-10-14 01:15:50.731352'),('01M4WQPSF80WS532EHBFGQ46K4','https://cdn.baogialai.com.vn/images/60e08242b719152671f3736e312ec58c973e88f5d4851a5ab55ad760db8900fd4a05425ab90370a65d8ab075e0bcc262/241828.jpg',NULL,'image/jpeg',NULL,NULL,'Chum ủ rượu truyền thống',NULL,'2026-10-14 01:15:50.760005'),('01M4WQPSG1YHXSAHXNTXFGWJN5','https://media.vietnamplus.vn/images/7255a701687d11cb8c6bbc58a6c807854bcf0cd6242227383ff15377d77f3aabc72ac7da06810d9ace14e4cdbb15319ca74f6b1bfe70b3203772c7979020cefa/ruou_bau_da.jpg',NULL,'image/jpeg',NULL,NULL,'Người thợ giữ lửa lò rượu',NULL,'2026-10-14 01:15:50.785566'),('01M4WQPSGQF4P948QMX685KJVZ','https://thanhnien.mediacdn.vn/uploaded/trongnth/2021_02_07/langnghe4_AKFB.jpg?width=500',NULL,'image/jpeg',NULL,NULL,'Làng nghề nấu rượu vào vụ Tết',NULL,'2026-10-14 01:15:50.807359'),('01M4WQPSH7GKSSFNQPYJAA0X7J','https://images.baodantoc.vn/uploads/2021/Th%C3%A1ng_12/Ng%C3%A0y%201/TRUNG/R%C6%B0%E1%BB%A3u%20mem%20l%C3%A1/6%20-%20OK.jpg',NULL,'image/jpeg',NULL,NULL,'Chưng cất rượu men lá truyền thống',NULL,'2026-10-14 01:15:50.823524');
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
INSERT INTO `permissions` VALUES ('10000000000000000000000001','ADMIN_ACCESS','Truy cập khu vực quản trị'),('10000000000000000000000002','USER_MANAGE','Quản lý tài khoản và phân quyền'),('10000000000000000000000003','CATALOG_MANAGE','Quản lý danh mục và sản phẩm'),('10000000000000000000000004','INVENTORY_MANAGE','Quản lý kho'),('10000000000000000000000005','ORDER_MANAGE','Quản lý đơn hàng'),('10000000000000000000000006','PAYMENT_RECONCILE','Đối soát thanh toán'),('10000000000000000000000007','PAYMENT_REFUND','Hoàn tiền'),('10000000000000000000000008','ARTICLE_MANAGE','Quản lý và xuất bản bài viết'),('10000000000000000000000009','AUDIT_READ','Xem nhật ký kiểm toán'),('10000000000000000000000010','SITE_CONTENT_MANAGE','Quản lý nội dung và cấu hình công khai của website');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `process_steps`
--

DROP TABLE IF EXISTS `process_steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `process_steps` (
  `id` char(26) NOT NULL,
  `media_id` char(26) DEFAULT NULL,
  `title` varchar(160) NOT NULL,
  `short_description` varchar(300) NOT NULL,
  `long_description` text NOT NULL,
  `duration_label` varchar(120) DEFAULT NULL,
  `alt_text` varchar(255) DEFAULT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  `status` varchar(20) NOT NULL,
  `version` bigint NOT NULL DEFAULT '0',
  `created_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` timestamp(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_process_steps_public` (`status`,`deleted_at`,`sort_order`),
  KEY `fk_process_step_media` (`media_id`),
  CONSTRAINT `fk_process_step_media` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `process_steps`
--

LOCK TABLES `process_steps` WRITE;
/*!40000 ALTER TABLE `process_steps` DISABLE KEYS */;
INSERT INTO `process_steps` VALUES ('01M4WQPVWVVY05QEM6Z1Z0SGC8','01M4WQPSA7B6FR3VFK9X426PGC','Chọn gạo','Hạt gạo đều, thơm và có nguồn gốc rõ ràng.','Nguyên liệu được sàng lọc, làm sạch và định lượng cho từng mẻ để tạo nền hương ổn định.','Chuẩn bị trong ngày','Bình rượu Bàu Đá truyền thống',1,'ACTIVE',0,'2026-10-14 01:15:53.243425','2026-10-14 01:15:53.243425',NULL),('01M4WQPVXMHKHXVA1DFDB4SWTE','01M4WQPSF80WS532EHBFGQ46K4','Ủ men','Cơm rượu được giữ ở nhiệt độ và độ ẩm phù hợp.','Men được trộn khi cơm đã nguội đúng mức. Người thợ theo dõi mùi, độ ẩm và thời gian chuyển hóa.','Khoảng 3–5 ngày','Chum ủ rượu truyền thống',2,'ACTIVE',0,'2026-10-14 01:15:53.268646','2026-10-14 01:15:53.268646',NULL),('01M4WQPVXVRHTHPFM1F9V45W1Y','01M4WQPSEBJR0ZPEA9MKC93W33','Chưng cất','Lửa đều để dòng rượu ra chậm và trong.','Hơi rượu đi qua hệ thống làm lạnh rồi ngưng tụ. Từng phần dòng rượu được kiểm soát để giữ chất lượng.','Nhiều giờ liên tục','Bếp chưng cất rượu Bàu Đá',3,'ACTIVE',0,'2026-10-14 01:15:53.275007','2026-10-14 01:15:53.275007',NULL),('01M4WQPVYGX56P63N3G8P3YKFA','01M4WQPSG1YHXSAHXNTXFGWJN5','Nghỉ rượu','Hương vị ổn định trước khi đóng bình.','Rượu sau chưng cất được để nghỉ trong điều kiện phù hợp, kiểm tra cảm quan và thông tin nồng độ trước khi hoàn thiện.','Tùy từng dòng rượu','Người thợ giữ lửa lò rượu',4,'ACTIVE',0,'2026-10-14 01:15:53.296105','2026-10-14 01:15:53.296105',NULL);
/*!40000 ALTER TABLE `process_steps` ENABLE KEYS */;
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
INSERT INTO `producers` VALUES ('01M4WQPSQW8VKGA115SFH4B2M5','Làng nghề Bàu Đá Xứ Nẫu',NULL,'Nhơn Lộc, An Nhơn, Bình Định',NULL,'ACTIVE',0,'2026-10-14 01:15:51.036694','2026-10-14 01:15:51.036694',NULL);
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
INSERT INTO `product_images` VALUES ('01M4WQPSTHCBPBSHGJJ9SJVFRW','01M4WQPSA7B6FR3VFK9X426PGC',0,1),('01M4WQPT1ZSYTDWBQKSGKTAG61','01M4WQPSBMAB4T74X3KD97HPW8',0,1),('01M4WQPT57GMPKCZ6W0Q32RGMC','01M4WQPSC3HCYRX2NQVF0XAX7M',0,1),('01M4WQPT7Y9YG21RJEN6BD3NVV','01M4WQPSD3NNQRQB14APPJK29C',0,1),('01M4WQPTAYVK1CB5QCKGXA47PV','01M4WQPSF80WS532EHBFGQ46K4',0,1),('01M4WQPTDX9VR2PM2ZZTVRJWRJ','01M4WQPSH7GKSSFNQPYJAA0X7J',0,1),('01M4WQPTGGSP912JDXMV009546','01M4WQPSDRQ6R680M22DE9BH8R',0,1),('01M4WQPTKD9DRJYFZ64BYHM102','01M4WQPSG1YHXSAHXNTXFGWJN5',0,1);
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
  CONSTRAINT `ck_variants_volume` CHECK ((`volume_ml` > 0)),
  CONSTRAINT `ck_variants_weight` CHECK ((`weight_gram` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_variants`
--

LOCK TABLES `product_variants` WRITE;
/*!40000 ALTER TABLE `product_variants` DISABLE KEYS */;
INSERT INTO `product_variants` VALUES ('01M4WQPSY1AFQ5MTAWRJ9WEWQK','01M4WQPSTHCBPBSHGJJ9SJVFRW','RXN-BDG-500',NULL,500,45.00,260000.00,NULL,950,'ACTIVE',0,'2026-10-14 01:15:51.233191','2026-10-14 01:15:51.233191',NULL),('01M4WQPT3BF1FKTJB06Z1TYRQA','01M4WQPT1ZSYTDWBQKSGKTAG61','RXN-BDN-500',NULL,500,48.00,295000.00,NULL,950,'ACTIVE',0,'2026-10-14 01:15:51.403072','2026-10-14 01:15:51.403072',NULL),('01M4WQPT5Y9QQH3HC7QF6WQTBG','01M4WQPT57GMPKCZ6W0Q32RGMC','RXN-BDX-500',NULL,500,45.00,320000.00,NULL,950,'ACTIVE',0,'2026-10-14 01:15:51.486481','2026-10-14 01:15:51.486481',NULL),('01M4WQPT8XEAJX71D5A1WNZBCR','01M4WQPT7Y9YG21RJEN6BD3NVV','RXN-BSR-500',NULL,500,45.00,390000.00,NULL,950,'ACTIVE',0,'2026-10-14 01:15:51.581913','2026-10-14 01:15:51.581913',NULL),('01M4WQPTBX3QYPFGTJA1MWE5NB','01M4WQPTAYVK1CB5QCKGXA47PV','RXN-NLX-500',NULL,500,35.00,275000.00,NULL,950,'ACTIVE',0,'2026-10-14 01:15:51.677285','2026-10-14 01:15:51.677285',NULL),('01M4WQPTEGQRQRXZSB38NFQCPZ','01M4WQPTDX9VR2PM2ZZTVRJWRJ','RXN-MLA-500',NULL,500,38.00,310000.00,NULL,950,'ACTIVE',0,'2026-10-14 01:15:51.760744','2026-10-14 01:15:51.760744',NULL),('01M4WQPTHFT6T7BX7QFWTSKK93','01M4WQPTGGSP912JDXMV009546','RXN-BTC-750',NULL,750,50.00,480000.00,NULL,1200,'ACTIVE',0,'2026-10-14 01:15:51.855114','2026-10-14 01:15:51.855114',NULL),('01M4WQPTM8274PN3HAT1XY67Y6','01M4WQPTKD9DRJYFZ64BYHM102','RXN-SBD-1000',NULL,1000,45.00,850000.00,NULL,1450,'ACTIVE',0,'2026-10-14 01:15:51.944610','2026-10-14 01:15:51.944610',NULL);
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
INSERT INTO `products` VALUES ('01M4WQPSTHCBPBSHGJJ9SJVFRW','01M4WQPSKP2KC8C6ZWRJD2N8ZD','01M4WQPSQW8VKGA115SFH4B2M5','Bàu Đá Gạo Truyền Thống','bau-da-gao-truyen-thong','Trong trẻo, nồng ấm và có hậu vị gạo thanh.','Bàu Đá Gạo Truyền Thống được xây dựng như một sản phẩm tiêu biểu của bộ sưu tập Xứ Nẫu, tôn trọng nguyên liệu địa phương, nhịp chưng cất chậm và tinh thần thưởng thức có trách nhiệm.','Đậy kín, đặt nơi khô ráo, tránh ánh nắng trực tiếp và nguồn nhiệt.','Bình Định, Việt Nam','ACTIVE','Bàu Đá Gạo Truyền Thống | Rượu Xứ Nẫu','Trong trẻo, nồng ấm và có hậu vị gạo thanh.','01M4WQPSA7B6FR3VFK9X426PGC',1,'2026-10-14 01:15:51.121293','2026-10-14 01:15:51.295981',NULL),('01M4WQPT1ZSYTDWBQKSGKTAG61','01M4WQPSMGJJZV1S8B3ANMD0SW','01M4WQPSQW8VKGA115SFH4B2M5','Bàu Đá Nếp Hương','bau-da-nep-huong','Hương nếp chín dịu, vị rượu dày và êm.','Bàu Đá Nếp Hương được xây dựng như một sản phẩm tiêu biểu của bộ sưu tập Xứ Nẫu, tôn trọng nguyên liệu địa phương, nhịp chưng cất chậm và tinh thần thưởng thức có trách nhiệm.','Đậy kín, đặt nơi khô ráo, tránh ánh nắng trực tiếp và nguồn nhiệt.','Bình Định, Việt Nam','ACTIVE','Bàu Đá Nếp Hương | Rượu Xứ Nẫu','Hương nếp chín dịu, vị rượu dày và êm.','01M4WQPSBMAB4T74X3KD97HPW8',1,'2026-10-14 01:15:51.359823','2026-10-14 01:15:51.429789',NULL),('01M4WQPT57GMPKCZ6W0Q32RGMC','01M4WQPSN005H6G8QTM096WD2S','01M4WQPSQW8VKGA115SFH4B2M5','Bàu Đá Đậu Xanh','bau-da-dau-xanh','Thoảng hương đậu xanh, hậu vị bùi và gọn.','Bàu Đá Đậu Xanh được xây dựng như một sản phẩm tiêu biểu của bộ sưu tập Xứ Nẫu, tôn trọng nguyên liệu địa phương, nhịp chưng cất chậm và tinh thần thưởng thức có trách nhiệm.','Đậy kín, đặt nơi khô ráo, tránh ánh nắng trực tiếp và nguồn nhiệt.','Bình Định, Việt Nam','ACTIVE','Bàu Đá Đậu Xanh | Rượu Xứ Nẫu','Thoảng hương đậu xanh, hậu vị bùi và gọn.','01M4WQPSC3HCYRX2NQVF0XAX7M',1,'2026-10-14 01:15:51.463919','2026-10-14 01:15:51.519798',NULL),('01M4WQPT7Y9YG21RJEN6BD3NVV','01M4WQPSP4CNSP31A1XNZSQ1XE','01M4WQPSQW8VKGA115SFH4B2M5','Bàu Đá Bình Sứ Rồng','bau-da-binh-su-rong','Rượu gạo truyền thống trong bình sứ họa tiết Việt.','Bàu Đá Bình Sứ Rồng được xây dựng như một sản phẩm tiêu biểu của bộ sưu tập Xứ Nẫu, tôn trọng nguyên liệu địa phương, nhịp chưng cất chậm và tinh thần thưởng thức có trách nhiệm.','Đậy kín, đặt nơi khô ráo, tránh ánh nắng trực tiếp và nguồn nhiệt.','Bình Định, Việt Nam','ACTIVE','Bàu Đá Bình Sứ Rồng | Rượu Xứ Nẫu','Rượu gạo truyền thống trong bình sứ họa tiết Việt.','01M4WQPSD3NNQRQB14APPJK29C',1,'2026-10-14 01:15:51.550062','2026-10-14 01:15:51.614367',NULL),('01M4WQPTAYVK1CB5QCKGXA47PV','01M4WQPSMGJJZV1S8B3ANMD0SW','01M4WQPSQW8VKGA115SFH4B2M5','Nếp Lứt Xứ Nẫu','nep-lut-xu-nau','Dịu hơn dòng truyền thống, hương ngũ cốc rõ nét.','Nếp Lứt Xứ Nẫu được xây dựng như một sản phẩm tiêu biểu của bộ sưu tập Xứ Nẫu, tôn trọng nguyên liệu địa phương, nhịp chưng cất chậm và tinh thần thưởng thức có trách nhiệm.','Đậy kín, đặt nơi khô ráo, tránh ánh nắng trực tiếp và nguồn nhiệt.','Bình Định, Việt Nam','ACTIVE','Nếp Lứt Xứ Nẫu | Rượu Xứ Nẫu','Dịu hơn dòng truyền thống, hương ngũ cốc rõ nét.','01M4WQPSF80WS532EHBFGQ46K4',1,'2026-10-14 01:15:51.646722','2026-10-14 01:15:51.711005',NULL),('01M4WQPTDX9VR2PM2ZZTVRJWRJ','01M4WQPSKP2KC8C6ZWRJD2N8ZD','01M4WQPSQW8VKGA115SFH4B2M5','Men Lá An Lão','men-la-an-lao','Hương men lá mộc mạc, cân bằng và dễ thưởng thức.','Men Lá An Lão được xây dựng như một sản phẩm tiêu biểu của bộ sưu tập Xứ Nẫu, tôn trọng nguyên liệu địa phương, nhịp chưng cất chậm và tinh thần thưởng thức có trách nhiệm.','Đậy kín, đặt nơi khô ráo, tránh ánh nắng trực tiếp và nguồn nhiệt.','Bình Định, Việt Nam','ACTIVE','Men Lá An Lão | Rượu Xứ Nẫu','Hương men lá mộc mạc, cân bằng và dễ thưởng thức.','01M4WQPSH7GKSSFNQPYJAA0X7J',1,'2026-10-14 01:15:51.741455','2026-10-14 01:15:51.792101',NULL),('01M4WQPTGGSP912JDXMV009546','01M4WQPSKP2KC8C6ZWRJD2N8ZD','01M4WQPSQW8VKGA115SFH4B2M5','Bàu Đá Tuyển Chọn','bau-da-tuyen-chon','Mẻ rượu tuyển chọn, đậm vị và kéo dài hậu ấm.','Bàu Đá Tuyển Chọn được xây dựng như một sản phẩm tiêu biểu của bộ sưu tập Xứ Nẫu, tôn trọng nguyên liệu địa phương, nhịp chưng cất chậm và tinh thần thưởng thức có trách nhiệm.','Đậy kín, đặt nơi khô ráo, tránh ánh nắng trực tiếp và nguồn nhiệt.','Bình Định, Việt Nam','ACTIVE','Bàu Đá Tuyển Chọn | Rượu Xứ Nẫu','Mẻ rượu tuyển chọn, đậm vị và kéo dài hậu ấm.','01M4WQPSDRQ6R680M22DE9BH8R',1,'2026-10-14 01:15:51.824252','2026-10-14 01:15:51.882848',NULL),('01M4WQPTKD9DRJYFZ64BYHM102','01M4WQPSP4CNSP31A1XNZSQ1XE','01M4WQPSQW8VKGA115SFH4B2M5','Song Bình Đất Võ','song-binh-dat-vo','Bộ quà hai bình dành cho dịp sum họp và tri ân.','Song Bình Đất Võ được xây dựng như một sản phẩm tiêu biểu của bộ sưu tập Xứ Nẫu, tôn trọng nguyên liệu địa phương, nhịp chưng cất chậm và tinh thần thưởng thức có trách nhiệm.','Đậy kín, đặt nơi khô ráo, tránh ánh nắng trực tiếp và nguồn nhiệt.','Bình Định, Việt Nam','ACTIVE','Song Bình Đất Võ | Rượu Xứ Nẫu','Bộ quà hai bình dành cho dịp sum họp và tri ân.','01M4WQPSG1YHXSAHXNTXFGWJN5',1,'2026-10-14 01:15:51.917694','2026-10-14 01:15:51.975781',NULL);
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
INSERT INTO `refresh_tokens` VALUES ('01M4W6B3CHYRK168HFN8HMF3BE','01M4W68N231KS59HYAE86S9PGH','01M4W6B3CFQ938Q4TEHBDJAWBQ','40c73f16e59302ecd34637eea022f47223c9195b2a5735d5925ab4456e627e7e',NULL,'2026-11-12 20:12:21.903332',NULL,NULL,'2026-10-13 20:12:21.903332'),('01M4W6P6QYPKDWV9Y6ZYKRRSCP','01M4W68N231KS59HYAE86S9PGH','01M4W6P6QW1FDT7YM4CDFE1JAH','9338cc92c5169c265edc1e38ea52637df599fe10f47fa2bb2e8d06969cdcaae3',NULL,'2026-11-12 20:18:25.788255',NULL,NULL,'2026-10-13 20:18:25.788255'),('01M4W7WFQAHB549G2S7PV4AMKH','01M4W68N231KS59HYAE86S9PGH','01M4W7WFQ8FNNSZWNBB6X6B9DF','3f430710723cc5354d2767b1a14bcbbc3ac1561d4685199818979f00e6b9a070',NULL,'2026-11-12 20:39:20.169484',NULL,NULL,'2026-10-13 20:39:20.169484'),('01M4W7XYVN4XN9SYEW276ARJE9','01M4W68N231KS59HYAE86S9PGH','01M4W7XYVMNE5HZ209GAZPT54K','87fd12cb6541a8eeaac0092d57364e9ea11e8f30c239872d6f9270ae483bda81',NULL,'2026-11-12 20:40:08.437578',NULL,NULL,'2026-10-13 20:40:08.437578'),('01M4WKN65Q9H8EJJMZ55345Q95','01M4W68N231KS59HYAE86S9PGH','01M4WKN65MKGM4JK2FRSVK3321','df98d0f030ca7ecc129387c5327b8fff04c946347032d5a8e611808923fd09ee',NULL,'2026-11-13 00:05:03.925036',NULL,NULL,'2026-10-14 00:05:03.925036'),('01M4WQ3BMTR2S7K30PCRBKB7JM','01M4W68N231KS59HYAE86S9PGH','01M4WQ3BMSSWZA1GPNQMCJT0GR','79a4d7a7f1ac72f02de0db0a145e9b8b597271d65f2b12c23c6633966554343b',NULL,'2026-11-13 01:05:14.010239',NULL,NULL,'2026-10-14 01:05:14.010239'),('01M4WQC6NM0A9DE80FV1AJDMG2','01M4W68N231KS59HYAE86S9PGH','01M4WQC6NMAMVXJFDW9WNNYNHM','00d02c085e6b26c2c221aae79287c259f0c1da22c1eb8b272bc0d7c1835de706','b2c07fac02b300e1350ad0cee5b847177185a598469fc5dcc2183803c6c5279b','2026-11-13 01:10:03.828470','2026-10-14 01:16:13.561007','2026-10-14 01:16:13.561007','2026-10-14 01:10:03.828470'),('01M4WQPS6HDXDMJPV33J0KATAA','01M4W68N231KS59HYAE86S9PGH','01M4WQPS6H0JDNV3PXFWBQ5MKA','91a1203b15c5441cee09a873f747971659f8f6db26f6cd74220d4d9931ebc10e',NULL,'2026-11-13 01:15:50.481641',NULL,NULL,'2026-10-14 01:15:50.481641'),('01M4WQQFRXDKS0S360DR2FHGN6','01M4W68N231KS59HYAE86S9PGH','01M4WQC6NMAMVXJFDW9WNNYNHM','b2c07fac02b300e1350ad0cee5b847177185a598469fc5dcc2183803c6c5279b','5ded26794be79474671c9b4814612056063081bfaffedec469cd1557695005f4','2026-11-13 01:16:13.561007','2026-10-14 01:16:26.372954','2026-10-14 01:16:26.372954','2026-10-14 01:16:13.561007'),('01M4WQQW8JB4FMX5A7YEN3NDQB','01M4W68N231KS59HYAE86S9PGH','01M4WQC6NMAMVXJFDW9WNNYNHM','5ded26794be79474671c9b4814612056063081bfaffedec469cd1557695005f4','6cc6449d97e6fc925411181c7b4e30cb032d84fd9cbccfdb22cbf6295b735e26','2026-11-13 01:16:26.372954','2026-10-14 01:16:35.375548','2026-10-14 01:16:35.375548','2026-10-14 01:16:26.372954'),('01M4WQR51S0R992SRJ53F5A3KR','01M4W68N231KS59HYAE86S9PGH','01M4WQC6NMAMVXJFDW9WNNYNHM','6cc6449d97e6fc925411181c7b4e30cb032d84fd9cbccfdb22cbf6295b735e26',NULL,'2026-11-13 01:16:35.375548',NULL,NULL,'2026-10-14 01:16:35.375548'),('01M4WQXCH3EJ22NVPQ3PFKHAQN','01M4W68N231KS59HYAE86S9PGH','01M4WQXCH3SNWQ7HN3W15CE5QG','493e42b417724201cd9cb408cd5b586cd30a8315ccb0b929051c45895ff05cbb','95560a07a1a97ce7b61a0c71aec1766601c8b501729f138d63f5303ccf42a449','2026-11-13 01:19:26.883991','2026-10-14 01:20:12.975869','2026-10-14 01:20:12.975869','2026-10-14 01:19:26.883991'),('01M4WQYSHQD3MXHVX5B2WMKRES','01M4W68N231KS59HYAE86S9PGH','01M4WQXCH3SNWQ7HN3W15CE5QG','95560a07a1a97ce7b61a0c71aec1766601c8b501729f138d63f5303ccf42a449','6176a71a19805e4192f94154d3909690c189f0733a3b484b2bf8270b0fbc1f35','2026-11-13 01:20:12.975869','2026-10-14 01:20:15.344272','2026-10-14 01:20:15.344272','2026-10-14 01:20:12.975869'),('01M4WQYVWM15KTR5VDN3P36VNQ','01M4W68N231KS59HYAE86S9PGH','01M4WQXCH3SNWQ7HN3W15CE5QG','6176a71a19805e4192f94154d3909690c189f0733a3b484b2bf8270b0fbc1f35',NULL,'2026-11-13 01:20:15.344272',NULL,NULL,'2026-10-14 01:20:15.344272');
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
INSERT INTO `role_permissions` VALUES ('00000000000000000000000002','10000000000000000000000001'),('00000000000000000000000002','10000000000000000000000002'),('00000000000000000000000002','10000000000000000000000003'),('00000000000000000000000002','10000000000000000000000004'),('00000000000000000000000002','10000000000000000000000005'),('00000000000000000000000002','10000000000000000000000006'),('00000000000000000000000002','10000000000000000000000007'),('00000000000000000000000002','10000000000000000000000008'),('00000000000000000000000002','10000000000000000000000009'),('00000000000000000000000002','10000000000000000000000010');
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
-- Table structure for table `site_settings`
--

DROP TABLE IF EXISTS `site_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `site_settings` (
  `id` char(26) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(254) DEFAULT NULL,
  `address` varchar(500) DEFAULT NULL,
  `business_hours` varchar(255) DEFAULT NULL,
  `facebook_url` varchar(2048) DEFAULT NULL,
  `tiktok_url` varchar(2048) DEFAULT NULL,
  `youtube_url` varchar(2048) DEFAULT NULL,
  `zalo_url` varchar(2048) DEFAULT NULL,
  `directions_url` varchar(2048) DEFAULT NULL,
  `embed_url` varchar(2048) DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `version` bigint NOT NULL DEFAULT '0',
  `created_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_site_settings_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_settings`
--

LOCK TABLES `site_settings` WRITE;
/*!40000 ALTER TABLE `site_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `site_settings` ENABLE KEYS */;
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
INSERT INTO `users` VALUES ('01M4W68N231KS59HYAE86S9PGH','lovehoaivulover@gmail.com','$2a$12$ZYo0lHEFwt2ARPVyJVxP..qNsvhxuiyNjIUwrfRE97abJPu9VsgpG','Đặng Hoài Vũ',NULL,'ACTIVE','2026-10-13 20:11:01.698908',0,NULL,10,'2026-10-13 20:11:01.698908','2026-10-14 01:19:26.006017');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'binh_dinh_wine'
--

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

-- Dump completed on 2026-10-14 19:52:11
