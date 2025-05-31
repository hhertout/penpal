import {
  Component,
  inject,
  Input,
  OnChanges,
  OnInit,
  signal,
} from '@angular/core';
import { MatIcon } from '@angular/material/icon';
import { Conversation } from '../../shared/conversations';
import ChatService from '../../shared/chat.service';
import { MatListModule } from '@angular/material/list';
import { MatButtonModule } from '@angular/material/button';
import { Router } from '@angular/router';

@Component({
  selector: 'app-sidebar',
  imports: [MatIcon, MatListModule, MatButtonModule],
  templateUrl: './sidebar.component.html',
  styleUrl: './sidebar.component.css',
})
export class SidebarComponent implements OnChanges, OnInit {
  private chatService = inject(ChatService);
  private router = inject(Router);

  conversations: Array<Conversation> = [];

  @Input()
  activeConversation = signal<string | null>(null);

  async ngOnInit() {
    try {
      this.conversations = await this.chatService.getConversations();
    } catch (err) {
      // TODO
      console.error('Error fetching conversations:', err);
    }
  }

  ngOnChanges() {}

  onConversationChange(id: string) {
    this.activeConversation.set(id);
    this.router.navigate([], {
      queryParams: { conversationId: id },
      queryParamsHandling: 'merge',
      replaceUrl: true,
    });
  }
}
