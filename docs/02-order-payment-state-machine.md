# 02 — State machine nghiệp vụ

## 1. Trạng thái đơn hàng

```mermaid
stateDiagram-v2
  [*] --> PENDING_PAYMENT: Tạo đơn online/chuyển khoản
  [*] --> CONFIRMED: Tạo đơn COD hợp lệ
  PENDING_PAYMENT --> CONFIRMED: Thanh toán được xác nhận
  PENDING_PAYMENT --> PAYMENT_EXPIRED: Quá hạn
  PENDING_PAYMENT --> CANCELLED: Khách/admin hủy
  CONFIRMED --> PACKING: Nhân viên nhận xử lý
  CONFIRMED --> CANCELLED: Hủy hợp lệ
  PACKING --> READY_TO_SHIP: Đóng gói xong
  PACKING --> CANCELLED: Admin hủy có lý do
  READY_TO_SHIP --> SHIPPING: Bàn giao vận chuyển
  SHIPPING --> DELIVERED: Giao thành công
  SHIPPING --> DELIVERY_FAILED: Giao thất bại
  DELIVERY_FAILED --> SHIPPING: Giao lại
  DELIVERY_FAILED --> RETURNING: Hoàn về
  DELIVERED --> RETURN_REQUESTED: Khách yêu cầu trả
  RETURN_REQUESTED --> RETURNING: Duyệt trả hàng
  RETURN_REQUESTED --> DELIVERED: Từ chối hợp lệ
  RETURNING --> RETURNED: Kho nhận hàng
  RETURNED --> REFUNDED: Hoàn tiền xong
  CANCELLED --> REFUNDED: Đơn đã thu tiền
```

Quy tắc bắt buộc:

- Không chuyển ngược trạng thái tùy ý.
- Mọi lần chuyển trạng thái lưu history, actor, lý do và thời gian.
- Khách chỉ hủy `PENDING_PAYMENT` hoặc `CONFIRMED` khi chưa đóng gói.
- Đơn online không vào `PACKING` khi payment chưa `PAID`.
- Hủy/expire phải giải phóng reservation đúng một lần.
- `DELIVERED` không hủy; dùng quy trình return/refund.

## 2. Trạng thái thanh toán

```mermaid
stateDiagram-v2
  [*] --> INITIATED
  INITIATED --> PENDING: Đã tạo yêu cầu
  PENDING --> PAID: IPN/đối soát hợp lệ
  PENDING --> FAILED: Bị từ chối
  PENDING --> EXPIRED: Hết thời gian
  PAID --> REFUND_PENDING: Tạo yêu cầu hoàn
  REFUND_PENDING --> PARTIALLY_REFUNDED: Hoàn một phần
  REFUND_PENDING --> REFUNDED: Hoàn toàn bộ
  REFUND_PENDING --> REFUND_FAILED: Hoàn thất bại
  REFUND_FAILED --> REFUND_PENDING: Thử lại có kiểm soát
```

- Mỗi order có thể có nhiều payment attempt nhưng chỉ một tổng số tiền thành công hợp lệ.
- Giao dịch VNPay được unique theo provider transaction number và merchant reference.
- Callback có checksum sai chỉ ghi security log, không đổi payment/order.
- Return URL không được chuyển payment sang `PAID`.

## 3. Trạng thái giữ tồn

```mermaid
stateDiagram-v2
  [*] --> ACTIVE: Checkout giữ hàng
  ACTIVE --> COMMITTED: Đơn được xác nhận
  ACTIVE --> RELEASED: Hủy/thất bại
  ACTIVE --> EXPIRED: Quá hạn thanh toán
```

- `ACTIVE` làm tăng reserved, không giảm on-hand.
- `COMMITTED` giảm on-hand và reserved trong cùng transaction.
- `RELEASED/EXPIRED` chỉ giảm reserved.

## 4. Trạng thái vận chuyển

```text
NOT_CREATED → CREATED → PICKUP_SCHEDULED → PICKED_UP
→ IN_TRANSIT → DELIVERED

Nhánh lỗi:
CREATED/PICKUP_SCHEDULED → CANCELLED
IN_TRANSIT → DELIVERY_FAILED → IN_TRANSIT | RETURNING
RETURNING → RETURNED
```

Trạng thái từ GHN/GHTK/Viettel Post phải map vào enum nội bộ; không lưu enum phụ thuộc trực tiếp nhà cung cấp vào order.

## 5. Trạng thái bài viết

```text
DRAFT → IN_REVIEW → SCHEDULED → PUBLISHED → ARCHIVED
  ↑         │             │          │
  └─────────┴─────────────┴──────────┘ (trả về nháp khi có quyền)
```

- Editor: `DRAFT`, `IN_REVIEW`.
- Publisher/Admin: duyệt, lên lịch, xuất bản, gỡ bài.
- Job xuất bản theo lịch phải idempotent.

