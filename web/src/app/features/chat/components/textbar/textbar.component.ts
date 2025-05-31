import { Component, inject, Input, signal } from '@angular/core';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';
import { FormControl, FormGroup, FormsModule } from '@angular/forms';
import { MatIcon } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { ReactiveFormsModule } from '@angular/forms';
import { Message } from '../../../../shared/messages';
import ChatService from '../../../../shared/chat.service';

@Component({
  selector: 'app-textbar',
  imports: [
    MatInputModule,
    MatFormFieldModule,
    FormsModule,
    MatIcon,
    MatButtonModule,
    ReactiveFormsModule,
  ],
  templateUrl: './textbar.component.html',
  styleUrl: './textbar.component.css',
})
export class TextbarComponent {
  @Input()
  activeConversation = signal<string | null>(null);

  @Input()
  messages = signal<Array<Message>>([]);

  private chatService = inject(ChatService);

  chatForm = new FormGroup({
    message: new FormControl(
      {
        value: '',
        disabled: false,
      },
      {
        nonNullable: true,
      }
    ),
  });

  @Input()
  isGeneratingAnswer = signal(false);

  async onSubmit(): Promise<void> {
    if (
      this.chatForm.invalid ||
      !this.chatForm.value.message ||
      this.chatForm.value.message === ''
    )
      return;

    this.messages.update((messages) => {
      messages.push({
        id: Date.now().toLocaleString(),
        ts: Date.now(),
        message: this.chatForm.value.message!,
        conv_id: this.activeConversation()!,
        sender: 'user',
        correction: null,
      });

      return messages;
    });

    try {
      this.isGeneratingAnswer.set(true);
      this.chatForm.disable();

      const data = await this.chatService.postMessage({
        conv_id: this.activeConversation()!,
        message: this.chatForm.value.message!,
      });

      this.messages.update((messages) => {
        // Update the last message with the AI correction
        messages[messages.length - 1].correction = data.correction;

        // Add the AI response as a new message
        messages.push({
          id: new Date().toLocaleString(),
          ts: Date.now(),
          message: data.response,
          conv_id: this.activeConversation()!,
          sender: 'ai',
        });
        return messages;
      });
    } catch (err) {
      console.error('Error sending message:', err);
    } finally {
      this.isGeneratingAnswer.set(false);
      this.chatForm.reset();
    }
  }
}
