import {
  Component,
  effect,
  inject,
  OnInit,
  PLATFORM_ID,
  signal,
} from '@angular/core';
import { LoaderComponent } from '../../core/loader/loader.component';
import { isPlatformBrowser } from '@angular/common';
import { Router } from '@angular/router';
import { AuthenticationService } from '../../shared/auth.service';
import ChatService from '../../shared/chat.service';
import { Message } from '../../shared/messages';
import { ReactiveFormsModule } from '@angular/forms';
import { SidebarComponent } from './components/sidebar/sidebar.component';
import { ChatboxComponent } from './components/chatbox/chatbox.component';
import { TextbarComponent } from './components/textbar/textbar.component';

@Component({
  selector: 'app-chat',
  templateUrl: './chat.component.html',
  styleUrls: ['./chat.component.css'],
  imports: [
    LoaderComponent,
    SidebarComponent,
    ChatboxComponent,
    TextbarComponent,
    ReactiveFormsModule,
  ],
})
export class ChatComponent implements OnInit {
  private platformId = inject(PLATFORM_ID);
  private router = inject(Router);
  private authService = inject(AuthenticationService);

  public isLoading = false;
  public isGeneratingAnswer = signal(false);

  public activeConversation = signal<string | null>(null);
  public characterName = signal<string>('');

  private chatService = inject(ChatService);

  public isMessagesLoading = signal(false);
  public messages = signal<Array<Message>>([]);

  constructor() {
    effect(async () => {
      this.isMessagesLoading.set(true);
      try {
        if (!this.activeConversation()) return;

        const messages = await this.chatService.getMessages(
          this.activeConversation()!
        );
        this.messages.set(messages);
      } catch (err) {
        console.error('Error fetching messages:', err);
      } finally {
        this.isMessagesLoading.set(false);
      }
    });
  }

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
