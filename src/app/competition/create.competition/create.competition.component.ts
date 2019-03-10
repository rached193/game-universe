import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';

@Component({
  selector: 'app-create-competition',
  templateUrl: './create.competition.component.html',
  styleUrls: ['./create.competition.component.scss']
})
export class CreateCompetitionComponent implements OnInit {

  competitionForm: FormGroup;

  videogames = [
    {
      id: 1,
      name: 'League of Legends'
    }
  ];
  platforms = [
    {
      id: 1,
      name: 'PC'
    }
  ];
  regions = [
    {
      id: 1,
      name: 'EUW'
    }
  ];
  modes = [
    {
      id: 1,
      name: '5 vs 5'
    }
  ];

  constructor() {
    this.competitionForm = this.createFormGroup();
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

  onSubmit() {

  }

  revert() {

  }
}
