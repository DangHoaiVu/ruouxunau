import { Component, computed, inject, signal } from '@angular/core';
import { Product } from '../core/models';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { StoreService } from '../core/store.service';
import { ProductCardComponent } from '../shared/product-card.component';

@Component({
  selector: 'app-product-detail',
  imports: [RouterLink, ProductCardComponent],
  template: `
    @if (product(); as item) {
      <section class="product-detail section container">
        <div class="breadcrumbs"><a routerLink="/">Trang chủ</a><span>/</span><a routerLink="/san-pham">Sản phẩm</a><span>/</span><span>{{ item.name }}</span></div>
        <div class="product-detail-grid"><div class="gallery"><div class="main-image"><img [src]="selectedImage() || item.image" [alt]="item.name" />@if (item.badge) { <span class="product-badge">{{ item.badge }}</span> }</div><div class="thumbnails">@for (image of item.gallery; track image) { <button [class.active]="(selectedImage() || item.image) === image" (click)="selectedImage.set(image)"><img [src]="image" [alt]="item.name" /></button> }</div></div>
        <div class="product-info"><p class="eyebrow">{{ item.category }} · SKU {{ item.sku }}</p><h1>{{ item.name }}</h1><p class="lead">{{ item.shortDescription }}</p><div class="detail-price"><strong>{{ store.formatPrice(item.price) }}</strong>@if (item.comparePrice) { <del>{{ store.formatPrice(item.comparePrice) }}</del> }</div><div class="stock-line" [class.out]="item.stock <= 0"><span class="stock-dot"></span>{{ item.stock > 0 ? 'Còn ' + item.stock + ' sản phẩm' : 'Tạm hết hàng' }}</div><div class="spec-grid"><div><small>Dung tích</small><strong>{{ item.volume }} ml</strong></div><div><small>Nồng độ</small><strong>{{ item.alcohol }}% vol</strong></div><div><small>Nguyên liệu</small><strong>{{ item.material }}</strong></div><div><small>Xuất xứ</small><strong>{{ item.origin }}</strong></div></div><div class="tasting"><span>Hương vị</span>@for (note of item.tastingNotes; track note) { <em>{{ note }}</em> }</div><div class="buy-row"><div class="quantity"><button type="button" [disabled]="item.stock <= 0" (click)="decrease()">−</button><span>{{ item.stock > 0 ? quantity() : 0 }}</span><button type="button" [disabled]="item.stock <= 0 || quantity() >= item.stock" (click)="increase(item.stock)">+</button></div><button class="button button-primary grow" type="button" [disabled]="item.stock <= 0" (click)="add(item)">{{ item.stock > 0 ? 'Thêm vào giỏ' : 'Tạm hết hàng' }}</button></div><div class="delivery-note"><strong>Đặt hàng COD</strong><span>Đăng nhập để đặt hàng và thanh toán tiền mặt khi nhận sản phẩm.</span></div></div></div>
      </section>
      <section class="detail-story section"><div class="container two-column"><div><p class="eyebrow">Câu chuyện sản phẩm</p><h2>Chắt lọc từ<br />hạt gạo và thời gian.</h2></div><div><p>{{ item.description }}</p><dl><div><dt>Cơ sở sản xuất</dt><dd>{{ item.producer }}</dd></div><div><dt>Nguồn gốc</dt><dd>{{ item.origin }}</dd></div><div><dt>Bảo quản</dt><dd>Nơi khô ráo, tránh ánh nắng trực tiếp</dd></div></dl><p class="responsible">Sản phẩm dành cho người đủ 18 tuổi. Không lái xe sau khi sử dụng đồ uống có cồn.</p></div></div></section>
      <section class="section container"><div class="section-heading"><div><p class="eyebrow">Gợi ý tiếp theo</p><h2>Có thể bạn sẽ thích</h2></div></div><div class="product-grid related">@for (related of relatedProducts(); track related.id) { <app-product-card [product]="related" /> }</div></section>
    } @else if (store.showcaseStatus() === 'loading') { <section class="section empty-state"><p>Đang tải sản phẩm…</p></section> }
    @else { <section class="section empty-state"><h1>Không tìm thấy sản phẩm</h1><a class="button button-primary" routerLink="/san-pham">Về bộ sưu tập</a></section> }
  `,
})
export class ProductDetailComponent {
  readonly store = inject(StoreService);
  private readonly router = inject(Router);
  private readonly slug = inject(ActivatedRoute).snapshot.paramMap.get('slug');
  readonly product = computed(() => this.store.products().find(item => item.slug === this.slug));
  readonly selectedImage = signal(''); readonly quantity = signal(1);
  readonly relatedProducts = computed(() => this.store.products().filter(item => item.id !== this.product()?.id).slice(0, 3));
  decrease(): void { this.quantity.update(value => Math.max(1, value - 1)); }
  increase(stock: number): void { this.quantity.update(value => Math.min(stock, value + 1)); }
  add(product: Product): void { if (!this.store.addToCart(product, this.quantity())) this.router.navigate(['/dang-nhap'], { queryParams: { returnUrl: this.router.url } }); }
}
