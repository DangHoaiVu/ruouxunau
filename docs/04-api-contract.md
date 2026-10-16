# 04 — Hợp đồng API mức cao

Base path: `/api/v1`. JSON UTF-8. Mọi mutation hỗ trợ trace ID; các mutation quan trọng yêu cầu `Idempotency-Key`.

## 1. Chuẩn response lỗi

```json
{
  "type": "https://api.ruouxunau.vn/problems/inventory-insufficient",
  "title": "Không đủ tồn kho",
  "status": 409,
  "code": "INVENTORY_INSUFFICIENT",
  "detail": "SKU RXN-001 chỉ còn 2 sản phẩm",
  "instance": "/api/v1/orders",
  "traceId": "01J...",
  "errors": []
}
```

Mã lỗi tối thiểu: `VALIDATION_FAILED`, `AUTHENTICATION_REQUIRED`, `ACCESS_DENIED`, `RESOURCE_NOT_FOUND`, `RESOURCE_CONFLICT`, `INVENTORY_INSUFFICIENT`, `PROMOTION_INVALID`, `ORDER_INVALID_STATE`, `PAYMENT_SIGNATURE_INVALID`, `PAYMENT_AMOUNT_MISMATCH`, `IDEMPOTENCY_CONFLICT`, `SHIPPING_PROVIDER_UNAVAILABLE`.

## 2. Authentication

| Method | Endpoint | Quyền | Mục đích |
|---|---|---|---|
| POST | `/auth/register` | Public | Đăng ký và xác nhận điều khoản/độ tuổi |
| POST | `/auth/login` | Public | Trả access token; đặt refresh cookie HttpOnly |
| POST | `/auth/refresh` | Cookie | Rotation refresh token |
| POST | `/auth/logout` | Authenticated | Revoke token family |
| POST | `/auth/forgot-password` | Public/rate limited | Tạo yêu cầu đặt lại |
| POST | `/auth/reset-password` | Token | Đổi mật khẩu một lần |
| GET | `/me` | Authenticated | Hồ sơ và permission |
| PATCH | `/me` | Authenticated | Cập nhật hồ sơ |
| GET/POST/PATCH/DELETE | `/me/addresses` | Authenticated/owner | Quản lý địa chỉ |

## 3. Catalog và nội dung công khai

| Method | Endpoint | Mục đích |
|---|---|---|
| GET | `/products` | Tìm kiếm, lọc, sort, pagination |
| GET | `/products/{slug}` | Chi tiết, biến thể, ảnh, tồn khả dụng |
| GET | `/categories` | Danh mục đang hoạt động |
| GET | `/articles` | Danh sách bài `PUBLISHED` |
| GET | `/articles/{slug}` | Đọc bài đã xuất bản |
| GET | `/article-categories` | Chuyên mục bài viết |

Query chuẩn: `page`, `size`, `sort`; product bổ sung `q`, `category`, `minPrice`, `maxPrice`, `minAlcohol`, `maxAlcohol`, `volume`, `inStock`.

## 4. Giỏ và khuyến mãi

| Method | Endpoint | Mục đích |
|---|---|---|
| GET | `/cart` | Lấy giỏ đã được reconcile giá/tồn |
| POST | `/cart/items` | Thêm SKU |
| PATCH | `/cart/items/{itemId}` | Đổi số lượng; `0` tương đương xóa |
| DELETE | `/cart/items/{itemId}` | Xóa dòng |
| POST | `/cart/promotion` | Áp mã và trả breakdown |
| DELETE | `/cart/promotion` | Bỏ mã |
| POST | `/checkout/preview` | Tính lại toàn bộ nhưng chưa tạo đơn |

## 5. Đơn hàng

| Method | Endpoint | Mục đích |
|---|---|---|
| POST | `/orders` | Tạo đơn; bắt buộc Idempotency-Key |
| GET | `/orders` | Đơn của người đăng nhập |
| GET | `/orders/{orderNumber}` | Chi tiết; ownership/permission |
| POST | `/orders/{orderNumber}/cancel` | Hủy nếu state cho phép |
| GET | `/orders/{orderNumber}/timeline` | Lịch sử trạng thái |

`CreateOrderRequest` chỉ gửi address ID/snapshot fields, shipping quote token, promotion code và payment method. Frontend không được gửi tổng tiền để backend tin dùng.

## 6. Thanh toán

| Method | Endpoint | Quyền | Mục đích |
|---|---|---|---|
| POST | `/payments/vnpay` | Owner | Tạo payment URL đã ký |
| GET | `/payments/vnpay/return` | Public | Trang điều hướng; chỉ đọc trạng thái |
| GET | `/payments/vnpay/ipn` | VNPAY | Verify checksum và cập nhật idempotent |
| GET | `/orders/{orderNumber}/payment` | Owner/Admin | Trạng thái từ backend |
| POST | `/admin/payments/{id}/reconcile` | PAYMENT_RECONCILE | Đối soát |
| POST | `/admin/payments/{id}/refunds` | PAYMENT_REFUND | Tạo refund idempotent |

Không bao giờ có endpoint để Angular tự đặt payment thành `PAID`.

## 7. Vận chuyển

| Method | Endpoint | Mục đích |
|---|---|---|
| POST | `/shipping/quotes` | Báo phí từ adapter thật |
| GET | `/shipping/providers` | Nhà cung cấp/dịch vụ khả dụng |
| POST | `/admin/orders/{id}/shipment` | Tạo vận đơn idempotent |
| POST | `/shipping/webhooks/{provider}` | Nhận trạng thái, verify provider |
| GET | `/orders/{orderNumber}/shipment` | Tracking đã map nội bộ |

## 8. Admin API

Mọi endpoint `/admin/**` yêu cầu permission cụ thể, có pagination và audit.

- `/admin/products`, `/admin/categories`, `/admin/variants`
- `/admin/warehouses`, `/admin/batches`, `/admin/inventory/transactions`
- `/admin/orders`, `/admin/orders/{id}/transitions`
- `/admin/promotions`
- `/admin/articles`, `/admin/article-categories`, `/admin/tags`
- `/admin/media`
- `/admin/users`, `/admin/roles`, `/admin/permissions`
- `/admin/audit-logs`
- `/admin/dashboard`

## 9. Quy ước kỹ thuật

- Create: `201`; update/read: `200`; delete thành công không body: `204`.
- Validation: `400`; chưa đăng nhập: `401`; thiếu quyền: `403`; không thấy: `404`; xung đột nghiệp vụ: `409`; rate limit: `429`.
- List response gồm `items`, `page`, `size`, `totalElements`, `totalPages`.
- DTO tách create/update/summary/detail; không trả JPA Entity trực tiếp.
- OpenAPI là nguồn hợp đồng; Angular client có thể generate từ spec sau khi ổn định.

