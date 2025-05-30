import { Component, Input, signal } from '@angular/core';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';
import { FormsModule } from '@angular/forms';
import { MatIcon } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';

@Component({
  selector: 'app-textbar',
  imports: [
    MatInputModule,
    MatFormFieldModule,
    FormsModule,
    MatIcon,
    MatButtonModule,
  ],
  templateUrl: './textbar.component.html',
  styleUrl: './textbar.component.css',
})
export class TextbarComponent {
  @Input()
  activeConversation = signal<string | null>(null);
}
