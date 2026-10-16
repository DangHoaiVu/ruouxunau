import { Routes } from '@angular/router';
import { adminGuard, authGuard } from './core/auth.guard';
import { AccountComponent } from './pages/account.component';
import { AdminComponent } from './pages/admin.component';
import { ArticleComponent } from './pages/article.component';
import { AuthComponent } from './pages/auth.component';
import { CartComponent } from './pages/cart.component';
import { CheckoutComponent } from './pages/checkout.component';
import { ContactComponent } from './pages/contact.component';
import { HomeComponent } from './pages/home.component';
import { NotFoundComponent } from './pages/not-found.component';
import { ProductDetailComponent } from './pages/product-detail.component';
import { ProductsComponent } from './pages/products.component';
import { PolicyComponent } from './pages/policy.component';
import { StoriesComponent } from './pages/stories.component';

export const routes: Routes = [
  { path: '', component: HomeComponent, title: 'Rượu Xứ Nẫu — Tinh hoa miền đất võ' },
  { path: 'san-pham', component: ProductsComponent, title: 'Bộ sưu tập | Rượu Xứ Nẫu' },
  { path: 'san-pham/:slug', component: ProductDetailComponent, title: 'Chi tiết sản phẩm | Rượu Xứ Nẫu' },
  { path: 'cau-chuyen', component: StoriesComponent, title: 'Câu chuyện | Rượu Xứ Nẫu' },
  { path: 'cau-chuyen/:slug', component: ArticleComponent, title: 'Tạp chí | Rượu Xứ Nẫu' },
  { path: 'lien-he', component: ContactComponent, title: 'Liên hệ | Rượu Xứ Nẫu' },
  { path: 'chinh-sach', component: PolicyComponent, title: 'Chính sách mua hàng | Rượu Xứ Nẫu' },
  { path: 'dang-nhap', component: AuthComponent, title: 'Đăng nhập | Rượu Xứ Nẫu' },
  { path: 'gio-hang', component: CartComponent, canActivate: [authGuard], title: 'Giỏ hàng | Rượu Xứ Nẫu' },
  { path: 'dat-hang', component: CheckoutComponent, canActivate: [authGuard], title: 'Đặt hàng | Rượu Xứ Nẫu' },
  { path: 'thanh-toan', redirectTo: 'dat-hang', pathMatch: 'full' },
  { path: 'tai-khoan', component: AccountComponent, canActivate: [authGuard], title: 'Tài khoản | Rượu Xứ Nẫu' },
  { path: 'admin', component: AdminComponent, canActivate: [adminGuard], title: 'Quản trị | Rượu Xứ Nẫu' },
  { path: '**', component: NotFoundComponent, title: 'Không tìm thấy trang | Rượu Xứ Nẫu' },
];
