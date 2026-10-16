import { Component, inject, signal } from '@angular/core';
import { RouterLink } from '@angular/router';
import { StoreService } from '../core/store.service';

@Component({
  selector: 'app-stories', imports: [RouterLink],
  template: `
    <section class="editorial-hero"><div class="container"><p class="eyebrow">Tạp chí Xứ Nẫu</p><h1>Chuyện của đất,<br /><em>người và men rượu.</em></h1><p>Nơi những câu chuyện làng nghề, kỹ nghệ thủ công và văn hóa thưởng thức được kể lại bằng góc nhìn hôm nay.</p></div></section>
    <section class="container featured-story">@if (featured) { <a [routerLink]="['/cau-chuyen', featured.slug]" class="featured-story-image"><img [src]="featured.image" [alt]="featured.title" /><span>Bài nổi bật</span></a><div><p class="eyebrow">{{ featured.category }} · {{ featured.publishedAt }}</p><h2><a [routerLink]="['/cau-chuyen', featured.slug]">{{ featured.title }}</a></h2><p>{{ featured.excerpt }}</p><a class="arrow-link" [routerLink]="['/cau-chuyen', featured.slug]">Đọc câu chuyện <span>→</span></a></div> }</section>
    <section class="section container"><div class="story-categories">@for (category of categories; track category) { <button type="button" [class.active]="selectedCategory() === category" (click)="selectedCategory.set(category)">{{ category }}</button> }</div><div class="story-grid large">@for (story of filteredStories(); track story.id) { <article class="story-card"><a [routerLink]="['/cau-chuyen', story.slug]"><img [src]="story.image" [alt]="story.title" loading="lazy" /></a><p class="eyebrow">{{ story.category }} · {{ story.readTime }} phút đọc</p><h3><a [routerLink]="['/cau-chuyen', story.slug]">{{ story.title }}</a></h3><p>{{ story.excerpt }}</p><small>{{ story.author }} · {{ story.publishedAt }}</small></article> } @empty { <div class="empty-state"><h2>Chưa có bài viết</h2><p>Chuyên mục này đang được biên tập.</p></div> }</div></section>
  `,
})
export class StoriesComponent {
  readonly store = inject(StoreService);
  get featured() { return this.store.stories().find(story => story.featured); }
  get categories() { return ['Tất cả', ...new Set(this.store.stories().map(story => story.category))]; }
  readonly selectedCategory = signal('Tất cả');
  filteredStories() { return this.selectedCategory() === 'Tất cả' ? this.store.stories() : this.store.stories().filter(story => story.category === this.selectedCategory()); }
}
