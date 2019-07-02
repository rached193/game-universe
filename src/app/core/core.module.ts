import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HeaderComponent } from './header/header.component';
import { NavbarComponent } from './header/navbar/navbar.component';

@NgModule({
  declarations: [HeaderComponent, NavbarComponent],
  imports: [
    CommonModule,
  ],
  exports: [HeaderComponent]
})
export class CoreModule { }
