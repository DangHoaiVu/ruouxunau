# 01 — Đặc tả nghiệp vụ

## 1. Mục tiêu

Rượu Xứ Nẫu là hệ thống thương mại điện tử kết hợp trang nội dung và cổng quản trị, gồm ba vùng chức năng độc lập nhưng dùng chung dữ liệu:

1. Storefront giới thiệu thương hiệu và sản phẩm.
2. Kênh bán hàng cho khách hàng đã đăng nhập.
3. Admin portal vận hành sản phẩm, kho, đơn, thanh toán, vận chuyển và nội dung.

Production phải sử dụng API và database thật. Giao diện không được hiển thị dữ liệu doanh thu, đơn hàng, sản phẩm hoặc trạng thái giả.

## 2. Vai trò và quyền

### Khách vãng lai

- Xác nhận độ tuổi trước khi truy cập nội dung đồ uống có cồn.
- Xem trang chủ, sản phẩm, chi tiết, bài viết, liên hệ và chính sách.
- Tìm kiếm, lọc, sắp xếp sản phẩm và bài viết.
- Không được thêm giỏ, yêu thích, đánh giá hoặc đặt hàng.
- Khi thực hiện chức năng cần tài khoản, được chuyển tới đăng nhập và quay lại đúng trang sau khi thành công.

### Khách hàng

- Quản lý hồ sơ và nhiều địa chỉ nhận hàng.
- Thêm, sửa, xóa sản phẩm trong giỏ.
- Sử dụng mã khuyến mãi hợp lệ.
- Chọn vận chuyển và thanh toán COD/chuyển khoản/VNPay.
- Xem timeline đơn, mã vận đơn và lịch sử thanh toán.
- Hủy đơn khi trạng thái cho phép.
- Yêu thích sản phẩm và đánh giá sản phẩm đã mua, khi các module tương ứng được bật.

### Nhân sự quản trị

- `SUPER_ADMIN`: toàn bộ quyền và audit log.
- `PRODUCT_MANAGER`: sản phẩm, danh mục, biến thể, ảnh.
- `WAREHOUSE_STAFF`: lô sản xuất, nhập/xuất/kiểm kê kho.
- `ORDER_STAFF`: xác nhận, đóng gói, bàn giao và xử lý đơn.
- `CONTENT_EDITOR`: tạo, sửa, gửi duyệt bài.
- `CONTENT_PUBLISHER`: xuất bản, hẹn lịch, gỡ bài.
- `CUSTOMER_SUPPORT`: đọc đơn và hỗ trợ khách trong phạm vi được cấp.

Backend kiểm tra permission ở từng use case; route guard phía Angular chỉ hỗ trợ UX, không phải lớp bảo mật.

## 3. Catalog sản phẩm

Một sản phẩm gồm tên, slug, danh mục, cơ sở sản xuất, xuất xứ, mô tả, hướng dẫn bảo quản, SEO metadata và album ảnh. Mỗi biến thể/SKU gồm dung tích, nồng độ, giá, giá so sánh, barcode và trạng thái bán.

Quy tắc:

- SKU và slug là duy nhất.
- Tiền dùng `DECIMAL`, không dùng số thực dấu chấm động.
- Sản phẩm đã xuất hiện trong đơn không xóa cứng; chỉ ngừng bán hoặc soft delete.
- Giá hiển thị từ backend; backend kiểm tra lại giá tại checkout.
- Sản phẩm hết hàng không thể thêm giỏ.
- Ảnh nằm ở object storage/CDN; database chỉ lưu URL, alt text và metadata.

## 4. Kho và lô sản xuất

Kho được quản lý theo warehouse + SKU + lô sản xuất.

```text
available = on_hand - reserved
```

- `on_hand`: tồn thực tế.
- `reserved`: tồn đang giữ cho các đơn chưa hoàn tất.
- `available`: số lượng được phép bán.

Mọi biến động phải tạo `inventory_transaction` bất biến: nhập kho, giữ hàng, giải phóng, xuất bán, hoàn hàng, hư hỏng hoặc điều chỉnh kiểm kê.

Không cho tồn âm. Checkout phải dùng atomic update hoặc optimistic locking. Giữ hàng có thời hạn; hết thời hạn thanh toán phải giải phóng tồn tự động.

## 5. Giỏ hàng

- Mỗi khách hàng có một giỏ hoạt động.
- Thêm cùng SKU sẽ cộng số lượng nhưng không vượt tồn khả dụng.
- Giảm số lượng về 0 đồng nghĩa xóa dòng giỏ.
- Giá trong giỏ chỉ để hiển thị; tổng tiền chính thức được tính lại tại backend khi checkout.
- Sản phẩm ngừng bán, hết hàng hoặc đổi giá phải được cảnh báo khi mở giỏ/checkout.
- Không lưu giỏ nghiệp vụ trong localStorage trên production.

