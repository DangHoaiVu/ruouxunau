import { TestBed } from '@angular/core/testing';
import { provideRouter } from '@angular/router';
import { provideHttpClient } from '@angular/common/http';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import { App } from './app';

describe('App', () => {
  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [App],
      providers: [provideRouter([]), provideHttpClient(), provideHttpClientTesting()],
    })
      .compileComponents();
  });

  it('should create the app', () => {
    const fixture = TestBed.createComponent(App);
    TestBed.inject(HttpTestingController).expectOne('/api/v1/auth/refresh').flush({}, { status: 401, statusText: 'Unauthorized' });
    TestBed.inject(HttpTestingController).expectOne('/api/v1/showcase').flush({ products: [], stories: [], assets: {} });
    const app = fixture.componentInstance;
    expect(app).toBeTruthy();
  });

  it('should render the brand', async () => {
    const fixture = TestBed.createComponent(App);
    TestBed.inject(HttpTestingController).expectOne('/api/v1/auth/refresh').flush({}, { status: 401, statusText: 'Unauthorized' });
    TestBed.inject(HttpTestingController).expectOne('/api/v1/showcase').flush({ products: [], stories: [], assets: {} });
    await fixture.whenStable();
    const compiled = fixture.nativeElement as HTMLElement;
    expect(compiled.querySelector('.brand strong')?.textContent).toContain('Rượu Xứ Nẫu');
  });
});
