import { DatePipe, NgTemplateOutlet } from '@angular/common';
import { Component, inject, OnInit, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { firstValueFrom } from 'rxjs';
import { Order } from '../core/models';
import { StoreService } from '../core/store.service';

interface Address { id: string; receiverName: string; phone: string; provinceName: string; districtName: string; wardName: string; detail: string; defaultAddress: boolean; }

@Component({
  selector: 'app-account', imports: [RouterLink, FormsModule, DatePipe, NgTemplateOutlet],
  template: `
    <section class="page-hero mini"><div class="container"><p class="eyebrow light">Tài khoản</p><h1>Xin chào, {{ store.user()?.name }}</h1></div></section>
    <section class="section container account-layout">
      <aside class="account-nav">
        @for (tab of tabs; track tab.id) { <button type="button" [class.active]="activeTab() === tab.id" (click)="activeTab.set(tab.id)">{{ tab.label }}</button> }
        @if (store.user()?.role === 'ADMIN') { <a class="admin-link" routerLink="/admin">Mở trang quản trị ↗</a> }
        <button type="button" class="logout" (click)="logout()">Đăng xuất</button>
      </aside>
      <div class="account-content">
        @if (activeTab() === 'overview') {
          <div class="welcome-card"><p class="eyebrow">Thành viên Xứ Nẫu</p><h2>{{ store.user()?.name }}</h2><p>{{ store.user()?.email }}</p></div>
          <div class="account-stats"><div><strong>{{ orders().length }}</strong><span>Đơn đã đặt</span></div><div><strong>{{ activeOrders() }}</strong><span>Đơn đang xử lý</span></div><div><strong>{{ completedOrders() }}</strong><span>Đơn hoàn thành</span></div></div>
          <section class="recent-orders"><div class="section-heading"><h2>Đơn hàng gần đây</h2><button type="button" (click)="activeTab.set('orders')">Xem tất cả →</button></div><ng-container [ngTemplateOutlet]="orderList" /></section>
        }
        @if (activeTab() === 'orders') { <section class="account-panel"><p class="eyebrow">Lịch sử mua hàng</p><h2>Đơn hàng của tôi</h2><ng-container [ngTemplateOutlet]="orderList" /></section> }
        <ng-template #orderList>
          @if (ordersLoading()) { <p>Đang tải đơn hàng…</p> }
          @else if (orderError()) { <p class="form-error">{{ orderError() }}</p><button type="button" (click)="loadOrders()">Thử lại</button> }
          @else if (orders().length) { <div class="customer-orders">@for (order of orders(); track order.id) { <article [class.open]="selectedOrderId() === order.id"><button type="button" class="order-row" (click)="toggleOrder(order.id)"><span><small>{{ order.createdAt | date:'dd/MM/yyyy HH:mm' }}</small><strong>{{ order.orderNumber }}</strong></span><span>{{ order.items.length }} sản phẩm</span><b>{{ store.formatPrice(order.totalAmount) }}</b><em [class]="'order-status ' + order.status.toLowerCase()">{{ orderStatus(order.status) }}</em><i>⌄</i></button>@if (selectedOrderId() === order.id) { <div class="order-detail">@for (item of order.items; track item.id) { <div><img [src]="item.imageUrl || '/images/placeholder.jpg'" [alt]="item.productName" /><span><strong>{{ item.productName }}</strong><small>{{ item.variantLabel }} · {{ item.quantity }} sản phẩm</small></span><b>{{ store.formatPrice(item.lineTotal) }}</b></div> }<p><strong>Giao đến:</strong> {{ order.addressDetail }}, {{ order.wardName }}, {{ order.districtName }}, {{ order.provinceName }}</p></div> }</article> }</div> }
          @else { <div class="empty-state compact"><span>□</span><h3>Bạn chưa có đơn hàng</h3><p>Sản phẩm đã đặt sẽ xuất hiện tại đây.</p><a class="button button-primary" routerLink="/san-pham">Bắt đầu mua sắm</a></div> }
        </ng-template>
        @if (activeTab() === 'addresses') { <section class="account-panel"><p class="eyebrow">Sổ địa chỉ</p><h2>Địa chỉ nhận hàng</h2>@if (addressError()) { <p role="alert">{{ addressError() }}</p><button type="button" (click)="loadAddresses()">Thử lại</button> } @else if (addresses().length) { <div class="account-order-list">@for (address of addresses(); track address.id) { <article><div><strong>{{ address.receiverName }} · {{ address.phone }}</strong><small>{{ address.detail }}, {{ address.wardName }}, {{ address.districtName }}, {{ address.provinceName }}</small></div>@if (address.defaultAddress) { <em>Mặc định</em> }</article> }</div> } @else { <div class="empty-state compact"><span>⌖</span><h3>Chưa có địa chỉ đã lưu</h3><p>Bạn có thể nhập địa chỉ trực tiếp khi đặt hàng.</p></div> }</section> }
        @if (activeTab() === 'profile') { <section class="account-panel"><p class="eyebrow">Hồ sơ</p><h2>Thông tin cá nhân</h2><dl class="profile-list"><div><dt>Email</dt><dd>{{ store.user()?.email }}</dd></div><div><dt>Vai trò</dt><dd>{{ store.user()?.role === 'ADMIN' ? 'Quản trị viên' : 'Khách hàng' }}</dd></div></dl><form class="checkout-form" (ngSubmit)="saveProfile()"><div class="form-grid"><label>Họ tên<input name="fullName" [(ngModel)]="profileName" required minlength="2" maxlength="150" /></label><label>Số điện thoại<input name="phone" [(ngModel)]="profilePhone" pattern="^([+]84|0)[0-9]{9,10}$" placeholder="Chưa cập nhật" /></label></div>@if (profileError()) { <p role="alert">{{ profileError() }}</p> }<button type="submit" class="button button-primary" [disabled]="profileSaving()">Lưu hồ sơ</button></form></section> }
      </div>
    </section>
  `,
})
export class AccountComponent implements OnInit {
  readonly store = inject(StoreService); private readonly router = inject(Router); private readonly http = inject(HttpClient);
  readonly addresses = signal<Address[]>([]); readonly orders = signal<Order[]>([]);
  readonly addressError = signal(''); readonly orderError = signal(''); readonly ordersLoading = signal(true);
  readonly profileError = signal(''); readonly profileSaving = signal(false); readonly selectedOrderId = signal<string | null>(null);
  profileName = ''; profilePhone = '';
  readonly tabs = [{ id: 'overview', label: 'Tổng quan' }, { id: 'orders', label: 'Đơn hàng' }, { id: 'addresses', label: 'Địa chỉ' }, { id: 'profile', label: 'Thông tin cá nhân' }];
  readonly activeTab = signal('overview');
  ngOnInit(): void { this.profileName = this.store.user()?.name ?? ''; this.profilePhone = this.store.user()?.phone ?? ''; void this.loadAddresses(); void this.loadOrders(); }
  activeOrders(): number { return this.orders().filter(order => !['COMPLETED', 'CANCELLED'].includes(order.status)).length; }
  completedOrders(): number { return this.orders().filter(order => order.status === 'COMPLETED').length; }
  toggleOrder(id: string): void { this.selectedOrderId.update(current => current === id ? null : id); }
  orderStatus(status: Order['status']): string { return { NEW: 'Đơn mới', CONFIRMED: 'Đã xác nhận', SHIPPING: 'Đang giao', COMPLETED: 'Hoàn thành', CANCELLED: 'Đã hủy' }[status]; }
  async loadOrders(): Promise<void> { this.ordersLoading.set(true); this.orderError.set(''); try { this.orders.set(await this.store.myOrders()); } catch { this.orderError.set('Không tải được đơn hàng từ backend.'); } finally { this.ordersLoading.set(false); } }
  async loadAddresses(): Promise<void> { this.addressError.set(''); try { this.addresses.set(await firstValueFrom(this.http.get<Address[]>('/api/v1/me/addresses'))); } catch { this.addressError.set('Không tải được sổ địa chỉ từ backend.'); } }
  async saveProfile(): Promise<void> { if (this.profileName.trim().length < 2 || (this.profilePhone.trim() && !/^(\+84|0)[0-9]{9,10}$/.test(this.profilePhone.trim()))) { this.profileError.set('Họ tên hoặc số điện thoại không hợp lệ.'); return; } this.profileSaving.set(true); this.profileError.set(''); try { await this.store.updateProfile(this.profileName, this.profilePhone); } catch { this.profileError.set('Không lưu được hồ sơ. Vui lòng thử lại.'); } finally { this.profileSaving.set(false); } }
  async logout(): Promise<void> { try { await this.store.logout(); } catch { this.store.notify('Không thể liên hệ máy chủ; phiên trên trình duyệt đã được xóa'); } await this.router.navigateByUrl('/'); }
}