## 6. Khuyến mãi

Hỗ trợ giảm phần trăm, giảm số tiền, miễn phí vận chuyển và giảm theo sản phẩm/danh mục.

Backend kiểm tra thời gian hiệu lực, giá trị đơn tối thiểu, giới hạn toàn hệ thống, giới hạn theo khách, phạm vi sản phẩm và khả năng kết hợp. Việc áp dụng phải chống dùng vượt số lượt khi có nhiều checkout đồng thời.

## 7. Checkout và đơn hàng

Checkout thực hiện trong transaction nghiệp vụ:

1. Xác thực người dùng và địa chỉ.
2. Đọc lại sản phẩm, giá và tồn từ database.
3. Tính lại khuyến mãi và phí vận chuyển.
4. Tạo order và order item snapshot.
5. Giữ tồn kho.
6. Tạo payment tương ứng.
7. Trả kết quả hoặc URL thanh toán.

`order_items` lưu snapshot SKU, tên, dung tích, đơn giá, giảm giá và thuế/phí tại thời điểm mua. Sửa sản phẩm sau này không làm đổi đơn cũ.

Đơn COD có thể xác nhận sau khi tạo. Đơn chuyển khoản/VNPay chỉ được xử lý đóng gói sau khi thanh toán được backend xác nhận.

## 8. Thanh toán

### COD

- Payment ở trạng thái chờ thu khi giao.
- Khi giao thành công, ghi nhận đã thu COD theo dữ liệu vận chuyển/đối soát.

### Chuyển khoản

- Sinh nội dung chuyển khoản chứa mã đơn duy nhất.
- Chỉ admin hoặc cơ chế đối soát ngân hàng mới xác nhận đã nhận tiền.
- Không tin trạng thái do frontend gửi lên.

### VNPay

- Backend tạo URL đã ký; secret không bao giờ xuất hiện ở frontend.
- Tạo `payment_transaction` trước khi chuyển khách sang VNPay.
- IPN server-to-server là nguồn xác nhận thanh toán chính thức.
- Return URL chỉ hiển thị kết quả, không tự quyết định trạng thái đơn.
- IPN kiểm tra checksum, merchant, mã tham chiếu, số tiền, trạng thái và giao dịch đã xử lý hay chưa.
- Xử lý idempotent: một callback lặp lại không được trừ kho hoặc cập nhật đơn lần hai.
- Có API truy vấn/đối soát và refund; refund là bản ghi riêng, không sửa lịch sử cũ.

## 9. Vận chuyển

Shipping module dùng adapter chung cho từng nhà cung cấp:

- Báo phí/dịch vụ theo địa chỉ và trọng lượng.
- Tạo vận đơn sau khi đơn đủ điều kiện.
- Lưu mã vận đơn và nhãn giao hàng.
- Nhận webhook/truy vấn trạng thái.
- Map trạng thái nhà cung cấp về trạng thái nội bộ.
- Chống xử lý webhook trùng và lưu raw reference phục vụ đối soát.

Khi nhà cung cấp lỗi, hệ thống giữ nguyên đơn và hiển thị khả năng thử lại; không tạo nhiều vận đơn cho cùng một lần thao tác.

## 10. CMS bài viết và media

- Chỉ nhân sự có quyền mới tạo/sửa nội dung.
- Editor có thể lưu nháp/gửi duyệt; chỉ publisher/admin được xuất bản.
- Hỗ trợ slug, chuyên mục, tag, ảnh đại diện, tác giả, SEO, xem trước và lịch xuất bản.
- Bài đã xuất bản có thể gỡ/lưu trữ nhưng không xóa lịch sử audit.
- Media chỉ được xóa khi không còn tham chiếu.

## 11. Audit và thông báo

Các thao tác đổi giá, tồn kho, trạng thái đơn, thanh toán, refund, quyền và xuất bản bài phải lưu người thực hiện, thời điểm, đối tượng, giá trị trước/sau và trace ID.

Email/thông báo được phát từ sự kiện sau khi transaction chính commit; lỗi gửi thông báo không được rollback đơn hàng đã tạo thành công.

## 12. Yêu cầu phi chức năng

- API version `/api/v1` và response lỗi thống nhất theo Problem Details.
- Pagination cho mọi danh sách quản trị.
- Idempotency key cho checkout, thanh toán, refund và tạo vận đơn.
- UTC trong database; chuyển múi giờ khi hiển thị.
- Secrets qua environment/secret manager, không commit Git.
- CORS allowlist, rate limit cho auth/search/checkout, ownership check mọi tài nguyên theo ID.
- Có structured log, trace ID, health check, metrics, backup và restore drill.
- Production không chạy data seed. Dữ liệu thử chỉ thuộc profile `test`/`local` và không được đóng gói vào migration production.

