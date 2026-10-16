import { DOCUMENT } from '@angular/common';
import { computed, inject, Injectable, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { firstValueFrom } from 'rxjs';
import { CartItem, CreateOrderPayload, Order, Product, User } from './models';

@Injectable({ providedIn: 'root' })
export class StoreService {
  private readonly document = inject(DOCUMENT);
  private readonly http = inject(HttpClient);
  readonly products = signal<Product[]>([]);
  readonly stories = signal<import('./models').Story[]>([]);
  readonly assets = signal<Record<string, string>>({});
  readonly showcaseStatus = signal<'loading' | 'ready' | 'error'>('loading');
  readonly user = signal<User | null>(null);
  readonly accessToken = signal<string | null>(null);
  private accessTokenExpiresAt = 0;
  private restorePromise: Promise<boolean> | null = null;
  readonly cart = signal<CartItem[]>(this.read<CartItem[]>('ruou-cart') ?? []);
  readonly theme = signal<'light' | 'dark'>((localStorage.getItem('ruou-theme') as 'light' | 'dark') ?? 'light');
  readonly ageVerified = signal(localStorage.getItem('ruou-age') === 'yes');
  readonly toast = signal('');
  readonly isAuthenticated = computed(() => !!this.user() && !!this.accessToken());
  readonly cartCount = computed(() => this.cart().reduce((sum, item) => sum + item.quantity, 0));
  readonly subtotal = computed(() => this.cart().reduce((sum, item) => sum + item.product.price * item.quantity, 0));
  readonly featuredProducts = computed(() => this.products().filter(product => product.featured));

  constructor() { this.applyTheme(); }
  async loadShowcase(): Promise<void> {
    this.showcaseStatus.set('loading');
    try {
      const response = await firstValueFrom(this.http.get<ShowcasePayload>('/api/v1/showcase'));
      this.products.set(response.products);
      this.stories.set(response.stories);
      this.assets.set(response.assets);
      for (const [key, variable] of Object.entries({
        'home.hero': '--home-hero-image', 'page.hero': '--page-hero-image',
        'auth.visual': '--auth-visual-image', 'contact.hero': '--contact-hero-image',
      })) {
        const url = response.assets[key];
        if (url) this.document.documentElement.style.setProperty(variable, `url("${url.replaceAll('"', '%22')}")`);
      }
      this.reconcileCart();
      this.showcaseStatus.set('ready');
    } catch {
      this.showcaseStatus.set('error');
    }
  }
  confirmAge(): void { localStorage.setItem('ruou-age', 'yes'); this.ageVerified.set(true); }
  toggleTheme(): void { this.theme.update(value => value === 'light' ? 'dark' : 'light'); localStorage.setItem('ruou-theme', this.theme()); this.applyTheme(); }
  async login(email: string, password: string): Promise<void> {
    const session = await firstValueFrom(this.http.post<AuthSession>('/api/v1/auth/login', { email, password }, { withCredentials: true }));
    this.acceptSession(session);
    this.notify(`Xin chào, ${session.user.fullName}`);
  }
  async register(email: string, password: string, fullName: string, ageConfirmed: boolean): Promise<void> {
    const session = await firstValueFrom(this.http.post<AuthSession>('/api/v1/auth/register', { email, password, fullName, ageConfirmed }, { withCredentials: true }));
    this.acceptSession(session);
    this.notify(`Xin chào, ${session.user.fullName}`);
  }
  async forgotPassword(email: string): Promise<void> {
    await firstValueFrom(this.http.post('/api/v1/auth/forgot-password', { email }));
  }
  async updateProfile(fullName: string, phone: string): Promise<void> {
    const result = await firstValueFrom(this.http.patch<{ fullName: string; phone: string | null }>(
      '/api/v1/me', { fullName: fullName.trim(), phone: phone.trim() || null }));
    this.user.update(current => current ? { ...current, name: result.fullName, phone: result.phone } : null);
    this.notify('Đã lưu hồ sơ vào database');
  }
  async placeOrder(delivery: Omit<CreateOrderPayload, 'items'>): Promise<Order> {
    if (!this.cart().length) throw new Error('EMPTY_CART');
    const order = await firstValueFrom(this.http.post<Order>('/api/v1/orders', {
      ...delivery,
      items: this.cart().map(item => ({ variantId: item.product.variantId, quantity: item.quantity })),
    }));
    this.cart.set([]);
    this.persist('ruou-cart', []);
    await this.loadShowcase();
    this.notify(`Đã tạo đơn ${order.orderNumber}`);
    return order;
  }
  async myOrders(): Promise<Order[]> {
    return firstValueFrom(this.http.get<Order[]>('/api/v1/orders'));
  }
  async ensureSession(forceRefresh = false): Promise<boolean> {
    if (!forceRefresh && this.isAuthenticated() && Date.now() < this.accessTokenExpiresAt - 30_000) return true;
    if (!this.restorePromise) {
      this.restorePromise = firstValueFrom(this.http.post<AuthSession>('/api/v1/auth/refresh', {}, { withCredentials: true }))
        .then(session => { this.acceptSession(session); return true; })
        .catch(() => { this.clearSession(); return false; })
        .finally(() => { this.restorePromise = null; });
    }
    return this.restorePromise;
  }
  async logout(): Promise<void> {
    try {
      await firstValueFrom(this.http.post('/api/v1/auth/logout', {}, { withCredentials: true }));
    } finally {
      this.clearSession();
      this.notify('Bạn đã đăng xuất');
    }
  }
  addToCart(product: Product, quantity = 1): boolean { if (!this.isAuthenticated()) return false; if (product.stock <= 0) { this.notify('Sản phẩm hiện đã hết hàng'); return true; } const items = this.cart().map(item => ({ ...item })); const existing = items.find(item => item.product.id === product.id); if (existing && existing.quantity >= product.stock) { this.notify(`Chỉ còn ${product.stock} sản phẩm trong kho`); return true; } if (existing) existing.quantity = Math.min(existing.quantity + quantity, product.stock); else items.push({ product, quantity: Math.max(1, Math.min(quantity, product.stock)) }); this.cart.set(items); this.persist('ruou-cart', items); this.notify(`Đã thêm ${product.name} vào giỏ`); return true; }
  updateQuantity(productId: string, quantity: number): void { if (quantity <= 0) { this.removeFromCart(productId); return; } const item = this.cart().find(entry => entry.product.id === productId); if (!item) return; const safeQuantity = Math.min(quantity, item.product.stock); if (quantity > item.product.stock) this.notify(`Chỉ còn ${item.product.stock} sản phẩm trong kho`); const items = this.cart().map(entry => entry.product.id === productId ? { ...entry, quantity: safeQuantity } : entry); this.cart.set(items); this.persist('ruou-cart', items); }
  removeFromCart(productId: string): void { const items = this.cart().filter(item => item.product.id !== productId); this.cart.set(items); this.persist('ruou-cart', items); this.notify('Đã xóa sản phẩm khỏi giỏ'); }
  notify(message: string): void { this.toast.set(message); window.setTimeout(() => { if (this.toast() === message) this.toast.set(''); }, 2800); }
  formatPrice(price: number): string { return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(price); }
  private reconcileCart(): void {
    const reconciled = this.cart().flatMap(item => {
      const product = this.products().find(entry => entry.id === item.product.id);
      if (!product || product.stock <= 0) return [];
      return [{ product, quantity: Math.max(1, Math.min(item.quantity, product.stock)) }];
    });
    if (JSON.stringify(reconciled) !== JSON.stringify(this.cart())) { this.cart.set(reconciled); this.persist('ruou-cart', reconciled); }
  }
  private applyTheme(): void { this.document.documentElement.dataset['theme'] = this.theme(); }
  private read<T>(key: string): T | null { try { const value = localStorage.getItem(key); return value ? JSON.parse(value) as T : null; } catch { return null; } }
  private persist(key: string, value: unknown): void { localStorage.setItem(key, JSON.stringify(value)); }
  private acceptSession(session: AuthSession): void {
    this.accessToken.set(session.accessToken);
    this.accessTokenExpiresAt = Date.parse(session.accessTokenExpiresAt);
    this.user.set({
      id: session.user.id,
      name: session.user.fullName,
      email: session.user.email,
      phone: session.user.phone ?? null,
      role: session.user.roles.includes('ADMIN') ? 'ADMIN' : 'CUSTOMER',
      permissions: session.user.permissions,
    });
    localStorage.removeItem('ruou-user');
  }
  private clearSession(): void {
    this.accessToken.set(null);
    this.accessTokenExpiresAt = 0;
    this.user.set(null);
    this.cart.set([]);
    this.persist('ruou-cart', []);
    localStorage.removeItem('ruou-user');
  }
}

interface AuthSession {
  accessToken: string;
  accessTokenExpiresAt: string;
  user: { id: string; email: string; fullName: string; phone?: string | null; roles: string[]; permissions: string[] };
}

interface ShowcasePayload {
  products: Product[];
  stories: import('./models').Story[];
  assets: Record<string, string>;
}
