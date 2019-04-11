import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { SignInService } from './sign-in.service';

@Component({
  selector: 'app-sign-in',
  templateUrl: './sign-in.component.html',
  styleUrls: ['./sign-in.component.scss']
})
export class SignInComponent implements OnInit {

  userForm: FormGroup;

  constructor(private formBuilder: FormBuilder, private signInService: SignInService) { }

  ngOnInit() {
    this.userForm = this.formBuilder.group({
      login: [''],
      name: [''],
      password: [''],
    });
  }

  onSubmit(f) {
    console.log('helllo');
    this.signInService.registerUser(f.value).subscribe((response) => {
      console.log('repsonse ', response);
    });
  }
}
