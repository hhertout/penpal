import {
  AfterViewChecked,
  AfterViewInit,
  Component,
  effect,
  ElementRef,
  inject,
  Input,
  signal,
  ViewChild,
  WritableSignal,
} from '@angular/core';
import {
  MatDialog,
  MAT_DIALOG_DATA,
  MatDialogTitle,
  MatDialogContent,
} from '@angular/material/dialog';
import { MatIcon } from '@angular/material/icon';
import { LoaderComponent } from '../../../../core/loader/loader.component';
import { Message } from '../../../../shared/messages';
import { MatButtonModule } from '@angular/material/button';

@Component({
  selector: 'app-chatbox',
  imports: [MatIcon, LoaderComponent, MatButtonModule],
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

  @Input()
  isGeneratingAnswer = signal(false);

  @Input()
  characterName = signal<string>('');

  @ViewChild('chatWrapper') private chatWrapper!: ElementRef;

  private previousMessagesLength: number = 0;

  dialog = inject(MatDialog);

  constructor() {
    effect(() => {
      if (this.messages().length > 0)
        setTimeout(() => {
          this.scrollToBottom();
        }, 0);
    });
  }

  openDialog(correction: string): void {
    this.dialog.open(DialogCorrectionDialog, {
      data: {
        correction: correction,
      },
    });
  }

  ngAfterViewInit(): void {
    if (this.chatWrapper) {
      this.scrollToBottom();
    }
  }

  ngAfterViewChecked(): void {
    if (this.messages().length > this.previousMessagesLength) {
      this.scrollToBottom();
      this.previousMessagesLength = this.messages().length;
    }
  }

  private scrollToBottom(): void {
    const element = this.chatWrapper.nativeElement;
    requestAnimationFrame(() => {
      element.scrollTop = element.scrollHeight;
    });
  }
}

@Component({
  selector: 'dialog-data-correction-dialog',
  templateUrl: './dialog-data-correction-dialog.html',
  imports: [MatDialogTitle, MatDialogContent, MatIcon],
})
export class DialogCorrectionDialog {
  data = inject(MAT_DIALOG_DATA);
}
