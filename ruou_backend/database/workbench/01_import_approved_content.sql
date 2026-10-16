-- Run once with MySQL Workbench after Spring Boot has applied schema migration V6.
-- Existing product, article, and media tables must be empty. This file is not a runtime seed.
SET NAMES utf8mb4;
START TRANSACTION;
INSERT INTO categories (id, name, slug, status, sort_order) VALUES
  ('20000000000000000000000001', 'Rượu gạo', 'ruou-gao', 'ACTIVE', 1),
  ('20000000000000000000000002', 'Rượu nếp', 'ruou-nep', 'ACTIVE', 2),
  ('20000000000000000000000003', 'Rượu ủ', 'ruou-u', 'ACTIVE', 3),
  ('20000000000000000000000004', 'Rượu thảo mộc', 'ruou-thao-moc', 'ACTIVE', 4),
  ('20000000000000000000000005', 'Quà tặng', 'qua-tang', 'ACTIVE', 5);

INSERT INTO producers (id, name, origin, status) VALUES
  ('21000000000000000000000001', 'Cơ sở làng nghề Cù Lâm', 'An Nhơn, Bình Định', 'ACTIVE'),
  ('21000000000000000000000002', 'Xưởng ủ Nhơn Lộc', 'Thị xã An Nhơn, Bình Định', 'ACTIVE'),
  ('21000000000000000000000003', 'Nhà ủ Tây Sơn', 'Tây Sơn, Bình Định', 'ACTIVE'),
  ('21000000000000000000000004', 'Hợp tác xã An Lão', 'An Lão, Bình Định', 'ACTIVE'),
  ('21000000000000000000000005', 'Rượu Xứ Nẫu', 'Bình Định', 'ACTIVE');

