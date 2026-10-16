import { HttpClient, provideHttpClient, withInterceptors } from '@angular/common/http';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import { TestBed } from '@angular/core/testing';
import { firstValueFrom } from 'rxjs';
import { apiAuthInterceptor } from './api-auth.interceptor';
import { StoreService } from './store.service';

describe('apiAuthInterceptor', () => {
  let store: StoreService;
  let http: HttpClient;
  let requests: HttpTestingController;

  beforeEach(() => {
    localStorage.clear();
    TestBed.configureTestingModule({ providers: [
      provideHttpClient(withInterceptors([apiAuthInterceptor])), provideHttpClientTesting(),
    ] });
    store = TestBed.inject(StoreService);
    http = TestBed.inject(HttpClient);
    requests = TestBed.inject(HttpTestingController);
  });
  afterEach(() => { requests.verify(); localStorage.clear(); });

  it('refreshes an expired session before a protected admin request', async () => {
    const login = store.login('admin@example.test', 'test-password');
    requests.expectOne('/api/v1/auth/login').flush({
      accessToken: 'expired-token', accessTokenExpiresAt: '2000-01-01T00:00:00Z',
      user: { id: 'admin-1', email: 'admin@example.test', fullName: 'Admin', roles: ['ADMIN'], permissions: ['ADMIN_ACCESS'] },
    });
    await login;

    const loading = firstValueFrom(http.get('/api/v1/admin/articles'));
    requests.expectOne('/api/v1/auth/refresh').flush({
      accessToken: 'fresh-token', accessTokenExpiresAt: '2099-01-01T00:00:00Z',
      user: { id: 'admin-1', email: 'admin@example.test', fullName: 'Admin', roles: ['ADMIN'], permissions: ['ADMIN_ACCESS'] },
    });
    await new Promise(resolve => setTimeout(resolve, 0));
    const admin = requests.expectOne('/api/v1/admin/articles');
    expect(admin.request.headers.get('Authorization')).toBe('Bearer fresh-token');
    admin.flush({ items: [] });
    await loading;
  });
});
