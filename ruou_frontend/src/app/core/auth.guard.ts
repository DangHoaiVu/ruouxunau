import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { StoreService } from './store.service';

export const authGuard: CanActivateFn = async (_, state) => {
  const store = inject(StoreService); const router = inject(Router);
  return await store.ensureSession() || router.createUrlTree(['/dang-nhap'], { queryParams: { returnUrl: state.url } });
};

export const adminGuard: CanActivateFn = async () => {
  const store = inject(StoreService); const router = inject(Router);
  const authenticated = await store.ensureSession();
  if (!authenticated) return router.createUrlTree(['/dang-nhap'], { queryParams: { returnUrl: '/admin' } });
  return store.user()?.permissions.includes('ADMIN_ACCESS') || router.createUrlTree(['/tai-khoan']);
};
