import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { AuthenticationService } from '../core/autentication.service';

@Component({
  selector: 'app-sign-in',
  templateUrl: './sign-in.component.html',
  styleUrls: ['./sign-in.component.scss']
})
export class SignInComponent implements OnInit {

  userForm: FormGroup;

  constructor(private formBuilder: FormBuilder, private autenticationService: AuthenticationService) { }

  ngOnInit() {
    this.userForm = this.formBuilder.group({
      
      login: [''],
      name: [''],
      password: [''],
    });
  }

  onSubmit(f) {
    this.autenticationService.registerUser(f.value).subscribe((result) => {


    });
  }
}
