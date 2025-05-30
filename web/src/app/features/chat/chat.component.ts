import { Component, inject, OnInit, PLATFORM_ID, signal } from '@angular/core';
import { LoaderComponent } from '../../core/loader/loader.component';
import { isPlatformBrowser } from '@angular/common';
import { Router } from '@angular/router';
import { SidebarComponent } from '../../core/sidebar/sidebar.component';
import { ChatboxComponent } from '../../core/chatbox/chatbox.component';
import { TextbarComponent } from '../../core/textbar/textbar.component';
import { AuthenticationService } from '../../shared/auth.service';

@Component({
  selector: 'app-chat',
  templateUrl: './chat.component.html',
  styleUrls: ['./chat.component.css'],
  imports: [
    LoaderComponent,
    SidebarComponent,
    ChatboxComponent,
    TextbarComponent,
  ],
})
export class ChatComponent implements OnInit {
  private platformId = inject(PLATFORM_ID);
  private router = inject(Router);
  private authService = inject(AuthenticationService);

  isLoading: boolean = false;

  activeConversation = signal<string | null>(null);

  async ngOnInit() {
    this.isLoading = true;
    if (!isPlatformBrowser(this.platformId)) {
      return;
    }

    const isAuthorized = await this.authService.checkToken();

    if (!isAuthorized) {
      this.router.navigate(['/login']);
    }

    this.isLoading = false;
  }
}
