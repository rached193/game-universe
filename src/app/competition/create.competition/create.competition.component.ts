import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';

@Component({
  selector: 'app-create-competition',
  templateUrl: './create.competition.component.html',
  styleUrls: ['./create.competition.component.scss']
})
export class CreateCompetitionComponent implements OnInit {

  contactForm: FormGroup;

  regions = ['USA', 'Europe'];
  platforms = ['PC', 'Switch', 'Ps4'];

  constructor() {
    this.contactForm = this.createFormGroup();
  }

  ngOnInit() {
  }

  createFormGroup() {
    return new FormGroup({
      name: new FormControl(),
      videogame: new FormControl(),
      platform: new FormControl(),
      region: new FormControl(),
      mode: new FormControl()
    }
    );
  }
}
