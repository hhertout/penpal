import { Component, inject, OnInit, PLATFORM_ID } from '@angular/core';
import { LoaderComponent } from '../../core/loader/loader.component';
import { isPlatformBrowser } from '@angular/common';
import { Router } from '@angular/router';

@Component({
  selector: 'app-chat',
  templateUrl: './chat.component.html',
  styleUrls: ['./chat.component.css'],
  imports: [LoaderComponent],
})
export class ChatComponent implements OnInit {
  private platformId = inject(PLATFORM_ID);
  private router = inject(Router);

  isLoading: boolean = false;

  async ngOnInit() {
    this.isLoading = true;
    if (!isPlatformBrowser(this.platformId)) {
      return;
    }

    try {
      const response = await fetch('http://localhost:8000/api/v1/check-token', {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `${localStorage.getItem('token')}`,
        },
      });

      if (response.ok) {
        this.isLoading = false;
      } else {
        this.router.navigate(['/login']);
        this.isLoading = false;
      }
    } catch (error) {
      console.error('Error checking token:', error);
      this.router.navigate(['/login']);
      this.isLoading = false;
    }
  }
}
