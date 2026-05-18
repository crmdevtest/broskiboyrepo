import { HttpErrorResponse, HttpInterceptorFn } from '@angular/common/http';
import { catchError, throwError } from 'rxjs';
import { inject } from '@angular/core';
import { AlertService } from '@shared/services/alert.service';

export const errorHandlingInterceptor: HttpInterceptorFn = (req, next) => {
  const alertService = inject(AlertService)
  return next(req).pipe(
    catchError(
      (error: HttpErrorResponse) => {
        switch (error.status) {
          case 400:
            alertService.failedAlert('Operation Failed')
            return throwError(() => error)

          case 401:
            alertService.failedAlert('unauthorized')
            return throwError(() => error)

          case 403:
            alertService.failedAlert('Access denied')
            return throwError(() => error)

          case 404:
            alertService.failedAlert('Operation Failed')
            return throwError(() => error)

          case 500:
            alertService.failedAlert('Server error')
            return throwError(() => error)
        }


        return throwError(() => error)
      }))

};

