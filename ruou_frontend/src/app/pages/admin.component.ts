import { DatePipe, DecimalPipe } from '@angular/common';
import { Component, inject, OnInit, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { firstValueFrom } from 'rxjs';
import { Order } from '../core/models';
import { StoreService } from '../core/store.service';

type Section = 'dashboard' | 'products' | 'categories' | 'orders' | 'articles' | 'inventory' | 'media';
type PublicationStatus = 'ACTIVE' | 'INACTIVE' | 'DRAFT';
type ArticleStatus = 'DRAFT' | 'REVIEW' | 'PUBLISHED' | 'ARCHIVED';
type MediaCategory = 'BANNER' | 'PRODUCT' | 'ARTICLE' | 'OTHER';
interface Page<T> { items: T[]; totalElements: number; }
interface Category { id: string; name: string; slug: string; description: string | null; status: PublicationStatus; sortOrder: number; }
interface Producer { id: string; name: string; status: PublicationStatus; }
interface AdminProduct { id: string; name: string; slug: string; shortDescription: string | null; origin: string | null; status: PublicationStatus; category: Category; producer: Producer | null; minPrice: number; maxPrice: number; variantCount: number; primaryImageUrl: string | null; }
interface ProductDetail { id: string; name: string; slug: string; shortDescription: string | null; description: string; storageInstructions: string | null; origin: string | null; status: PublicationStatus; seoTitle: string | null; seoDescription: string | null; category: Category; producer: Producer | null; variants: Variant[]; images: { id: string; url: string; primary: boolean }[]; }
interface Variant { id: string; productId: string; sku: string; barcode: string | null; volumeMl: number; alcoholPercent: number; price: number; comparePrice: number | null; weightGram: number; status: PublicationStatus; }
interface Article { id: string; title: string; slug: string; status: ArticleStatus; category: { id?: string; name: string }; authorName: string; }
interface ArticleDetail extends Article { excerpt: string; content: string; category: { id: string; name: string }; featuredMedia: Media | null; seoTitle: string | null; seoDescription: string | null; }
interface ArticleCategory { id: string; name: string; slug: string; description: string | null; status: PublicationStatus; sortOrder: number; }
interface Media { id: string; url: string; mimeType: string; category: MediaCategory; originalFilename: string | null; width: number | null; height: number | null; altText: string; createdAt: string; }
interface VariantStock { id: string; productId: string; productName: string; sku: string; stock: number; }
interface StockMovement { id: number; delta: number; balanceAfter: number; reason: string; actorId: string | null; movementType: string; createdAt: string; }

@Component({
  selector: 'app-admin',
  imports: [FormsModule, RouterLink, DatePipe, DecimalPipe],
  templateUrl: './admin.component.html',
  styleUrl: './admin.component.scss',
})
export class AdminComponent implements OnInit {
  readonly store = inject(StoreService); private readonly http = inject(HttpClient);
  readonly section = signal<Section>('dashboard'); readonly sidebarOpen = signal(false);
  readonly loading = signal(true); readonly saving = signal(false); readonly error = signal('');
  readonly products = signal<AdminProduct[]>([]); readonly categories = signal<Category[]>([]); readonly producers = signal<Producer[]>([]);
  readonly orders = signal<Order[]>([]); readonly selectedOrder = signal<Order | null>(null);
  readonly articles = signal<Article[]>([]); readonly articleCategories = signal<ArticleCategory[]>([]);
  readonly media = signal<Media[]>([]); readonly mediaFilter = signal<MediaCategory | 'ALL'>('ALL');
  readonly stocks = signal<VariantStock[]>([]); readonly movements = signal<StockMovement[]>([]); readonly selectedStock = signal<VariantStock | null>(null);
  readonly productEditor = signal(false); readonly editingProductId = signal<string | null>(null); readonly editingVariantId = signal<string | null>(null);
  readonly categoryEditor = signal(false); readonly editingCategoryId = signal<string | null>(null);
  readonly articleEditor = signal(false); readonly editingArticleId = signal<string | null>(null);
  readonly articleCategoryEditor = signal(false); readonly editingArticleCategoryId = signal<string | null>(null);
  readonly mediaEditor = signal<Media | null>(null); readonly uploading = signal(false);
  readonly variantEditor = signal(false); readonly editingInventoryVariantId = signal<string | null>(null);
  search = ''; orderStatusFilter = ''; articleStatusFilter = ''; stockSearch = '';
  stockDelta = 0; stockReason = '';
  uploadFile: File | null = null; uploadAlt = ''; uploadCategory: MediaCategory = 'BANNER';
  productImageFile: File | null = null; articleImageFile: File | null = null;
  productCategoryName = ''; productProducerName = ''; articleCategoryName = '';
  mediaDraft = { altText: '', category: 'OTHER' as MediaCategory };
  inventoryVariantDraft = { productId: '', ...this.emptyVariant() };
  assetDrafts = [
    { key: 'home.hero', label: 'Banner trang chủ', mediaId: '' }, { key: 'home.craft', label: 'Ảnh câu chuyện', mediaId: '' },
    { key: 'page.hero', label: 'Banner trang trong', mediaId: '' }, { key: 'auth.visual', label: 'Ảnh đăng nhập', mediaId: '' },
    { key: 'contact.hero', label: 'Banner liên hệ', mediaId: '' },
  ];
  productDraft = this.emptyProduct(); variantDraft = this.emptyVariant(); productMediaId = '';
  categoryDraft = this.emptyCategory();
  articleDraft = this.emptyArticle(); articleCategoryDraft = this.emptyCategory();
  readonly sections: { id: Section; label: string; hint: string; icon: string }[] = [
    { id: 'dashboard', label: 'Tổng quan', hint: 'Tình hình cửa hàng', icon: '⌂' },
    { id: 'products', label: 'Sản phẩm', hint: 'Hàng hóa đang bán', icon: '◆' },
    { id: 'categories', label: 'Danh mục', hint: 'Nhóm hàng và nội dung', icon: '▦' },
    { id: 'orders', label: 'Đơn hàng', hint: 'Tiếp nhận và xử lý', icon: '▤' },
    { id: 'articles', label: 'Bài viết', hint: 'Nội dung website', icon: '✎' },
    { id: 'inventory', label: 'Kho hàng', hint: 'Tồn kho và lịch sử', icon: '▣' },
    { id: 'media', label: 'Ảnh giao diện', hint: 'Banner và ảnh trang', icon: '▧' },
  ];

  ngOnInit(): void { void this.refreshAll(); }
  select(id: Section): void { this.section.set(id); this.sidebarOpen.set(false); this.search = ''; this.error.set(''); window.scrollTo({ top: 0, behavior: 'smooth' }); }
  sectionMeta() { return this.sections.find(item => item.id === this.section()) ?? this.sections[0]; }
  initials(): string { return (this.store.user()?.name ?? 'AD').split(/\s+/).slice(-2).map(value => value[0]).join('').toUpperCase(); }
  newOrderCount(): number { return this.orders().filter(item => item.status === 'NEW').length; }
  lowStockCount(): number { return this.stocks().filter(item => item.stock <= 5).length; }
  reviewCount(): number { return this.articles().filter(item => item.status === 'REVIEW').length; }
  revenue(): number { return this.orders().filter(item => item.status !== 'CANCELLED').reduce((sum, item) => sum + item.totalAmount, 0); }
  filteredProducts(): AdminProduct[] { const q = this.search.trim().toLocaleLowerCase('vi'); return this.products().filter(item => !q || `${item.name} ${item.slug} ${item.category.name}`.toLocaleLowerCase('vi').includes(q)); }
  filteredOrders(): Order[] { const q = this.search.trim().toLocaleLowerCase('vi'); return this.orders().filter(item => (!this.orderStatusFilter || item.status === this.orderStatusFilter) && (!q || `${item.orderNumber} ${item.customerName} ${item.customerPhone}`.toLocaleLowerCase('vi').includes(q))); }
  filteredArticles(): Article[] { const q = this.search.trim().toLocaleLowerCase('vi'); return this.articles().filter(item => (!this.articleStatusFilter || item.status === this.articleStatusFilter) && (!q || item.title.toLocaleLowerCase('vi').includes(q))); }
  filteredStocks(): VariantStock[] { const q = this.stockSearch.trim().toLocaleLowerCase('vi'); return this.stocks().filter(item => !q || `${item.productName} ${item.sku}`.toLocaleLowerCase('vi').includes(q)); }
  filteredMedia(): Media[] { return this.media().filter(item => (item.category === 'BANNER' || item.category === 'OTHER') && (this.mediaFilter() === 'ALL' || item.category === this.mediaFilter())); }
  orderLabel(status: Order['status']): string { return { NEW: 'Đơn mới', CONFIRMED: 'Đã xác nhận', SHIPPING: 'Đang giao', COMPLETED: 'Hoàn thành', CANCELLED: 'Đã hủy' }[status]; }
  articleLabel(status: ArticleStatus): string { return { DRAFT: 'Bản nháp', REVIEW: 'Chờ duyệt', PUBLISHED: 'Đã xuất bản', ARCHIVED: 'Lưu trữ' }[status]; }
  mediaCategoryLabel(value: MediaCategory): string { return { BANNER: 'Banner', PRODUCT: 'Sản phẩm', ARTICLE: 'Bài viết', OTHER: 'Khác' }[value]; }
  movementLabel(value: string): string { return { OPENING: 'Số dư đầu', ADJUSTMENT: 'Điều chỉnh', ORDER_PLACED: 'Đặt hàng', ORDER_CANCELLED: 'Hoàn đơn' }[value] ?? value; }

  async refreshAll(): Promise<void> {
    this.loading.set(true); this.error.set('');
    try {
      const [products, categories, producers, articles, articleCategories, media, stocks, orders] = await Promise.all([
        firstValueFrom(this.http.get<Page<AdminProduct>>('/api/v1/admin/products?size=100')),
        firstValueFrom(this.http.get<Category[]>('/api/v1/admin/categories')),
        firstValueFrom(this.http.get<Producer[]>('/api/v1/admin/producers')),
        firstValueFrom(this.http.get<Page<Article>>('/api/v1/admin/articles?size=100')),
        firstValueFrom(this.http.get<ArticleCategory[]>('/api/v1/admin/article-categories')),
        firstValueFrom(this.http.get<Page<Media>>('/api/v1/admin/media?size=100')),
        firstValueFrom(this.http.get<VariantStock[]>('/api/v1/admin/inventory/variants')),
        firstValueFrom(this.http.get<Order[]>('/api/v1/admin/orders')),
      ]);
      this.products.set(products.items); this.categories.set(categories); this.producers.set(producers);
      this.articles.set(articles.items); this.articleCategories.set(articleCategories); this.media.set(media.items);
      this.stocks.set(stocks); this.orders.set(orders);
      for (const asset of this.assetDrafts) asset.mediaId = media.items.find(item => item.url === this.store.assets()[asset.key])?.id ?? '';
    } catch (response: unknown) { this.error.set(this.problem(response, 'Không tải được dữ liệu quản trị.')); }
    finally { this.loading.set(false); }
  }

  openNewProduct(): void { this.editingProductId.set(null); this.editingVariantId.set(null); this.productDraft = this.emptyProduct(); this.variantDraft = this.emptyVariant(); this.productMediaId = ''; this.productImageFile = null; this.productCategoryName = ''; this.productProducerName = ''; this.productEditor.set(true); }
  async editProduct(id: string): Promise<void> { this.error.set(''); try { const detail = await firstValueFrom(this.http.get<ProductDetail>(`/api/v1/admin/products/${id}`)); this.editingProductId.set(id); this.productDraft = { categoryId: detail.category.id, producerId: detail.producer?.id ?? '', name: detail.name, slug: detail.slug, shortDescription: detail.shortDescription ?? '', description: detail.description, storageInstructions: detail.storageInstructions ?? '', origin: detail.origin ?? '', status: detail.status, seoTitle: detail.seoTitle ?? '', seoDescription: detail.seoDescription ?? '' }; this.productCategoryName = detail.category.name; this.productProducerName = detail.producer?.name ?? ''; const variant = detail.variants[0]; this.editingVariantId.set(variant?.id ?? null); this.variantDraft = variant ? { sku: variant.sku, barcode: variant.barcode ?? '', volumeMl: variant.volumeMl, alcoholPercent: variant.alcoholPercent, price: variant.price, comparePrice: variant.comparePrice, weightGram: variant.weightGram, status: variant.status } : this.emptyVariant(); this.productMediaId = detail.images.find(item => item.primary)?.id ?? ''; this.productImageFile = null; this.productEditor.set(true); } catch (response) { this.error.set(this.problem(response, 'Không tải được sản phẩm.')); } }
  closeProductEditor(): void { this.productEditor.set(false); this.editingProductId.set(null); this.productImageFile = null; }
  onProductImageSelected(event: Event): void { this.productImageFile = (event.target as HTMLInputElement).files?.[0] ?? null; }
  async saveProduct(): Promise<void> {
    if (!this.productDraft.name.trim() || !this.productCategoryName.trim() || !this.productDraft.description.trim() || Number(this.variantDraft.price) <= 0) { this.error.set('Vui lòng nhập tên, danh mục, mô tả và giá bán hợp lệ.'); return; }
    this.saving.set(true); this.error.set('');
    try {
      this.productDraft.categoryId = await this.resolveProductCategory(this.productCategoryName);
      this.productDraft.producerId = await this.resolveProducer(this.productProducerName);
      if (!this.editingProductId()) this.productDraft.slug = this.slugify(this.productDraft.name);
      if (!this.variantDraft.sku) this.variantDraft.sku = this.autoSku(this.productDraft.name, this.variantDraft.volumeMl);
      const product = this.editingProductId() ? await firstValueFrom(this.http.patch<ProductDetail>(`/api/v1/admin/products/${this.editingProductId()}`, this.productPayload())) : await firstValueFrom(this.http.post<ProductDetail>('/api/v1/admin/products', this.productPayload()));
      const variantPayload = { productId: product.id, ...this.variantDraft, barcode: null, comparePrice: null };
      if (this.editingVariantId()) await firstValueFrom(this.http.patch(`/api/v1/admin/variants/${this.editingVariantId()}`, variantPayload)); else await firstValueFrom(this.http.post('/api/v1/admin/variants', variantPayload));
      if (this.productImageFile) { const image = await this.uploadContextImage(this.productImageFile, this.productDraft.name, 'PRODUCT'); await firstValueFrom(this.http.post(`/api/v1/admin/products/${product.id}/images`, { mediaId: image.id, sortOrder: 0, primary: true })); }
      this.store.notify(this.editingProductId() ? 'Đã cập nhật sản phẩm' : 'Đã thêm sản phẩm'); this.closeProductEditor(); await Promise.all([this.store.loadShowcase(), this.refreshAll()]);
    } catch (response) { this.error.set(this.problem(response, 'Không lưu được sản phẩm.')); } finally { this.saving.set(false); }
  }
  async deleteProduct(product: AdminProduct): Promise<void> { if (!confirm(`Lưu trữ sản phẩm “${product.name}”? Sản phẩm sẽ không còn hiển thị với khách.`)) return; await this.perform(() => firstValueFrom(this.http.delete(`/api/v1/admin/products/${product.id}`)), 'Đã lưu trữ sản phẩm'); }

  openCategory(category?: Category): void { this.editingCategoryId.set(category?.id ?? null); this.categoryDraft = category ? { name: category.name, slug: category.slug, description: category.description ?? '', status: category.status, sortOrder: category.sortOrder } : { ...this.emptyCategory(), sortOrder: this.categories().length }; this.categoryEditor.set(true); }
  async saveCategory(): Promise<void> { if (!this.categoryDraft.name.trim()) { this.error.set('Tên danh mục là bắt buộc.'); return; } this.categoryDraft.slug = this.slugify(this.categoryDraft.name); const id = this.editingCategoryId(); await this.perform(() => id ? firstValueFrom(this.http.patch(`/api/v1/admin/categories/${id}`, this.categoryDraft)) : firstValueFrom(this.http.post('/api/v1/admin/categories', this.categoryDraft)), id ? 'Đã cập nhật danh mục' : 'Đã thêm danh mục', () => this.categoryEditor.set(false)); }
  async deleteCategory(category: Category): Promise<void> { if (!confirm(`Xóa danh mục “${category.name}”?`)) return; await this.perform(() => firstValueFrom(this.http.delete(`/api/v1/admin/categories/${category.id}`)), 'Đã xóa danh mục'); }

  openOrder(order: Order): void { this.selectedOrder.set(order); }
  async updateOrderStatus(order: Order, status: Order['status']): Promise<void> { await this.perform(() => firstValueFrom(this.http.patch<Order>(`/api/v1/admin/orders/${order.id}/status`, { status })), 'Đã cập nhật trạng thái đơn', updated => this.selectedOrder.set(updated as Order)); }
  async archiveOrder(order: Order): Promise<void> { if (!confirm(`Lưu trữ đơn ${order.orderNumber}?`)) return; await this.perform(() => firstValueFrom(this.http.delete(`/api/v1/admin/orders/${order.id}`)), 'Đã lưu trữ đơn', () => this.selectedOrder.set(null)); }

  openNewArticle(): void { this.editingArticleId.set(null); this.articleDraft = this.emptyArticle(); this.articleCategoryName = ''; this.articleImageFile = null; this.articleEditor.set(true); }
  async editArticle(article: Article): Promise<void> { try { const detail = await firstValueFrom(this.http.get<ArticleDetail>(`/api/v1/admin/articles/${article.id}`)); this.editingArticleId.set(article.id); this.articleDraft = { categoryId: detail.category.id, featuredMediaId: detail.featuredMedia?.id ?? '', title: detail.title, slug: detail.slug, excerpt: detail.excerpt, content: detail.content, seoTitle: detail.seoTitle ?? '', seoDescription: detail.seoDescription ?? '' }; this.articleCategoryName = detail.category.name; this.articleImageFile = null; this.articleEditor.set(true); } catch (response) { this.error.set(this.problem(response, 'Không tải được bài viết.')); } }
  onArticleImageSelected(event: Event): void { this.articleImageFile = (event.target as HTMLInputElement).files?.[0] ?? null; }
  async saveArticle(): Promise<void> {
    if (!this.articleDraft.title.trim() || !this.articleCategoryName.trim() || !this.articleDraft.excerpt.trim() || !this.articleDraft.content.trim()) { this.error.set('Vui lòng nhập tiêu đề, chuyên mục, tóm tắt và nội dung bài viết.'); return; }
    this.saving.set(true); this.error.set('');
    try {
      this.articleDraft.categoryId = await this.resolveArticleCategory(this.articleCategoryName);
      if (!this.editingArticleId()) this.articleDraft.slug = this.slugify(this.articleDraft.title);
      if (this.articleImageFile) this.articleDraft.featuredMediaId = (await this.uploadContextImage(this.articleImageFile, this.articleDraft.title, 'ARTICLE')).id;
      const id = this.editingArticleId();
      if (id) await firstValueFrom(this.http.patch(`/api/v1/admin/articles/${id}`, this.articleDraft)); else await firstValueFrom(this.http.post('/api/v1/admin/articles', this.articleDraft));
      this.store.notify(id ? 'Đã cập nhật bài viết' : 'Đã tạo bản nháp'); this.articleEditor.set(false); await Promise.all([this.store.loadShowcase(), this.refreshAll()]);
    } catch (response) { this.error.set(this.problem(response, 'Không lưu được bài viết.')); } finally { this.saving.set(false); }
  }
  async articleTransition(article: Article, action: 'submit-review' | 'publish' | 'archive'): Promise<void> { await this.perform(() => firstValueFrom(this.http.post(`/api/v1/admin/articles/${article.id}/${action}`, {})), 'Đã cập nhật trạng thái bài viết'); }
  async deleteArticle(article: Article): Promise<void> { if (!confirm(`Xóa bài viết “${article.title}”?`)) return; await this.perform(() => firstValueFrom(this.http.delete(`/api/v1/admin/articles/${article.id}`)), 'Đã xóa bài viết'); }
  openArticleCategory(category?: ArticleCategory): void { this.editingArticleCategoryId.set(category?.id ?? null); this.articleCategoryDraft = category ? { name: category.name, slug: category.slug, description: category.description ?? '', status: category.status, sortOrder: category.sortOrder } : { ...this.emptyCategory(), sortOrder: this.articleCategories().length }; this.articleCategoryEditor.set(true); }
  async saveArticleCategory(): Promise<void> { if (!this.articleCategoryDraft.name.trim()) { this.error.set('Tên chuyên mục là bắt buộc.'); return; } this.articleCategoryDraft.slug = this.slugify(this.articleCategoryDraft.name); const id = this.editingArticleCategoryId(); await this.perform(() => id ? firstValueFrom(this.http.patch(`/api/v1/admin/article-categories/${id}`, this.articleCategoryDraft)) : firstValueFrom(this.http.post('/api/v1/admin/article-categories', this.articleCategoryDraft)), id ? 'Đã cập nhật chuyên mục' : 'Đã thêm chuyên mục', () => this.articleCategoryEditor.set(false)); }
  async deleteArticleCategory(category: ArticleCategory): Promise<void> { if (!confirm(`Xóa chuyên mục “${category.name}”?`)) return; await this.perform(() => firstValueFrom(this.http.delete(`/api/v1/admin/article-categories/${category.id}`)), 'Đã xóa chuyên mục'); }

  async chooseStock(stock: VariantStock): Promise<void> { this.selectedStock.set(stock); this.stockDelta = 0; this.stockReason = ''; try { this.movements.set(await firstValueFrom(this.http.get<StockMovement[]>(`/api/v1/admin/inventory/variants/${stock.id}/movements`))); } catch (response) { this.error.set(this.problem(response, 'Không tải được lịch sử kho.')); } }
  async adjustStock(): Promise<void> { const stock = this.selectedStock(); if (!stock || !this.stockDelta || this.stockReason.trim().length < 5) { this.error.set('Nhập số lượng khác 0 và lý do ít nhất 5 ký tự.'); return; } await this.perform(() => firstValueFrom(this.http.post(`/api/v1/admin/inventory/variants/${stock.id}/adjustments`, { delta: Number(this.stockDelta), reason: this.stockReason.trim() })), 'Đã cập nhật tồn kho', () => this.chooseStock({ ...stock, stock: stock.stock + Number(this.stockDelta) })); }
  async deleteVariant(stock: VariantStock): Promise<void> { if (!confirm(`Xóa SKU ${stock.sku} khỏi kho?`)) return; await this.perform(() => firstValueFrom(this.http.delete(`/api/v1/admin/variants/${stock.id}`)), 'Đã xóa SKU', () => this.selectedStock.set(null)); }
  openNewVariant(): void { this.editingInventoryVariantId.set(null); this.inventoryVariantDraft = { productId: this.products()[0]?.id ?? '', ...this.emptyVariant() }; this.variantEditor.set(true); }
  async editInventoryVariant(stock: VariantStock): Promise<void> { try { const product = await firstValueFrom(this.http.get<ProductDetail>(`/api/v1/admin/products/${stock.productId}`)); const variant = product.variants.find(item => item.id === stock.id); if (!variant) throw new Error('VARIANT_NOT_FOUND'); this.editingInventoryVariantId.set(variant.id); this.inventoryVariantDraft = { productId: product.id, sku: variant.sku, barcode: variant.barcode ?? '', volumeMl: variant.volumeMl, alcoholPercent: variant.alcoholPercent, price: variant.price, comparePrice: variant.comparePrice, weightGram: variant.weightGram, status: variant.status }; this.variantEditor.set(true); } catch (response) { this.error.set(this.problem(response, 'Không tải được thông tin SKU.')); } }
  async saveInventoryVariant(): Promise<void> { const id = this.editingInventoryVariantId(); const product = this.products().find(item => item.id === this.inventoryVariantDraft.productId); if (!product || Number(this.inventoryVariantDraft.price) <= 0) { this.error.set('Hãy chọn sản phẩm và nhập giá bán hợp lệ.'); return; } if (!this.inventoryVariantDraft.sku) this.inventoryVariantDraft.sku = this.autoSku(product.name, this.inventoryVariantDraft.volumeMl, true); const payload = { ...this.inventoryVariantDraft, barcode: null, comparePrice: null }; await this.perform(() => id ? firstValueFrom(this.http.patch(`/api/v1/admin/variants/${id}`, payload)) : firstValueFrom(this.http.post('/api/v1/admin/variants', payload)), id ? 'Đã cập nhật thông tin bán hàng' : 'Đã thêm biến thể', () => this.variantEditor.set(false)); }

  onFileSelected(event: Event): void { this.uploadFile = (event.target as HTMLInputElement).files?.[0] ?? null; if (this.uploadFile && !this.uploadAlt) this.uploadAlt = this.uploadFile.name.replace(/\.[^.]+$/, '').replace(/[-_]+/g, ' '); }
  async uploadMedia(): Promise<void> { if (!this.uploadFile || !this.uploadAlt.trim()) { this.error.set('Chọn ảnh từ máy và nhập mô tả ảnh.'); return; } this.uploading.set(true); this.error.set(''); try { const body = new FormData(); body.append('file', this.uploadFile); body.append('altText', this.uploadAlt.trim()); body.append('category', this.uploadCategory); await firstValueFrom(this.http.post('/api/v1/admin/media/upload', body)); this.store.notify('Đã tải ảnh lên thư viện'); this.uploadFile = null; this.uploadAlt = ''; await this.refreshAll(); } catch (response) { this.error.set(this.problem(response, 'Không tải được ảnh. Chỉ nhận JPG, PNG, WebP hoặc AVIF tối đa 10 MB.')); } finally { this.uploading.set(false); } }
  editMedia(item: Media): void { this.mediaDraft = { altText: item.altText, category: item.category }; this.mediaEditor.set(item); }
  async saveMedia(): Promise<void> { const item = this.mediaEditor(); if (!item) return; await this.perform(() => firstValueFrom(this.http.patch(`/api/v1/admin/media/${item.id}/metadata`, this.mediaDraft)), 'Đã cập nhật ảnh', () => this.mediaEditor.set(null)); }
  async deleteMedia(item: Media): Promise<void> { if (!confirm(`Xóa ảnh “${item.altText}”?`)) return; await this.perform(() => firstValueFrom(this.http.delete(`/api/v1/admin/media/${item.id}`)), 'Đã xóa ảnh'); }
  async saveAsset(asset: { key: string; label: string; mediaId: string }): Promise<void> { if (!asset.mediaId) { this.error.set('Hãy chọn ảnh banner từ thư viện.'); return; } await this.perform(() => firstValueFrom(this.http.put(`/api/v1/admin/site-assets/${asset.key}`, { mediaId: asset.mediaId })), `Đã cập nhật ${asset.label}`, () => this.store.loadShowcase()); }

  mediaUrl(id: string): string { return this.media().find(item => item.id === id)?.url ?? ''; }

  private async resolveProductCategory(name: string): Promise<string> {
    const normalized = name.trim().toLocaleLowerCase('vi');
    const existing = this.categories().find(item => item.name.trim().toLocaleLowerCase('vi') === normalized);
    if (existing) return existing.id;
    const created = await firstValueFrom(this.http.post<Category>('/api/v1/admin/categories', { name: name.trim(), slug: this.slugify(name), description: null, status: 'ACTIVE', sortOrder: this.categories().length }));
    this.categories.update(items => [...items, created]); return created.id;
  }

  private async resolveArticleCategory(name: string): Promise<string> {
    const normalized = name.trim().toLocaleLowerCase('vi');
    const existing = this.articleCategories().find(item => item.name.trim().toLocaleLowerCase('vi') === normalized);
    if (existing) return existing.id;
    const created = await firstValueFrom(this.http.post<ArticleCategory>('/api/v1/admin/article-categories', { name: name.trim(), slug: this.slugify(name), description: null, status: 'ACTIVE', sortOrder: this.articleCategories().length }));
    this.articleCategories.update(items => [...items, created]); return created.id;
  }

  private async resolveProducer(name: string): Promise<string> {
    if (!name.trim()) return '';
    const normalized = name.trim().toLocaleLowerCase('vi');
    const existing = this.producers().find(item => item.name.trim().toLocaleLowerCase('vi') === normalized);
    if (existing) return existing.id;
    const created = await firstValueFrom(this.http.post<Producer>('/api/v1/admin/producers', { name: name.trim(), legalName: null, origin: this.productDraft.origin || null, contact: null, status: 'ACTIVE' }));
    this.producers.update(items => [...items, created]); return created.id;
  }

  private async uploadContextImage(file: File, altText: string, category: 'PRODUCT' | 'ARTICLE'): Promise<Media> {
    const body = new FormData(); body.append('file', file); body.append('altText', altText.trim()); body.append('category', category);
    return firstValueFrom(this.http.post<Media>('/api/v1/admin/media/upload', body));
  }

  private slugify(value: string): string {
    return value.normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/đ/g, 'd').replace(/Đ/g, 'D').toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '').slice(0, 180) || `muc-${Date.now()}`;
  }

  private autoSku(name: string, volume: number, unique = false): string {
    const base = this.slugify(name).replace(/-/g, '_').toUpperCase().slice(0, 55);
    return `${base}_${volume}ML${unique ? `_${Date.now().toString().slice(-5)}` : ''}`;
  }

  private async perform(action: () => Promise<unknown>, success: string, after?: (value?: unknown) => void | Promise<void>): Promise<void> { this.saving.set(true); this.error.set(''); try { const result = await action(); this.store.notify(success); await after?.(result); await this.refreshAll(); } catch (response) { this.error.set(this.problem(response, 'Thao tác chưa thành công.')); } finally { this.saving.set(false); } }
  private problem(response: unknown, fallback: string): string { return (response as { error?: { detail?: string } })?.error?.detail ?? fallback; }
  private productPayload() { return { ...this.productDraft, producerId: this.productDraft.producerId || null, shortDescription: this.productDraft.shortDescription || null, storageInstructions: this.productDraft.storageInstructions || null, origin: this.productDraft.origin || null, seoTitle: this.productDraft.seoTitle || null, seoDescription: this.productDraft.seoDescription || null }; }
  private emptyProduct() { return { categoryId: '', producerId: '', name: '', slug: '', shortDescription: '', description: '', storageInstructions: '', origin: '', status: 'ACTIVE' as PublicationStatus, seoTitle: '', seoDescription: '' }; }
  private emptyVariant() { return { sku: '', barcode: '', volumeMl: 500, alcoholPercent: 40, price: 0, comparePrice: null as number | null, weightGram: 900, status: 'ACTIVE' as PublicationStatus }; }
  private emptyCategory() { return { name: '', slug: '', description: '', status: 'ACTIVE' as PublicationStatus, sortOrder: 0 }; }
  private emptyArticle() { return { categoryId: '', featuredMediaId: '', title: '', slug: '', excerpt: '', content: '', seoTitle: '', seoDescription: '' }; }
}
