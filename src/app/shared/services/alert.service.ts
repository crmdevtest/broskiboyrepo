import { inject, Injectable } from '@angular/core';
import { ToastrService } from 'ngx-toastr';

@Injectable({
  providedIn: 'root'
})
export class AlertService {

  toastService = inject(ToastrService)
  constructor() { }

  failedAlert(text: string = 'Operation Failed') {
    this.toastService.error(text, 'failed');
  }
}
