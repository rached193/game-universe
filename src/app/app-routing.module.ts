import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router'
import { CreateCompetitionComponent } from './competition/create.competition/create.competition.component';
import { HomepageComponent } from './competition/homepage/homepage.component';
import { SignInComponent } from './sign-in/sign-in.component';
import { VisualComponent } from './visual/visual.component';

const routes: Routes = [
  { path: 'create-competition', component: CreateCompetitionComponent },
  { path: 'home', component: HomepageComponent },
  { path: 'sign-in', component: SignInComponent },
  { path: 'visual', component: VisualComponent },
  { path: '', redirectTo: '/home', pathMatch: 'full' },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
