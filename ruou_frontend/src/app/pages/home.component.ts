import { Component, computed, inject } from '@angular/core';
import { RouterLink } from '@angular/router';
import { StoreService } from '../core/store.service';
import { ProductCardComponent } from '../shared/product-card.component';

@Component({
  selector: 'app-home',
  imports: [RouterLink, ProductCardComponent],
  template: `
    <section class="hero">
      <div class="hero-overlay"></div>
      <div class="hero-content container reveal"><p class="eyebrow light">Từ miền đất võ Bình Định</p><h1>Giọt nồng<br /><em>kể chuyện quê.</em></h1><p>Rượu thủ công từ hạt gạo Việt, gìn giữ bằng bàn tay người thợ và được kể lại trong một dáng hình đương đại.</p><div class="hero-actions"><a class="button button-primary" routerLink="/san-pham">Khám phá bộ sưu tập</a><a class="button button-ghost" routerLink="/cau-chuyen">Đọc chuyện làng nghề</a></div></div>
      <div class="hero-note"><span>01</span><p>Chưng cất thủ công<br />Tại Bình Định</p></div>
      <a class="scroll-cue" href="#featured">Cuộn để khám phá <span>↓</span></a>
    </section>

    <section class="intro section container"><div><p class="eyebrow">Một thức quà từ Xứ Nẫu</p><h2 class="display-title">Không chỉ là vị rượu.<br />Đó là ký ức của một miền đất.</h2></div><div class="intro-copy"><p>Từ nước giếng trong, hạt gạo tuyển chọn đến bánh men gia truyền, mỗi mẻ rượu cần thời gian, sự kiên nhẫn và cảm nhận của người thợ.</p><a class="arrow-link" routerLink="/cau-chuyen/men-ruou-giu-hon-lang">Xem hành trình làm rượu <span>→</span></a></div></section>

    <section id="featured" class="section featured-section"><div class="container section-heading"><div><p class="eyebrow">Bộ sưu tập nổi bật</p><h2>Chọn một hương vị riêng</h2></div><a class="arrow-link" routerLink="/san-pham">Xem tất cả <span>→</span></a></div><div class="product-marquee"><div class="marquee-track">@for (product of doubledProducts(); track $index) { <app-product-card [product]="product" /> }</div></div></section>

    <section class="craft-section section"><div class="craft-image">@if (store.assets()['home.craft']; as craftImage) { <img [src]="craftImage" alt="Hạt gạo nguyên liệu" loading="lazy" /> }<span class="image-caption">Nguyên liệu khởi đầu từ hạt gạo</span></div><div class="craft-copy"><p class="eyebrow light">Kỹ nghệ & thời gian</p><h2>Một mẻ rượu,<br />bốn lần nâng niu.</h2><div class="process-list"><div><span>01</span><h3>Chọn gạo</h3><p>Gạo thơm đều hạt, có nguồn gốc rõ ràng.</p></div><div><span>02</span><h3>Ủ men</h3><p>Giữ nhiệt và độ ẩm ổn định trong từng mẻ.</p></div><div><span>03</span><h3>Chưng cất</h3><p>Lửa đều, dòng rượu chậm và tuyển chọn kỹ.</p></div><div><span>04</span><h3>Nghỉ rượu</h3><p>Để hương vị cân bằng trước khi đóng chai.</p></div></div></div></section>

    <section class="section stories-preview container"><div class="section-heading"><div><p class="eyebrow">Tạp chí Xứ Nẫu</p><h2>Chuyện bên ché rượu</h2></div><a class="arrow-link" routerLink="/cau-chuyen">Đọc tất cả <span>→</span></a></div><div class="story-grid">@for (story of store.stories().slice(0, 3); track story.id) { <article class="story-card"><a [routerLink]="['/cau-chuyen', story.slug]"><img [src]="story.image" [alt]="story.title" loading="lazy" /></a><p class="eyebrow">{{ story.category }} · {{ story.readTime }} phút đọc</p><h3><a [routerLink]="['/cau-chuyen', story.slug]">{{ story.title }}</a></h3><p>{{ story.excerpt }}</p></article> }</div></section>

    <section class="service-strip"><div><svg viewBox="0 0 24 24"><path d="M3 7h11v10H3zM14 10h4l3 3v4h-7z"></path><circle cx="7" cy="19" r="2"></circle><circle cx="18" cy="19" r="2"></circle></svg><span><strong>Đặt hàng thuận tiện</strong><small>Thông tin đơn được lưu trực tiếp vào hệ thống</small></span></div><div><svg viewBox="0 0 24 24"><path d="M12 3l8 4v5c0 5-3.5 8-8 9-4.5-1-8-4-8-9V7z"></path><path d="m8 12 2.5 2.5L16 9"></path></svg><span><strong>Tài khoản bảo vệ</strong><small>Đăng nhập và phân quyền từ máy chủ</small></span></div><div><svg viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="14" rx="2"></rect><path d="M3 10h18"></path></svg><span><strong>Thanh toán COD</strong><small>Thanh toán tiền mặt khi nhận hàng</small></span></div></section>
  `,
})
export class HomeComponent {
  readonly store = inject(StoreService);
  readonly doubledProducts = computed(() => [...this.store.featuredProducts(), ...this.store.featuredProducts()]);
}
