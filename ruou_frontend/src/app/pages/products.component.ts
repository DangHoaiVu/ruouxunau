import { Component, computed, inject, signal } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { StoreService } from '../core/store.service';
import { ProductCardComponent } from '../shared/product-card.component';

@Component({
  selector: 'app-products',
  imports: [FormsModule, ProductCardComponent],
  template: `
    <section class="page-hero compact"><div class="container"><p class="eyebrow light">Bộ sưu tập Xứ Nẫu</p><h1>Chọn vị rượu<br /><em>hợp với câu chuyện.</em></h1><p>Khám phá theo dòng rượu, nồng độ và cách thưởng thức.</p></div></section>
    <section class="catalog section container">
      <div class="catalog-toolbar"><div><strong>{{ filtered().length }}</strong> sản phẩm</div><button class="filter-toggle" (click)="filterOpen.set(!filterOpen())">Bộ lọc <span>⚙</span></button><select [(ngModel)]="sort" aria-label="Sắp xếp"><option value="featured">Nổi bật</option><option value="price-asc">Giá tăng dần</option><option value="price-desc">Giá giảm dần</option><option value="stock">Còn hàng nhiều</option></select></div>
      <div class="catalog-layout">
        <aside class="filters" [class.open]="filterOpen()"><div class="filter-head"><h3>Bộ lọc</h3><button (click)="resetFilters()">Đặt lại</button></div><label>Tìm kiếm<input [(ngModel)]="query" placeholder="Tên, SKU, nguyên liệu..." /></label><label>Dòng rượu<select [(ngModel)]="category"><option value="">Tất cả</option>@for (item of categories(); track item) { <option [value]="item">{{ item }}</option> }</select></label><label>Nồng độ tối đa <strong>{{ maxAlcohol }}%</strong><input type="range" min="15" max="50" step="1" [(ngModel)]="maxAlcohol" /></label><label>Khoảng giá<select [(ngModel)]="priceRange"><option value="">Tất cả mức giá</option><option value="300">Dưới 300.000đ</option><option value="500">300.000đ – 500.000đ</option><option value="501">Trên 500.000đ</option></select></label><label class="check-row"><input type="checkbox" [(ngModel)]="inStockOnly" /> Chỉ hiện sản phẩm còn hàng</label></aside>
        <div class="product-grid">@for (product of filtered(); track product.id) { <app-product-card [product]="product" /> } @empty { <div class="empty-state"><span>⌕</span><h2>Chưa tìm thấy sản phẩm</h2><p>Thử thay đổi từ khóa hoặc bộ lọc.</p><button class="button button-secondary" (click)="resetFilters()">Xóa bộ lọc</button></div> }</div>
      </div>
    </section>
  `,
})
export class ProductsComponent {
  readonly store = inject(StoreService);
  readonly filterOpen = signal(false);
  readonly categories = computed(() => [...new Set(this.store.products().map(product => product.category))]);
  query = ''; category = ''; maxAlcohol = 50; priceRange = ''; inStockOnly = false; sort = 'featured';
  constructor(route: ActivatedRoute) { route.queryParamMap.subscribe(params => { this.query = params.get('q') ?? ''; }); }
  readonly filtered = () => {
    let result = this.store.products().filter(product => {
      const term = this.query.toLowerCase();
      const matchesQuery = !term || `${product.name} ${product.material} ${product.slug}`.toLowerCase().includes(term);
      const matchesPrice = !this.priceRange || (this.priceRange === '300' ? product.price < 300000 : this.priceRange === '500' ? product.price >= 300000 && product.price <= 500000 : product.price > 500000);
      return matchesQuery && (!this.category || product.category === this.category) && product.alcohol <= this.maxAlcohol && matchesPrice && (!this.inStockOnly || product.stock > 0);
    });
    if (this.sort === 'price-asc') result = result.sort((a, b) => a.price - b.price);
    if (this.sort === 'price-desc') result = result.sort((a, b) => b.price - a.price);
    if (this.sort === 'stock') result = result.sort((a, b) => b.stock - a.stock);
    return result;
  };
  resetFilters(): void { this.query = ''; this.category = ''; this.maxAlcohol = 50; this.priceRange = ''; this.inStockOnly = false; }
}
