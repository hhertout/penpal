import { Injectable } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class HousingService {
  url = 'http://localhost:8000/api/v1/check-token';
  async getAllHousingLocations(): Promise<boolean> {
    return true;
  }
}
