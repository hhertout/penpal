import { Component, Input, signal, WritableSignal } from '@angular/core';
import { MatIcon } from '@angular/material/icon';

@Component({
  selector: 'app-chatbox',
  imports: [MatIcon],
  templateUrl: './chatbox.component.html',
  styleUrl: './chatbox.component.css',
})
export class ChatboxComponent {
  @Input()
  activeConversation = signal<string | null>(null);
}
