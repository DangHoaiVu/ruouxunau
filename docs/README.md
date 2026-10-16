# Hồ sơ nền tảng — Rượu Xứ Nẫu

Bộ tài liệu này là baseline chung cho backend Spring Boot, frontend Angular, cơ sở dữ liệu MySQL và các tích hợp bên thứ ba. Mọi thay đổi nghiệp vụ sau khi duyệt phải được cập nhật tại đây trước khi triển khai.

## Thứ tự đọc

1. [Đặc tả nghiệp vụ](./01-business-requirements.md)
2. [State machine](./02-order-payment-state-machine.md)
3. [ERD và data dictionary](./03-database-erd.md)
4. [Hợp đồng API](./04-api-contract.md)
5. [Backlog và quality gate](./05-implementation-backlog.md)

## Quyết định đã chốt

- Kiến trúc backend: modular monolith, chia module theo domain; mỗi module có Controller → Service → Repository.
- Frontend: Angular responsive/PWA, hai shell Storefront và Admin.
- Database: MySQL Server, schema được quản lý bằng Flyway.
- Khách vãng lai chỉ xem nội dung; phải đăng nhập trước khi thêm giỏ hoặc đặt hàng.
- Thanh toán: COD, chuyển khoản ngân hàng và VNPay.
- Vận chuyển: thiết kế adapter để tích hợp GHN/GHTK/Viettel Post; triển khai từng nhà cung cấp theo tài khoản thật.
- Bài viết chỉ admin/biên tập viên có quyền mới được xuất bản.
- Production không chạy seed dữ liệu nghiệp vụ, không dùng mock/localStorage làm nguồn dữ liệu.
- Chỉ phát hành khi đạt toàn bộ quality gate trong tài liệu số 05.

