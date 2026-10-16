import { Component, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { StoreService } from '../core/store.service';

@Component({
  selector: 'app-auth', imports: [FormsModule, RouterLink],
  template: `
    <section class="auth-page"><div class="auth-visual"><div><p class="eyebrow light">Thành viên Xứ Nẫu</p><h1>Mỗi chai rượu,<br /><em>một câu chuyện.</em></h1><p>Đăng nhập để mua hàng, theo dõi đơn và lưu những hương vị bạn yêu thích.</p></div></div>
      <div class="auth-form-wrap"><form class="auth-form" (ngSubmit)="submit()"><a class="back-link" routerLink="/">← Về trang chủ</a>
        @if (mode() === 'login') {
          <p class="eyebrow">Chào mừng trở lại</p><h2>Đăng nhập</h2><p class="muted">Bạn cần đăng nhập trước khi thêm sản phẩm vào giỏ.</p>
        } @else if (mode() === 'register') {
          <p class="eyebrow">Thành viên mới</p><h2>Tạo tài khoản</h2><p class="muted">Thông tin tài khoản được lưu an toàn trên hệ thống.</p><label>Họ và tên<input name="name" [(ngModel)]="name" required placeholder="Nguyễn Văn A" /></label>
        } @else {
          <p class="eyebrow">Khôi phục truy cập</p><h2>Quên mật khẩu</h2><p class="muted">Nhập email để nhận hướng dẫn đặt lại mật khẩu.</p>
        }
        <label>Email<input type="email" name="email" [(ngModel)]="email" required placeholder="ban@example.com" /></label>
        @if (mode() !== 'forgot') { <label>Mật khẩu<span><input [type]="showPassword() ? 'text' : 'password'" name="password" [(ngModel)]="password" required [attr.minlength]="mode() === 'register' ? 12 : null" [placeholder]="mode() === 'register' ? 'Tối thiểu 12 ký tự, có chữ hoa, chữ thường và số' : 'Mật khẩu của bạn'" /><button type="button" (click)="showPassword.set(!showPassword())">{{ showPassword() ? 'Ẩn' : 'Hiện' }}</button></span></label> }
        @if (mode() === 'register') { <label class="check-row"><input type="checkbox" name="ageConfirmed" [(ngModel)]="ageConfirmed" required /> Tôi xác nhận đã đủ 18 tuổi</label> }
        @if (mode() === 'login') { <div class="form-options"><label class="check-row"><input type="checkbox" /> Ghi nhớ đăng nhập</label><button type="button" class="link-button" (click)="mode.set('forgot')">Quên mật khẩu?</button></div> }
        @if (error()) { <p class="form-error" role="alert">{{ error() }}</p> }
        <button class="button button-primary full" type="submit" [disabled]="busy()">{{ busy() ? 'Đang xử lý...' : mode() === 'login' ? 'Đăng nhập' : mode() === 'register' ? 'Tạo tài khoản' : 'Gửi yêu cầu' }}</button>
        <p class="auth-switch">@if (mode() === 'login') { Chưa có tài khoản? <button type="button" (click)="mode.set('register')">Đăng ký ngay</button> } @else { Đã có tài khoản? <button type="button" (click)="mode.set('login')">Quay lại đăng nhập</button> }</p>
        <small class="demo-note">Quyền truy cập được xác thực bởi máy chủ. Tài khoản mới chỉ có quyền khách hàng.</small>
      </form></div>
    </section>
  `,
})
export class AuthComponent {
  readonly store = inject(StoreService); private readonly router = inject(Router); private readonly route = inject(ActivatedRoute);
  readonly showPassword = signal(false); readonly mode = signal<'login' | 'register' | 'forgot'>('login');
  readonly busy = signal(false); readonly error = signal('');
  name = ''; email = ''; password = ''; ageConfirmed = false;
  async submit(): Promise<void> {
    if (this.busy()) return;
    if (!this.email || (this.mode() !== 'forgot' && !this.password) || (this.mode() === 'register' && (!this.name.trim() || !this.ageConfirmed))) {
      this.error.set('Vui lòng nhập đầy đủ thông tin hợp lệ'); return;
    }
    this.error.set(''); this.busy.set(true);
    try {
      if (this.mode() === 'forgot') {
        await this.store.forgotPassword(this.email);
        this.store.notify('Nếu email tồn tại, hướng dẫn đặt lại mật khẩu sẽ được gửi');
        this.mode.set('login');
      } else {
        if (this.mode() === 'register') await this.store.register(this.email, this.password, this.name, this.ageConfirmed);
        else await this.store.login(this.email, this.password);
        const requested = this.route.snapshot.queryParamMap.get('returnUrl');
        const destination = requested?.startsWith('/') && !requested.startsWith('//') ? requested : '/tai-khoan';
        await this.router.navigateByUrl(destination);
      }
    } catch (response: unknown) {
      const problem = response as { error?: { detail?: string }; status?: number };
      this.error.set(problem.error?.detail || (problem.status === 0 ? 'Không thể kết nối máy chủ. Vui lòng thử lại.' : 'Thao tác chưa thành công. Vui lòng thử lại.'));
    } finally { this.busy.set(false); }
  }
}
