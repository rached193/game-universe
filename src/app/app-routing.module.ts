import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { CreateCompetitionComponent } from './competition/create.competition/create.competition.component';
import { HomepageComponent } from './competition/homepage/homepage.component';

const routes: Routes = [
  { path: 'create-competition', component: CreateCompetitionComponent },
  { path: 'competition', component: HomepageComponent },
  { path: '', redirectTo: '/competition', pathMatch: 'full' },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
