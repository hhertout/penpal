import { Routes } from '@angular/router';
import { LoginComponent } from './features/login/login.component';
import { HomeComponent } from './features/home/home.component';
import { ChatComponent } from './features/chat/chat.component';
import { NotFoundComponent } from './features/not-found/not-found.component';

export const routes: Routes = [
  { path: '', component: HomeComponent, title: 'Home' },
  { path: 'login', component: LoginComponent, title: 'Login' },
  { path: 'chat', component: ChatComponent, title: 'Chat' },
  { path: '**', component: NotFoundComponent, title: 'Not Found' },
];
