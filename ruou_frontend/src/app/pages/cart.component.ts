import { Component, inject } from '@angular/core';
import { RouterLink } from '@angular/router';
import { StoreService } from '../core/store.service';

@Component({
  selector: 'app-cart', imports: [RouterLink],
  template: `
    <section class="page-hero mini"><div class="container"><p class="eyebrow light">Đơn hàng của bạn</p><h1>Giỏ hàng</h1></div></section>
    <section class="section container cart-layout">
      <div class="cart-list"><div class="cart-title"><h2>Sản phẩm <span>({{ store.cartCount() }})</span></h2><a routerLink="/san-pham">Tiếp tục mua sắm →</a></div>
        @for (item of store.cart(); track item.product.id) { <article class="cart-item"><img [src]="item.product.image" [alt]="item.product.name" /><div class="cart-item-info"><p class="eyebrow">{{ item.product.category }}</p><h3><a [routerLink]="['/san-pham', item.product.slug]">{{ item.product.name }}</a></h3><small>{{ item.product.volume }}ml · {{ item.product.alcohol }}% vol</small><button (click)="store.removeFromCart(item.product.id)">Xóa</button></div><div class="quantity"><button (click)="store.updateQuantity(item.product.id, item.quantity - 1)">−</button><span>{{ item.quantity }}</span><button (click)="store.updateQuantity(item.product.id, item.quantity + 1)">+</button></div><strong class="line-price">{{ store.formatPrice(item.product.price * item.quantity) }}</strong></article> } @empty { <div class="empty-state"><span>◌</span><h2>Giỏ hàng đang trống</h2><p>Hãy chọn một hương vị từ bộ sưu tập của chúng tôi.</p><a class="button button-primary" routerLink="/san-pham">Khám phá sản phẩm</a></div> }
      </div>
      @if (store.cart().length) { <aside class="order-summary"><h2>Tóm tắt giỏ hàng</h2><dl><div><dt>Tạm tính</dt><dd>{{ store.formatPrice(store.subtotal()) }}</dd></div><div><dt>Phí giao hàng</dt><dd>Miễn phí</dd></div><div class="summary-total"><dt>Tổng cộng</dt><dd>{{ store.formatPrice(store.subtotal()) }}</dd></div></dl><a class="button button-primary full" routerLink="/dat-hang">Tiến hành đặt hàng</a><small>Thanh toán tiền mặt khi nhận hàng. Tồn kho được kiểm tra lại khi đặt đơn.</small></aside> }
    </section>
  `,
})
export class CartComponent {
  readonly store = inject(StoreService);
}
