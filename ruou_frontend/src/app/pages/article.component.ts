import { Component, inject } from '@angular/core';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { StoreService } from '../core/store.service';

@Component({
  selector: 'app-article', imports: [RouterLink],
  template: `
    @if (story; as article) { <article class="article-page"><header class="article-header container"><a class="back-link" routerLink="/cau-chuyen">← Tất cả câu chuyện</a><p class="eyebrow">{{ article.category }}</p><h1>{{ article.title }}</h1><p class="article-deck">{{ article.excerpt }}</p><div class="article-meta"><span>{{ article.author }}</span><span>{{ article.publishedAt }}</span><span>{{ article.readTime }} phút đọc</span></div></header><figure class="article-cover"><img [src]="article.image" [alt]="article.title" /><figcaption>Ảnh minh họa — sẽ thay bằng tư liệu thương hiệu chính thức.</figcaption></figure><div class="article-layout container"><aside><strong>Trong bài viết</strong><a href="#khoi-nguon">Khởi nguồn</a><a href="#nghe-thuat">Nghệ thuật của thời gian</a><button (click)="share()">Sao chép liên kết</button></aside><div class="article-content"><p class="drop-cap" id="khoi-nguon">{{ article.content[0] }}</p><blockquote>“Rượu ngon trước hết phải được làm bằng sự tử tế với nguyên liệu và người thưởng thức.”</blockquote>@for (paragraph of article.content.slice(1); track paragraph) { <p id="nghe-thuat">{{ paragraph }}</p> }<div class="responsible">Thưởng thức có trách nhiệm. Không chia sẻ đồ uống có cồn cho người dưới 18 tuổi và không lái xe sau khi uống.</div></div></div></article> }
  `,
})
export class ArticleComponent {
  readonly store = inject(StoreService);
  private readonly slug = inject(ActivatedRoute).snapshot.paramMap.get('slug');
  get story() { return this.store.stories().find(item => item.slug === this.slug); }
  share(): void { navigator.clipboard?.writeText(location.href); this.store.notify('Đã sao chép liên kết bài viết'); }
}