INSERT INTO media (id, url, mime_type, alt_text) VALUES
  ('24000000000000000000000001', 'https://www.mamashopinc.com/cdn/shop/files/Ruou_Lang_Classic_750ml_2.avif?v=1764663493&width=1445', 'image/avif', 'Bàu Đá Truyền Thống'),
  ('24000000000000000000000002', 'https://museawards.world/upload/entry/files/ME214022/small/24151680762805.jpg', 'image/jpeg', 'Bàu Đá Truyền Thống'),
  ('24000000000000000000000003', 'https://www.missingumami.com/images/hero/shaoxing-bottle.webp', 'image/webp', 'Bàu Đá Truyền Thống'),
  ('24000000000000000000000004', 'https://kokyo-market.com/cdn/shop/files/RV01_2.jpg?v=1757076411', 'image/jpeg', 'Nếp Cái Hoa Vàng'),
  ('24000000000000000000000005', 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=1600&q=85', 'image/jpeg', 'Men rượu giữ hồn làng qua những mùa gió nồm'),
  ('24000000000000000000000006', 'https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?auto=format&fit=crop&w=1200&q=85', 'image/jpeg', 'Chọn rượu cho một bữa cơm Việt trọn vị'),
  ('24000000000000000000000007', 'https://images.unsplash.com/photo-1536304993881-ff6e9eefa2a6?auto=format&fit=crop&w=1200&q=85', 'image/jpeg', 'Hành trình của hạt gạo trong một mẻ rượu thủ công'),
  ('24000000000000000000000008', 'https://images.unsplash.com/photo-1527281400683-1aae777175f8?auto=format&fit=crop&w=1200&q=85', 'image/jpeg', 'Thưởng thức có trách nhiệm là một phần của văn hóa rượu'),
  ('24000000000000000000000009', 'https://images.unsplash.com/photo-1609412058473-c199497c3c5d?auto=format&fit=crop&w=2000&q=88', 'image/jpeg', 'Banner trang chủ'),
  ('24000000000000000000000010', 'https://images.unsplash.com/photo-1536304993881-ff6e9eefa2a6?auto=format&fit=crop&w=1600&q=90', 'image/jpeg', 'Hạt gạo nguyên liệu'),
  ('24000000000000000000000011', 'https://images.unsplash.com/photo-1516594915697-87eb3b1c14ea?auto=format&fit=crop&w=2000&q=86', 'image/jpeg', 'Ảnh nền trang nội dung'),
  ('24000000000000000000000012', 'https://images.unsplash.com/photo-1516594915697-87eb3b1c14ea?auto=format&fit=crop&w=1400&q=85', 'image/jpeg', 'Ảnh trang đăng nhập'),
  ('24000000000000000000000013', 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=2000&q=85', 'image/jpeg', 'Ảnh trang liên hệ');

INSERT INTO products (id, category_id, producer_id, name, slug, short_description, material, badge, featured, tasting_notes, description, origin, status, primary_media_id) VALUES
  ('22000000000000000000000001', '20000000000000000000000001', '21000000000000000000000001', 'Bàu Đá Truyền Thống', 'bau-da-truyen-thong', 'Vị nồng ấm, hậu ngọt sâu, chưng cất thủ công theo lối xưa.', 'Gạo lứt và men gia truyền', 'Bán chạy', 1, '["Gạo rang","Thảo mộc","Hậu ngọt"]', 'Một phiên bản gợi nhắc tinh thần rượu Bàu Đá Bình Định: mạnh mẽ ở ngụm đầu, êm dần và để lại hậu vị của hạt gạo rang. Nội dung và bao bì hiện là dữ liệu mẫu để hoàn thiện trải nghiệm.', 'An Nhơn, Bình Định', 'ACTIVE', '24000000000000000000000001'),
  ('22000000000000000000000002', '20000000000000000000000002', '21000000000000000000000002', 'Nếp Cái Hoa Vàng', 'nep-cai-hoa-vang', 'Hương nếp chín dịu, thân rượu mềm và cân bằng.', 'Nếp cái hoa vàng', 'Mới', 1, '["Nếp chín","Hoa trắng","Mật nhẹ"]', 'Ủ từ nếp thơm và men truyền thống, dòng rượu nhẹ hơn dành cho những bữa cơm sum họp. Thông tin sản phẩm đang ở chế độ minh họa.', 'Thị xã An Nhơn, Bình Định', 'ACTIVE', '24000000000000000000000004'),
  ('22000000000000000000000003', '20000000000000000000000003', '21000000000000000000000003', 'Hoàng Kim Hạ Thổ', 'hoang-kim-ha-tho', 'Ủ chum hạ thổ cho sắc hổ phách và tầng hương sâu.', 'Gạo thơm tuyển chọn', 'Giới hạn', 1, '["Mơ chín","Gỗ nhẹ","Hạt rang"]', 'Dòng rượu ủ giới hạn với hình dung về một phiên bản quà tặng trang trọng, phù hợp dịp lễ và tiếp khách.', 'Tây Sơn, Bình Định', 'ACTIVE', '24000000000000000000000002'),
  ('22000000000000000000000004', '20000000000000000000000002', '21000000000000000000000004', 'Nếp Than An Lão', 'ruou-nep-than', 'Màu đỏ tím tự nhiên, vị chua ngọt hài hòa.', 'Nếp than', NULL, 1, '["Mận đỏ","Nếp than","Chua dịu"]', 'Dòng rượu lên men nhẹ từ nếp than, hương vị dễ tiếp cận và phù hợp dùng lạnh.', 'An Lão, Bình Định', 'ACTIVE', '24000000000000000000000003'),
  ('22000000000000000000000005', '20000000000000000000000004', '21000000000000000000000003', 'Men Lá Tây Sơn', 'men-la-tay-son', 'Mùi men lá thanh, vị ấm và giàu cá tính núi rừng.', 'Gạo và men lá', 'Đặc sản', 0, '["Lá thơm","Tiêu rừng","Gạo mới"]', 'Gợi cảm hứng từ men lá bản địa với cách trình bày hiện đại. Dữ liệu mẫu phục vụ thiết kế giao diện.', 'Tây Sơn, Bình Định', 'ACTIVE', '24000000000000000000000001'),
  ('22000000000000000000000006', '20000000000000000000000005', '21000000000000000000000005', 'Hộp Quà Xứ Nẫu', 'qua-tang-xu-nau', 'Hộp quà trang nhã cho lễ Tết và đối tác.', 'Bàu Đá tuyển chọn', 'Quà tặng', 0, '["Gạo thơm","Vani","Hậu dài"]', 'Bộ quà tặng mẫu gồm rượu tuyển chọn và ly thưởng thức, hướng tới khách hàng doanh nghiệp.', 'Bình Định', 'ACTIVE', '24000000000000000000000002');

INSERT INTO product_variants (id, product_id, sku, volume_ml, alcohol_percent, price, compare_price, weight_gram, stock_quantity, status) VALUES
  ('23000000000000000000000001', '22000000000000000000000001', 'RXN-001', 500, 45, 285000, 320000, 0, 24, 'ACTIVE'),
  ('23000000000000000000000002', '22000000000000000000000002', 'RXN-002', 500, 29, 245000, NULL, 0, 18, 'ACTIVE'),
  ('23000000000000000000000003', '22000000000000000000000003', 'RXN-003', 700, 38, 490000, 550000, 0, 8, 'ACTIVE'),
  ('23000000000000000000000004', '22000000000000000000000004', 'RXN-004', 500, 18, 210000, NULL, 0, 32, 'ACTIVE'),
  ('23000000000000000000000005', '22000000000000000000000005', 'RXN-005', 500, 35, 330000, NULL, 0, 14, 'ACTIVE'),
  ('23000000000000000000000006', '22000000000000000000000006', 'RXN-006', 700, 40, 790000, NULL, 0, 6, 'ACTIVE');

INSERT INTO product_images (product_id, media_id, sort_order, is_primary) VALUES
  ('22000000000000000000000001', '24000000000000000000000001', 0, 1),
  ('22000000000000000000000001', '24000000000000000000000002', 1, 0),
  ('22000000000000000000000001', '24000000000000000000000003', 2, 0),
  ('22000000000000000000000002', '24000000000000000000000004', 0, 1),
  ('22000000000000000000000002', '24000000000000000000000001', 1, 0),
  ('22000000000000000000000002', '24000000000000000000000003', 2, 0),
  ('22000000000000000000000003', '24000000000000000000000002', 0, 1),
  ('22000000000000000000000003', '24000000000000000000000001', 1, 0),
  ('22000000000000000000000003', '24000000000000000000000003', 2, 0),
  ('22000000000000000000000004', '24000000000000000000000003', 0, 1),
  ('22000000000000000000000004', '24000000000000000000000004', 1, 0),
  ('22000000000000000000000004', '24000000000000000000000001', 2, 0),
  ('22000000000000000000000005', '24000000000000000000000001', 0, 1),
  ('22000000000000000000000005', '24000000000000000000000003', 1, 0),
  ('22000000000000000000000005', '24000000000000000000000002', 2, 0),
  ('22000000000000000000000006', '24000000000000000000000002', 0, 1),
  ('22000000000000000000000006', '24000000000000000000000001', 1, 0),
  ('22000000000000000000000006', '24000000000000000000000004', 2, 0);

INSERT INTO article_categories (id, name, slug, status, sort_order) VALUES
  ('25000000000000000000000001', 'Làng nghề', 'lang-nghe', 'ACTIVE', 1),
  ('25000000000000000000000002', 'Thưởng thức', 'thuong-thuc', 'ACTIVE', 2),
  ('25000000000000000000000003', 'Kỹ nghệ', 'ky-nghe', 'ACTIVE', 3),
  ('25000000000000000000000004', 'Văn hóa', 'van-hoa', 'ACTIVE', 4);

SET @admin_id = (SELECT u.id FROM users u JOIN user_roles ur ON ur.user_id = u.id JOIN roles r ON r.id = ur.role_id WHERE r.code = 'ADMIN' ORDER BY u.created_at LIMIT 1);
-- An absent admin causes a foreign-key error and rolls back the import.
INSERT INTO articles (id, author_id, category_id, featured_media_id, title, slug, excerpt, byline,
    reading_minutes, featured, content, status, published_at) VALUES
  ('26000000000000000000000001', @admin_id, '25000000000000000000000001', '24000000000000000000000005', 'Men rượu giữ hồn làng qua những mùa gió nồm', 'men-ruou-giu-hon-lang', 'Một buổi sớm ở làng nghề, nơi nồi đồng đỏ lửa và câu chuyện truyền nghề vẫn tiếp tục.', 'Ban biên tập', 6, 1, 'Giữa miền đất võ, nghề nấu rượu bắt đầu từ những điều rất nhỏ: hạt gạo được chọn kỹ, bánh men được giữ khô và ngọn lửa phải đều suốt nhiều giờ.\n\nMỗi gia đình có một cách lắng nghe nồi rượu riêng. Người thợ không chỉ nhìn đồng hồ; họ nhìn dòng rượu, ngửi mùi men và điều chỉnh lửa bằng kinh nghiệm tích lũy qua nhiều mùa.\n\nBài viết này đang dùng nội dung minh họa. Khi có tư liệu chính thức, ban biên tập có thể thay nội dung trong CMS mà không cần chỉnh sửa giao diện.', 'PUBLISHED', '2026-10-08 00:00:00'),
  ('26000000000000000000000002', @admin_id, '25000000000000000000000002', '24000000000000000000000006', 'Chọn rượu cho một bữa cơm Việt trọn vị', 'chon-ruou-cho-bua-com-viet', 'Từ món nướng đến món kho, cách chọn nồng độ và hương vị để bàn ăn cân bằng hơn.', 'Minh An', 5, 0, 'Rượu ngon không nhất thiết phải mạnh. Một lựa chọn phù hợp là lựa chọn hòa hợp với món ăn, thời tiết và nhịp của bữa cơm.\n\nVới món nướng đậm vị, có thể chọn rượu có thân vị rõ. Với món hấp hoặc món thanh, nên ưu tiên dòng rượu nhẹ và uống ở nhiệt độ mát.', 'PUBLISHED', '2026-10-03 00:00:00'),
  ('26000000000000000000000003', @admin_id, '25000000000000000000000003', '24000000000000000000000007', 'Hành trình của hạt gạo trong một mẻ rượu thủ công', 'hanh-trinh-hat-gao', 'Từ ruộng lúa, gian bếp ủ men đến giọt rượu đầu tiên chảy qua ống tre.', 'Thanh Bình', 8, 0, 'Chất lượng của một mẻ rượu được quyết định từ trước khi nhóm lửa. Độ mới của gạo, độ ẩm của men và nguồn nước đều tạo nên khác biệt.\n\nQuá trình lên men cần được theo dõi ổn định. Khi chưng cất, người thợ tách phần đầu, phần giữa và phần cuối để chọn phần rượu có chất lượng tốt nhất.', 'PUBLISHED', '2026-09-28 00:00:00'),
  ('26000000000000000000000004', @admin_id, '25000000000000000000000004', '24000000000000000000000008', 'Thưởng thức có trách nhiệm là một phần của văn hóa rượu', 'thuong-thuc-co-trach-nhiem', 'Uống chậm, hiểu giới hạn và tuyệt đối không lái xe sau khi sử dụng đồ uống có cồn.', 'Ban biên tập', 4, 0, 'Văn hóa thưởng thức bắt đầu từ sự chừng mực. Rượu nên đồng hành cùng câu chuyện và món ăn, không phải là mục tiêu của cuộc gặp.\n\nLuôn chuẩn bị phương án di chuyển an toàn và không khuyến khích người chưa đủ tuổi sử dụng đồ uống có cồn.', 'PUBLISHED', '2026-09-18 00:00:00');
INSERT INTO site_assets (asset_key, media_id) VALUES
  ('home.hero', '24000000000000000000000009'),
  ('home.craft', '24000000000000000000000010'),
  ('page.hero', '24000000000000000000000011'),
  ('auth.visual', '24000000000000000000000012'),
  ('contact.hero', '24000000000000000000000013');

COMMIT;
