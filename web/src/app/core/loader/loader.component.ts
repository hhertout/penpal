import { Component, Input } from '@angular/core';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';

@Component({
  selector: 'app-loader',
  imports: [MatProgressSpinnerModule],
  templateUrl: './loader.component.html',
})
export class LoaderComponent {
  @Input()
  diameter: number = 24;
}
