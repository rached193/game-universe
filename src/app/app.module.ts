import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { ReactiveFormsModule } from '@angular/forms';
import { CreateCompetitionComponent } from './competition/create.competition/create.competition.component';
import { HomepageComponent } from './competition/homepage/homepage.component';
import { SignInComponent } from './sign-in/sign-in.component';
import { LoginComponent } from './login/login.component';
import { NavbarComponent } from './navbar/navbar.component';
import { VisualComponent } from './visual/visual.component';


@NgModule({
  declarations: [
    AppComponent,
    CreateCompetitionComponent,
    HomepageComponent,
    SignInComponent,
    LoginComponent,
    NavbarComponent,
    VisualComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    ReactiveFormsModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
