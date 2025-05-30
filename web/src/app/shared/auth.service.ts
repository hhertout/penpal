import { Injectable } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class AuthenticationService {
  private readonly BACKEND_URL = 'http://localhost:8000';

  async checkToken(): Promise<boolean> {
    try {
      const response = await fetch(`${this.BACKEND_URL}/api/v1/check-token`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `${localStorage.getItem('token')}`,
        },
      });

      return response.ok;
    } catch (error) {
      console.error('Error checking token:', error);
      return false;
    }
  }
}
