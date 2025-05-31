import {
  Component,
  inject,
  Input,
  OnInit,
  signal,
  WritableSignal,
} from '@angular/core';
import { MatIcon } from '@angular/material/icon';
import { MatListModule } from '@angular/material/list';
import { MatButtonModule } from '@angular/material/button';
import { Router } from '@angular/router';
import ChatService from '../../../../shared/chat.service';
import { Conversation } from '../../../../shared/conversations';
import {
  MAT_DIALOG_DATA,
  MatDialog,
  MatDialogContent,
  MatDialogTitle,
} from '@angular/material/dialog';
import { FormControl, FormGroup, ReactiveFormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-sidebar',
  imports: [MatIcon, MatListModule, MatButtonModule],
  templateUrl: './sidebar.component.html',
  styleUrl: './sidebar.component.css',
})
export class SidebarComponent implements OnInit {
  private chatService = inject(ChatService);
  private router = inject(Router);

  conversations = signal<Conversation[]>([]);

  @Input()
  activeConversation = signal<string | null>(null);

  @Input()
  characterName = signal<string>('');

  async ngOnInit() {
    try {
      const conversations = await this.chatService.getConversations();
      this.conversations.set(conversations);
    } catch (err) {
      // TODO
      console.error('Error fetching conversations:', err);
    }
  }

  dialog = inject(MatDialog);

  openDialog(): void {
    this.dialog.open(DialogCreateConvDialog, {
      data: {
        convs: this.conversations,
        selectedConv: this.activeConversation,
      },
    });
  }

  onConversationChange(id: string) {
    this.activeConversation.set(id);
    this.characterName.set(
      this.conversations().find((conv) => conv._id === id)?.character.name || ''
    );
    this.router.navigate([], {
      queryParams: { conversationId: id },
      queryParamsHandling: 'merge',
      replaceUrl: true,
    });
  }
}

@Component({
  selector: 'dialog-data-correction-dialog',
  templateUrl: './dialog-data-create-conv-dialog.html',
  imports: [
    MatDialogTitle,
    MatDialogContent,
    MatIcon,
    MatFormFieldModule,
    ReactiveFormsModule,
    MatFormFieldModule,
    MatInputModule,
    MatButtonModule,
    MatSelectModule,
    CommonModule,
  ],
})
export class DialogCreateConvDialog {
  error = signal<string | null>(null);
  isSubmitting = signal(false);

  dialog = inject(MatDialog);
  data = inject<{
    convs: WritableSignal<Conversation[]>;
    selectedConv: WritableSignal<string>;
  }>(MAT_DIALOG_DATA);

  private chatService = inject(ChatService);

  contryList: { [key: string]: string[] } = {
    Australia: ['Sydney', 'Melbourne', 'Brisbane'],
    Canada: ['Toronto', 'Vancouver', 'Ottawa'],
    'United Kingdom': ['London', 'Manchester', 'Birmingham'],
    'United States': ['New York', 'Los Angeles', 'Chicago'],
  };

  availableCities: string[];

  createConvForm = new FormGroup({
    name: new FormControl('', {
      nonNullable: true,
    }),

    gender: new FormControl('', {
      nonNullable: true,
    }),

    city: new FormControl('Melbourne', {
      nonNullable: true,
    }),

    country: new FormControl('Australia', {
      nonNullable: true,
    }),
  });

  constructor() {
    // set default values
    this.createConvForm.value.country = 'Australia';
    this.createConvForm.value.city = this.contryList['Australia'][0];
    this.availableCities = this.contryList['Australia'];
  }

  onCountryChange(): void {
    if (this.createConvForm.value.country) {
      this.availableCities = this.contryList[this.createConvForm.value.country];
      this.createConvForm.value.city =
        this.availableCities[0] || this.contryList['Australia'][0];
    }
  }

  async onSubmit() {
    if (this.createConvForm.invalid) {
      this.error.set('Please fill in all fields.');
      return;
    }

    this.isSubmitting.set(true);
    this.error.set(null);

    try {
      const createdConv = await this.chatService.createConversation({
        name: this.createConvForm.value.name!,
        character: {
          name: this.createConvForm.value.name!,
          gender: this.createConvForm.value.gender!,
          city: this.createConvForm.value.city!,
          country: this.createConvForm.value.country!,
        },
      });

      // Refresh conversations
      const newConvs = await this.chatService.getConversations();
      this.data.convs.set(newConvs);

      // update selected conv
      this.data.selectedConv.set(createdConv.id);
    } catch (err) {
      console.error('Error creating conversation:', err);
      this.error.set('Failed to create conversation. Please try again.');
      this.isSubmitting.set(false);
    } finally {
      this.isSubmitting.set(false);
      this.createConvForm.reset();

      if (this.dialog) {
        this.dialog.closeAll();
      }
    }
  }
}
