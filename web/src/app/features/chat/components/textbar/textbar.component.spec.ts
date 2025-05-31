import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TextbarComponent } from './textbar.component';

describe('TextbarComponent', () => {
  let component: TextbarComponent;
  let fixture: ComponentFixture<TextbarComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [TextbarComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(TextbarComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
