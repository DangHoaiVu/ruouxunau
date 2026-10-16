import { Component, inject, input } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { Product } from '../core/models';
import { StoreService } from '../core/store.service';

@Component({
  selector: 'app-product-card',
  imports: [RouterLink],
  template: `
    <article class="product-card">
      <a class="product-image" [routerLink]="['/san-pham', product().slug]">
        @if (product().badge) { <span class="product-badge">{{ product().badge }}</span> }
        <img [src]="product().image" [alt]="product().name" loading="lazy" />
      </a>
      <div class="product-body">
        <p class="eyebrow">{{ product().category }} · {{ product().volume }}ml</p>
        <h3><a [routerLink]="['/san-pham', product().slug]">{{ product().name }}</a></h3>
        <p class="product-description">{{ product().shortDescription }}</p>
        <div class="product-meta"><span>{{ product().alcohol }}% vol</span><span>{{ product().stock > 0 ? 'Còn ' + product().stock : 'Hết hàng' }}</span></div>
        <div class="product-footer"><div><strong>{{ store.formatPrice(product().price) }}</strong>@if (product().comparePrice) { <del>{{ store.formatPrice(product().comparePrice!) }}</del> }</div><button class="add-button" [disabled]="product().stock <= 0" (click)="add()" [attr.aria-label]="product().stock > 0 ? 'Thêm vào giỏ' : 'Sản phẩm hết hàng'">{{ product().stock > 0 ? '+' : '×' }}</button></div>
      </div>
    </article>
  `,
})
export class ProductCardComponent {
  readonly product = input.required<Product>();
  readonly store = inject(StoreService);
  private readonly router = inject(Router);
  add(): void { if (!this.store.addToCart(this.product())) this.router.navigate(['/dang-nhap'], { queryParams: { returnUrl: `/san-pham/${this.product().slug}` } }); }
}
