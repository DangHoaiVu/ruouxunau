import { Component, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { Order } from '../core/models';
import { StoreService } from '../core/store.service';

@Component({
  selector: 'app-checkout',
  imports: [FormsModule, RouterLink],
  template: `
    <section class="checkout-page section container">
      <div class="checkout-head"><a routerLink="/gio-hang">← Quay lại giỏ hàng</a><div><span>Giỏ hàng</span><i></i><strong>Thông tin nhận hàng</strong><i></i><span>Xác nhận</span></div></div>
      @if (completedOrder()) {
        <section class="order-success">
          <span class="success-icon">✓</span><p class="eyebrow">Đặt hàng thành công</p><h1>Cảm ơn bạn đã chọn Xứ Nẫu</h1>
          <p>Đơn <strong>{{ completedOrder()?.orderNumber }}</strong> đã được ghi nhận. Chúng tôi sẽ liên hệ xác nhận trước khi giao hàng.</p>
          <div><a class="button button-primary" routerLink="/tai-khoan">Xem đơn hàng</a><a class="button button-secondary" routerLink="/san-pham">Tiếp tục mua sắm</a></div>
        </section>
      } @else if (!store.cart().length) {
        <div class="empty-state"><span>◌</span><h2>Giỏ hàng đang trống</h2><p>Hãy thêm sản phẩm trước khi đặt hàng.</p><a class="button button-primary" routerLink="/san-pham">Khám phá sản phẩm</a></div>
      } @else {
        <div class="checkout-layout">
          <form class="checkout-form checkout-card" (ngSubmit)="submit()">
            <p class="eyebrow">Thông tin nhận hàng</p><h1>Hoàn tất đơn hàng</h1><p class="form-intro">Vui lòng kiểm tra thông tin. Đơn được thanh toán bằng tiền mặt khi nhận hàng.</p>
            <div class="form-grid">
              <label>Họ và tên<input name="receiverName" [(ngModel)]="form.receiverName" required minlength="2" maxlength="150" autocomplete="name" /></label>
              <label>Số điện thoại<input name="phone" [(ngModel)]="form.phone" required pattern="^(\\+84|0)[0-9]{9,10}$" autocomplete="tel" placeholder="0905 123 456" /></label>
              <label class="full-span">Địa chỉ cụ thể<input name="addressDetail" [(ngModel)]="form.addressDetail" required maxlength="255" autocomplete="street-address" placeholder="Số nhà, tên đường" /></label>
              <label>Phường / Xã<input name="wardName" [(ngModel)]="form.wardName" required maxlength="100" /></label>
              <label>Quận / Huyện<input name="districtName" [(ngModel)]="form.districtName" required maxlength="100" /></label>
              <label>Tỉnh / Thành phố<input name="provinceName" [(ngModel)]="form.provinceName" required maxlength="100" /></label>
              <label class="full-span">Ghi chú <small>(không bắt buộc)</small><textarea name="note" [(ngModel)]="form.note" maxlength="500" rows="3" placeholder="Thời gian nhận hàng hoặc lưu ý cho cửa hàng"></textarea></label>
            </div>
            <div class="cod-card"><span>COD</span><div><strong>Thanh toán khi nhận hàng</strong><small>Không cần thanh toán trước hoặc kết nối ngân hàng.</small></div><b>✓</b></div>
            @if (error()) { <p class="form-error" role="alert">{{ error() }}</p> }
            <button class="button button-primary full" type="submit" [disabled]="submitting()">{{ submitting() ? 'Đang tạo đơn…' : 'Đặt hàng · ' + store.formatPrice(store.subtotal()) }}</button>
            <p class="checkout-assurance">Tồn kho và giá bán được backend kiểm tra lại trước khi xác nhận đơn.</p>
          </form>
          <aside class="order-summary checkout-summary"><h2>Đơn hàng của bạn</h2>
            @for (item of store.cart(); track item.product.id) { <div class="checkout-item"><img [src]="item.product.image" [alt]="item.product.name" /><span><strong>{{ item.product.name }}</strong><small>{{ item.product.volume }}ml · SL {{ item.quantity }}</small></span><b>{{ store.formatPrice(item.product.price * item.quantity) }}</b></div> }
            <dl><div><dt>Tạm tính</dt><dd>{{ store.formatPrice(store.subtotal()) }}</dd></div><div><dt>Phí giao hàng</dt><dd>Miễn phí</dd></div><div class="summary-total"><dt>Tổng cộng</dt><dd>{{ store.formatPrice(store.subtotal()) }}</dd></div></dl>
          </aside>
        </div>
      }
    </section>
  `,
})
export class CheckoutComponent {
  readonly store = inject(StoreService);
  readonly submitting = signal(false);
  readonly error = signal('');
  readonly completedOrder = signal<Order | null>(null);
  form = {
    receiverName: this.store.user()?.name ?? '', phone: this.store.user()?.phone ?? '',
    addressDetail: '', wardName: '', districtName: '', provinceName: 'Bình Định', note: '',
  };

  async submit(): Promise<void> {
    if (this.submitting()) return;
    if (!this.form.receiverName.trim() || !/^(\+84|0)[0-9]{9,10}$/.test(this.form.phone.trim()) ||
        !this.form.addressDetail.trim() || !this.form.wardName.trim() || !this.form.districtName.trim() || !this.form.provinceName.trim()) {
      this.error.set('Vui lòng nhập đầy đủ và đúng thông tin nhận hàng.'); return;
    }
    this.submitting.set(true); this.error.set('');
    try {
      this.completedOrder.set(await this.store.placeOrder({
        ...this.form,
        receiverName: this.form.receiverName.trim(), phone: this.form.phone.trim(),
        addressDetail: this.form.addressDetail.trim(), wardName: this.form.wardName.trim(),
        districtName: this.form.districtName.trim(), provinceName: this.form.provinceName.trim(), note: this.form.note.trim(),
      }));
      window.scrollTo({ top: 0, behavior: 'smooth' });
    } catch (response: unknown) {
      const problem = response as { error?: { detail?: string } };
      this.error.set(problem.error?.detail ?? 'Không thể tạo đơn hàng. Vui lòng kiểm tra lại và thử lại.');
    } finally { this.submitting.set(false); }
  }
}
