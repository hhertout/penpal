import { Component, Input, signal } from '@angular/core';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';
import { FormControl, FormGroup, FormsModule } from '@angular/forms';
import { MatIcon } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { Message } from '../../shared/messages';
import { ReactiveFormsModule } from '@angular/forms';

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

  chatForm = new FormGroup({
    message: new FormControl('', {
      nonNullable: true,
    }),
  });

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

    this.chatForm.reset();
  }
}
