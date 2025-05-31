import {
  AfterViewChecked,
  AfterViewInit,
  Component,
  ElementRef,
  Input,
  signal,
  ViewChild,
  WritableSignal,
} from '@angular/core';
import { MatIcon } from '@angular/material/icon';
import { Message } from '../../shared/messages';
import { LoaderComponent } from '../loader/loader.component';

@Component({
  selector: 'app-chatbox',
  imports: [MatIcon, LoaderComponent],
  templateUrl: './chatbox.component.html',
  styleUrl: './chatbox.component.css',
})
export class ChatboxComponent implements AfterViewInit, AfterViewChecked {
  @Input()
  activeConversation = signal<string | null>(null);

  @Input()
  isLoading = signal(false);

  @Input()
  messages: WritableSignal<Message[]> = signal([]);

  @ViewChild('chatWrapper') private chatWrapper!: ElementRef;

  private previousMessageCount = 0;

  ngAfterViewInit(): void {
    if (this.chatWrapper) {
      this.scrollToBottom();
    }
  }

  ngAfterViewChecked(): void {
    if (
      this.chatWrapper &&
      this.messages().length > this.previousMessageCount
    ) {
      this.scrollToBottom();
      this.previousMessageCount = this.messages().length; // Mettre à jour le compteur
    }
  }

  private scrollToBottom(): void {
    const element = this.chatWrapper.nativeElement;
    requestAnimationFrame(() => {
      element.scrollTop = element.scrollHeight;
    });
  }
}
