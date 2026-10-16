import { TestBed } from '@angular/core/testing';
import { provideHttpClient } from '@angular/common/http';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import { StoreService } from './store.service';
import { PRODUCTS } from './mock-data';
import { Product } from './models';

describe('StoreService', () => {
  let store: StoreService;

  beforeEach(async () => {
    localStorage.clear();
    TestBed.configureTestingModule({ providers: [provideHttpClient(), provideHttpClientTesting()] });
    store = TestBed.inject(StoreService);
    const login = store.login('khach@example.com', 'correct-password');
    TestBed.inject(HttpTestingController).expectOne('/api/v1/auth/login').flush({
      accessToken: 'signed-test-token', accessTokenExpiresAt: '2099-01-01T00:00:00Z',
      user: { id: 'user-1', email: 'khach@example.com', fullName: 'Khách thử nghiệm', roles: ['CUSTOMER'], permissions: [] },
    });
    await login;
    store.products.set([{ ...PRODUCTS[0], id: 'product-1', sku: 'RXN-001' } as Product]);
  });

  afterEach(() => { TestBed.inject(HttpTestingController).verify(); localStorage.clear(); });

  it('removes a cart line when its quantity reaches zero', () => {
    const product = store.products()[0];
    store.addToCart(product);

    store.updateQuantity(product.id, 0);

    expect(store.cart()).toEqual([]);
    expect(localStorage.getItem('ruou-cart')).toBe('[]');
  });

  it('never increases quantity beyond available stock', () => {
    const product = store.products()[0];
    store.addToCart(product);

    store.updateQuantity(product.id, product.stock + 20);

    expect(store.cart()[0].quantity).toBe(product.stock);
  });

  it('calculates the cart total without a client-side demo discount or order', () => {
    store.addToCart(store.products()[0], 2);
    expect(store.subtotal()).toBe(store.products()[0].price * 2);
    expect(localStorage.getItem('ruou-orders')).toBeNull();
  });

  it('uses roles returned by the server instead of inferring admin from email', async () => {
    const login = store.login('admin-looking@example.com', 'correct-password');
    TestBed.inject(HttpTestingController).expectOne('/api/v1/auth/login').flush({
      accessToken: 'customer-token', accessTokenExpiresAt: '2099-01-01T00:00:00Z',
      user: { id: 'user-2', email: 'admin-looking@example.com', fullName: 'Khách hàng', roles: ['CUSTOMER'], permissions: [] },
    });
    await login;
    expect(store.user()?.role).toBe('CUSTOMER');
    expect(localStorage.getItem('ruou-user')).toBeNull();
  });

  it('updates the profile only after the backend confirms it', async () => {
    const updating = store.updateProfile('Tên mới', '0901234567');
    expect(store.user()?.name).toBe('Khách thử nghiệm');
    const request = TestBed.inject(HttpTestingController).expectOne('/api/v1/me');
    expect(request.request.method).toBe('PATCH');
    request.flush({ fullName: 'Tên mới', phone: '0901234567' });
    await updating;
    expect(store.user()?.name).toBe('Tên mới');
    expect(store.user()?.phone).toBe('0901234567');
  });

  it('loads products, stories and banner from the API', async () => {
    const product = store.products()[0];
    const loading = store.loadShowcase();
    TestBed.inject(HttpTestingController).expectOne('/api/v1/showcase').flush({
      products: [product], stories: [{ id: 'story-1', slug: 'lang-nghe', title: 'Làng nghề', excerpt: '',
        category: 'Làng nghề', image: 'https://example.test/story.jpg', author: 'Ban biên tập',
        publishedAt: '15.10.2026', readTime: 5, featured: true, content: ['Nội dung'] }],
      assets: { 'home.hero': 'https://example.test/hero.jpg' },
    });
    await loading;
    expect(store.showcaseStatus()).toBe('ready');
    expect(store.products()[0].name).toBe(product.name);
    expect(store.stories()[0].title).toBe('Làng nghề');
    expect(document.documentElement.style.getPropertyValue('--home-hero-image')).toContain('hero.jpg');
  });
});
