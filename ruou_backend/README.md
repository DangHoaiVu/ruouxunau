# Rượu Xứ Nẫu Backend

Backend Spring Boot cho hệ thống thương mại điện tử Rượu Xứ Nẫu. Ứng dụng dùng MySQL thật; không tạo dữ liệu seed mỗi lần chạy.

## MySQL Workbench và Flyway

- **MySQL Workbench** dùng để kết nối, quản trị, truy vấn và theo dõi MySQL Server.
- **Flyway** chạy cùng Spring Boot để tạo và nâng cấp cấu trúc database theo đúng phiên bản mã nguồn.
- Hai công cụ bổ trợ nhau. Có thể kiểm tra các lần cập nhật cấu trúc trong bảng `flyway_schema_history` bằng Workbench.

Không sửa trực tiếp các bảng nghiệp vụ sau khi hệ thống đã có dữ liệu. Mọi thay đổi cấu trúc phải được thêm bằng một migration mới trong `src/main/resources/db/migration`.

## Chuẩn bị database bằng Workbench

1. Mở kết nối MySQL Server trong Workbench.
2. Chạy script [`database/workbench/00_create_database.sql`](database/workbench/00_create_database.sql).
3. Trong **Administration > Users and Privileges**, tạo một tài khoản riêng cho ứng dụng, không dùng tài khoản `root`.
4. Cấp quyền cho tài khoản đó trên schema `binh_dinh_wine`.

Sau khi Spring Boot áp dụng migration V1–V8, có thể chạy **một lần** `database/workbench/01_import_approved_content.sql` trong Workbench trên database mới để nhập nội dung ban đầu đã được duyệt. Đây là dữ liệu nhập một lần, không phải seed runtime. Không chạy lại script trên database đã có dữ liệu; hãy backup trước khi nhập hoặc điều chỉnh.

Workbench chỉ là công cụ quản trị; MySQL Server phải đang chạy và nhận kết nối tại host/port đã cấu hình.

## Biến môi trường local

Thiết lập trong IntelliJ Run Configuration hoặc terminal trước khi chạy ứng dụng:

```powershell
$env:DB_URL = "jdbc:mysql://127.0.0.1:3307/binh_dinh_wine?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC"
$env:DB_USERNAME = "ruou_app"
$env:DB_PASSWORD = "<mat-khau-cua-ban>"
$env:JWT_SECRET = "<chuoi-ngau-nhien-toi-thieu-32-ky-tu>"
$env:MEDIA_UPLOAD_DIR = "D:/RuouXuNau/ruou_backend/uploads"
```

Không commit mật khẩu vào Git. File `.env.example` chỉ mô tả tên biến cần thiết.

Để bật email đặt lại mật khẩu, cấu hình `MAIL_HOST`, `MAIL_PORT`, `MAIL_USERNAME`, `MAIL_PASSWORD` và `MAIL_FROM`. Production bắt buộc các biến này và bật mail health check.

Tài khoản admin đầu tiên không được seed. Chỉ trong lần khởi tạo đầu tiên, đặt `BOOTSTRAP_ADMIN_ENABLED=true` cùng `BOOTSTRAP_ADMIN_EMAIL` và `BOOTSTRAP_ADMIN_PASSWORD`, khởi động dịch vụ một lần, sau đó tắt bootstrap và xóa biến mật khẩu.

## Chạy ứng dụng

```powershell
.\mvnw.cmd spring-boot:run
```

Sau khi khởi động thành công:

- API base: `http://localhost:8080/api/v1`
- Swagger UI: `http://localhost:8080/swagger-ui.html`
- Health check: `http://localhost:8080/actuator/health`

## Kiểm thử

```powershell
.\mvnw.cmd test
```

Các bài integration test dùng MySQL thật trong container tạm thời và tự bỏ qua nếu Docker chưa chạy. Docker Compose trong repository là phương án local tùy chọn, không bắt buộc khi đã có MySQL Server được quản trị qua Workbench.

## Trạng thái triển khai

- Foundation đã chạy trên MySQL Server 8.0 thật tại local.
- Migration V1–V8 tạo schema nền, Identity, Catalog, Media, CMS, trường trình bày/site assets, sổ biến động kho và đơn hàng. V7 mở sổ bằng đúng số tồn đã có; V8 bổ sung đơn hàng và phân loại media local.
- Đã có register, login, refresh-token rotation, logout, hồ sơ, sổ địa chỉ, reset mật khẩu qua SMTP và rate limit lưu trong MySQL.
- Admin đầu tiên đã được bootstrap trên database local rồi tắt bootstrap; mật khẩu không nằm trong mã nguồn hoặc cấu hình.
- Catalog có API công khai cho danh mục, tìm kiếm/lọc/phân trang và chi tiết sản phẩm; API quản trị có CRUD danh mục, cơ sở sản xuất, sản phẩm và biến thể, kèm soft delete, optimistic locking và audit log.
- Media nhận file JPG, PNG, WebP hoặc AVIF từ máy local (tối đa 10 MB), lưu metadata và phân loại `BANNER`, `PRODUCT`, `ARTICLE`, `OTHER`; endpoint `PUT /api/v1/admin/site-assets/{key}` chọn ảnh banner từ thư viện với quyền admin và audit log.
- CMS có chuyên mục, tìm kiếm/phân trang và luồng bài viết `DRAFT → REVIEW → PUBLISHED`; chỉ bài đã xuất bản mới xuất hiện ở API công khai, admin có thể lưu trữ hoặc xóa mềm.
- Phân quyền Catalog được kiểm tra ở backend bằng `ADMIN_ACCESS` và `CATALOG_MANAGE`; guest/customer không thể gọi API quản trị.
- API `GET /api/v1/showcase` phục vụ sản phẩm, bài viết đã xuất bản và ảnh trang chủ từ MySQL.
- API admin `/api/v1/admin/inventory` hiển thị tồn/50 biến động gần nhất, CRUD SKU và điều chỉnh có lý do, người thực hiện, audit log.
- Khách đã đăng nhập có thể đặt đơn COD. Giá và tổng tiền được tính lại ở backend; đặt đơn trừ tồn trong transaction. Admin xử lý luồng `NEW → CONFIRMED → SHIPPING → COMPLETED`; hủy đơn hợp lệ hoàn tồn và ghi sổ kho.
- Trước V7 đã sao lưu database local tại `../backups/inventory-pre-v7-20261015/binh_dinh_wine.sql`; kiểm tra số tồn sau migration: 6 biến thể, tổng 102 chai và 6 bút toán mở sổ tương ứng.
- Phạm vi demo local không tích hợp cổng thanh toán hoặc hãng vận chuyển: thanh toán là COD và trạng thái giao hàng do admin quản lý. Trước khi triển khai production vẫn cần cấu hình SMTP thật, backup/monitoring, integration test đầy đủ và UAT.
