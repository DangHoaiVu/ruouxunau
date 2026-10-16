# Rượu Xứ Nẫu — Angular storefront

Giao diện Angular đọc sản phẩm, bài viết đã xuất bản và metadata ảnh local từ MySQL thông qua Spring Boot. Ảnh và nội dung hiện tại được lưu trong backend/database; ứng dụng không dùng `mock-data.ts` lúc chạy.

## Chạy local

Khởi động MySQL và Spring Boot tại `http://127.0.0.1:8080`, sau đó:

```powershell
npm install
npm start
```

Angular dev server proxy `/api` đến backend theo `proxy.conf.json`. Mở `http://localhost:4200` (hoặc cổng được chọn khi 4200 bận).

## Đã kết nối thật

- Register/login, JWT access token, refresh cookie (tự gia hạn trước thao tác quản trị) và RBAC ADMIN/CUSTOMER từ Spring Boot.
- Danh sách/chi tiết sản phẩm, bài viết đã xuất bản, banner và ảnh từ MySQL.
- Admin có bảy khu vực: Tổng quan, Sản phẩm, Danh mục, Đơn hàng, Bài viết, Kho hàng và Ảnh giao diện. Hai loại danh mục được quản lý chung trên một trang.
- Ảnh sản phẩm và ảnh bài viết được tải trực tiếp trong form CRUD tương ứng. Trang Ảnh giao diện chỉ quản lý banner, ảnh đăng nhập, liên hệ và các vùng hình ảnh dùng chung.
- Slug và SKU được tự sinh; danh mục và nhà sản xuất dùng ô nhập có gợi ý, đồng thời có thể tạo bản ghi mới ngay trong luồng thêm sản phẩm/bài viết.
- Trang kho hiển thị tồn ghi nhận, CRUD SKU, lịch sử biến động và cho admin kiểm kê cộng/trừ với lý do; mọi thay đổi lưu ở MySQL và audit log.
- Tài khoản đọc sổ địa chỉ từ backend và cho chỉnh sửa họ tên/số điện thoại qua API hồ sơ.
- Giỏ hàng tự xóa dòng khi số lượng về 0. Khách đã đăng nhập có thể đặt đơn COD; backend tính lại giá/tồn và trừ kho trong transaction.
- Khách theo dõi lịch sử đơn trong tài khoản. Admin xem đơn mới, xác nhận, chuyển giao, hoàn tất hoặc hủy; hủy đơn hợp lệ hoàn lại tồn kho.

## Phạm vi demo local

Phiên bản hiện tại dùng COD và trạng thái giao hàng nội bộ để hoàn thiện một luồng mua sắm có dữ liệu thật ở local. Cổng thanh toán và kết nối hãng vận chuyển nằm ngoài phạm vi demo. Trước khi production cần UAT, cấu hình hạ tầng/SMTP, backup, monitoring và kiểm thử tích hợp trong môi trường gần production.

## Kiểm tra

```powershell
npm run build
npm test -- --watch=false
```

Nên dùng Node.js bản LTS cho môi trường production.
