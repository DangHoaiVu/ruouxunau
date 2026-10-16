# 05 — Backlog triển khai và quality gate

## Milestone 0 — Foundation

**Trạng thái: đã triển khai; integration test tự động cần Docker để chạy trong CI. Đã smoke-test trực tiếp trên MySQL Server 8.0.46 local ngày 2026-10-14.**

- Chuẩn hóa Maven metadata/package name.
- Profiles `local`, `test`, `staging`, `prod`.
- MySQL, Flyway baseline, Docker Compose local.
- Problem Details, validation, trace ID, structured logging.
- OpenAPI, health check, metrics.
- Testcontainers và pipeline build/test.

**Nghiệm thu:** ứng dụng khởi động trên database rỗng bằng migration; test dùng MySQL container; production profile không seed và không lộ secret.

## Milestone 1 — Identity và authorization

**Trạng thái: đang triển khai. Đã có schema user/role/permission/token/address, register/login/logout/forgot/reset, JWT access token, refresh rotation, ownership `/me`, rate limit trong MySQL, khóa tạm sau nhiều lần sai mật khẩu và bootstrap admin qua biến môi trường. Còn cấu hình SMTP thật và integration test CI trước khi nghiệm thu.**

- User, role, permission, refresh token rotation.
- Register/login/logout/forgot/reset.
- HttpOnly refresh cookie, access token ngắn hạn.
- Ownership và method security.
- Bootstrap super admin an toàn.

**Nghiệm thu:** guest không thêm giỏ; customer không gọi admin; revoke token hoạt động; rate limit auth; không lưu raw token/password.

## Milestone 2 — Catalog, CMS và media

- Product/category/variant/producer/media API.
- Search/filter/sort/pagination.
- Article workflow draft → review → publish.
- Upload validation và object storage adapter.
- Nối trang sản phẩm/câu chuyện/admin tương ứng.

**Nghiệm thu:** FE không còn import mock product/story; chỉ bài published xuất hiện công khai; ảnh lỗi có fallback; CRUD có audit.

## Milestone 3 — Inventory

- Warehouse, batch, inventory item/transaction.
- Nhập, xuất, kiểm kê, hư hỏng.
- Reservation và job hết hạn.
- Atomic update/optimistic lock và cảnh báo tồn thấp.

**Nghiệm thu:** test đồng thời chứng minh không bán vượt tồn; mọi thay đổi có ledger; không có đường dẫn làm tồn âm.

## Milestone 4 — Cart và promotion

- Giỏ theo user, reconcile giá/tồn.
- Quantity 0 xóa dòng.
- Promotion rules và usage limits.
- Checkout preview từ backend.

**Nghiệm thu:** tải lại/đổi thiết bị vẫn thấy giỏ; mã hết hạn/đủ lượt bị từ chối; frontend không tự tính tổng chính thức.

## Milestone 5 — Order, COD và chuyển khoản

- Transaction tạo đơn + snapshot + reservation.
- State machine và history.
- Hủy đơn/giải phóng tồn.
- COD và chuyển khoản có đối soát.
- Email sự kiện sau commit.

**Nghiệm thu:** double-click với cùng idempotency key tạo đúng một đơn; lỗi giữa transaction không để đơn/kho dở dang.

## Milestone 6 — VNPay

- Adapter cấu hình Sandbox.
- Signed payment URL, return, IPN.
- Verify checksum/amount/merchant/reference.
- Idempotent callback, query, reconcile, refund.
- UAT rồi mới thay cấu hình production.

**Nghiệm thu:** test success/failure/cancel/expire/tampered checksum/duplicate IPN/amount mismatch; order chỉ xác nhận từ nguồn backend hợp lệ.

## Milestone 7 — Shipping

- Provider abstraction.
- Tích hợp nhà cung cấp đầu tiên, sau đó thêm adapter khác.
- Quote token, create/cancel shipment, label, webhook/tracking.
- Retry có kiểm soát và chống tạo trùng.

**Nghiệm thu:** phí từ provider được backend kiểm tra lại; webhook lặp không đổi trạng thái hai lần; lỗi provider không làm mất đơn.

## Milestone 8 — Hoàn thiện FE và admin

- Thay toàn bộ store local/mock bằng generated API client/feature service.
- Loading, skeleton, empty, error, retry và form errors.
- Responsive storefront/admin; bảng mobile chuyển card/drawer hợp lý.
- Ẩn bằng feature flag mọi chức năng chưa có backend.
- Accessibility và reduced motion.

**Nghiệm thu:** không còn nút chết, mock/localStorage nghiệp vụ, lỗi console hoặc API error không xử lý.

## Milestone 9 — Production readiness

- Security review, dependency scan, permission matrix test.
- Performance/load test catalog, login, checkout, IPN.
- Backup/restore drill, monitoring/alerting, log retention.
- CI/CD staging → smoke test → production.
- Runbook incident, rollback và reconciliation.

## Definition of Done bắt buộc

- Acceptance criteria và business tests đã qua.
- Unit/integration/E2E đủ cho đường đi quan trọng.
- Không có lỗi P0/P1; không có lỗi P2 trên luồng mua hàng, thanh toán, kho, quyền.
- Không còn warning/error console chưa xử lý.
- API có validation, authorization, audit và observability phù hợp.
- Migration chạy được từ database rỗng và database phiên bản trước.
- Đã kiểm tra 320, 375, 768, 1024, 1440px và zoom 200%.
- Đã kiểm tra Chrome, Edge, Safari và thiết bị thật trước release.
- Có staging UAT và biên bản nghiệm thu.

## Thứ tự triển khai đề xuất

```text
M0 Foundation
 → M1 Identity
 → M2 Catalog/CMS
 → M3 Inventory
 → M4 Cart/Promotion
 → M5 Order/COD/Bank
 → M6 VNPay
 → M7 Shipping
 → M8 FE/Admin completion
 → M9 Production readiness
```

Không đánh dấu milestone hoàn thành nếu chỉ có UI hoặc happy path. Mỗi milestone phải có đường lỗi, quyền, audit và kiểm thử tương ứng.

