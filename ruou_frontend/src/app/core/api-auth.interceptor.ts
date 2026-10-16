import { HttpErrorResponse, HttpInterceptorFn } from '@angular/common/http';
import { inject } from '@angular/core';
import { catchError, from, switchMap, throwError } from 'rxjs';
import { StoreService } from './store.service';

export const apiAuthInterceptor: HttpInterceptorFn = (request, next) => {
  if (request.url.startsWith('/api/v1/auth/')) return next(request);
  if (!request.url.startsWith('/api/v1/')) return next(request);
  const store = inject(StoreService);
  const protectedRoute = request.url.startsWith('/api/v1/admin/') || request.url.startsWith('/api/v1/me') || request.url.startsWith('/api/v1/orders');
  const send = () => {
    const token = store.accessToken();
    return next(token ? request.clone({ setHeaders: { Authorization: `Bearer ${token}` } }) : request);
  };
  if (!protectedRoute) return send();
  return from(store.ensureSession()).pipe(
    switchMap(() => send().pipe(
      catchError(error => {
        if (!(error instanceof HttpErrorResponse) || error.status !== 401) return throwError(() => error);
        return from(store.ensureSession(true)).pipe(switchMap(ok => ok ? send() : throwError(() => error)));
      }),
    )),
  );
};
