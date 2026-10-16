import { Component } from '@angular/core';

@Component({
  selector: 'app-policy',
  template: `<section class="page-hero mini"><div class="container"><p class="eyebrow light">Minh bạch & trách nhiệm</p><h1>Thông tin mua hàng</h1></div></section><section class="section container policy-layout"><nav><a href="#age">Độ tuổi</a><a href="#order">Đặt hàng</a><a href="#cod">Thanh toán COD</a></nav><div><section id="age"><p class="eyebrow">01</p><h2>Điều kiện độ tuổi</h2><p>Website chỉ dành cho người từ đủ 18 tuổi. Người mua chịu trách nhiệm xác nhận đúng độ tuổi khi đăng ký và đặt hàng.</p></section><section id="order"><p class="eyebrow">02</p><h2>Xác nhận đơn hàng</h2><p>Giá bán và tồn kho được kiểm tra trực tiếp trên hệ thống khi khách đặt đơn. Cửa hàng sẽ liên hệ xác nhận thông tin trước khi giao sản phẩm.</p></section><section id="cod"><p class="eyebrow">03</p><h2>Thanh toán khi nhận hàng</h2><p>Phiên bản demo sử dụng duy nhất hình thức COD. Website không yêu cầu chuyển khoản, không kết nối VNPay và không lưu thông tin ngân hàng.</p></section></div></section>`,
})
export class PolicyComponent {}
