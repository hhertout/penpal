import { Component, OnInit, REQUEST, inject } from '@angular/core';
import { LoaderComponent } from '../../core/loader/loader.component';

@Component({
  selector: 'app-chat',
  templateUrl: './chat.component.html',
  styleUrls: ['./chat.component.css'],
  imports: [LoaderComponent],
})
export class ChatComponent implements OnInit {
  isLoading: boolean = false;

  private serverRequest = inject(REQUEST, { optional: true });

  constructor() {}

  ngOnInit(): void {
    console.log(this.serverRequest);
  }

  /**
   * Helper function to get a specific cookie from the server request.
   * @param name The name of the cookie to retrieve.
   * @returns The cookie value, or null if not found.
   */
  /* private getCookieFromServerRequest(name: string): string | null {
    if (!this.serverRequest || !this.serverRequest.headers) {
      return null;
    }
    const cookieHeader =
      this.serverRequest.headers.get('cookie') ||
      this.serverRequest.headers.get('Cookie');

    if (!cookieHeader) {
      return null;
    }

    const cookies = cookieHeader.split(';');
    for (const cookie of cookies) {
      const parts = cookie.split('=');
      const cookieName = decodeURIComponent(parts[0].trim());
      if (cookieName === name) {
        return decodeURIComponent(parts.slice(1).join('=')).trim();
      }
    }
    return null;
  } */

  /**
   * Helper function to get a specific cookie from the client (browser).
   * @param name The name of the cookie to retrieve.
   * @returns The cookie value, or null if not found.
   */
  private getCookie(name: string): string | null {
    if (typeof document === 'undefined' || !document.cookie) {
      return null; // Pas de document ou pas de cookies disponibles
    }
    const nameEQ = name + '=';
    const ca = document.cookie.split(';');
    for (let i = 0; i < ca.length; i++) {
      let c = ca[i];
      while (c.charAt(0) === ' ') c = c.substring(1, c.length);
      if (c.indexOf(nameEQ) === 0)
        return decodeURIComponent(c.substring(nameEQ.length, c.length));
    }
    return null;
  }
}
