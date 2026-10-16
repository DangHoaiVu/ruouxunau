import { Component, HostListener, inject, signal } from '@angular/core';
import { NavigationEnd, Router, RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';
import { StoreService } from './core/store.service';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, RouterLink, RouterLinkActive],
  styleUrl: './app.scss',
  templateUrl: './app.html',
})
export class App {
  readonly store = inject(StoreService);
  private readonly router = inject(Router);
  readonly scrolled = signal(false);
  readonly searchOpen = signal(false);
  readonly menuOpen = signal(false);
  readonly adminMode = signal(location.pathname.startsWith('/admin'));

  constructor() {
    void this.store.ensureSession();
    void this.store.loadShowcase();
    this.router.events.subscribe(event => {
      if (event instanceof NavigationEnd) this.adminMode.set(event.urlAfterRedirects.startsWith('/admin'));
    });
  }

  @HostListener('window:scroll') onScroll(): void { this.scrolled.set(window.scrollY > 24); }

  toggleSearch(): void { this.searchOpen.update(value => !value); this.menuOpen.set(false); }
  toggleMenu(): void { this.menuOpen.update(value => !value); this.searchOpen.set(false); }
  closeMenu(): void { this.menuOpen.set(false); }
  handleSocial(network: string): void { this.store.notify(`Kênh ${network} chưa được cấu hình liên kết chính thức`); }

  submitSearch(event: Event): void {
    event.preventDefault();
    const form = event.target as HTMLFormElement;
    const query = new FormData(form).get('search')?.toString().trim();
    if (query) this.router.navigate(['/san-pham'], { queryParams: { q: query } });
    this.searchOpen.set(false);
  }
}
