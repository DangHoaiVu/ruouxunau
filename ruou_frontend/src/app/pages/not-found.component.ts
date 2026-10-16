import { Component } from '@angular/core';
import { RouterLink } from '@angular/router';
@Component({ selector: 'app-not-found', imports: [RouterLink], template: `<section class="not-found"><span>404</span><p class="eyebrow">Lạc giữa Xứ Nẫu</p><h1>Trang này chưa được ủ xong.</h1><a class="button button-primary" routerLink="/">Về trang chủ</a></section>` })
export class NotFoundComponent {}
