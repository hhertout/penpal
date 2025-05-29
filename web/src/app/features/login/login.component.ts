import { Component, inject, signal, WritableSignal } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIcon } from '@angular/material/icon';
import { MatCardModule } from '@angular/material/card';
import { FormControl, FormGroup, ReactiveFormsModule } from '@angular/forms';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  imports: [
    MatButtonModule,
    MatFormFieldModule,
    MatInputModule,
    MatIcon,
    MatCardModule,
    ReactiveFormsModule,
  ],
  templateUrl: './login.component.html',
  styleUrl: './login.component.css',
})
export class LoginComponent {
  private router: Router = inject(Router);

  hide = signal(true);

  error: WritableSignal<string | null> = signal(null);

  isSubmitting = signal(false);

  loginForm = new FormGroup({
    username: new FormControl('', {
      nonNullable: true,
    }),

    password: new FormControl('', {
      nonNullable: true,
    }),
  });

  async onSubmit() {
    try {
      const response = await fetch('http://localhost:8000/api/v1/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          username: this.loginForm.value.username,
          password: this.loginForm.value.password,
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        console.error('Login failed');
        this.handleErrorMessage(data.detail);
      } else {
        localStorage.setItem('token', data.token);
        this.router.navigate(['/chat']);
      }
    } catch (error) {
      this.error.set(
        'Une erreur est survenue lors de la connexion. Veuillez réessayer plus tard.'
      );
      console.error('Error during form submission:', error);
    } finally {
      this.isSubmitting.set(false);
    }
  }

  handleErrorMessage(message: string) {
    if (
      message ===
      'Too many login attempts. Please wait a moment before trying again...'
    )
      this.error.set(
        'Trop de tentatives de connexion. Veuillez patienter avant de réessayer.'
      );
    else if (message === 'Invalid credentials')
      this.error.set('Erreur: Identifiants invalides');
    else this.error.set(message || 'Erreur inconnue');
  }
}
