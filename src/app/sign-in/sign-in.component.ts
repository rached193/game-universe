import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { AuthenticationService } from '../core/autentication.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-sign-in',
  templateUrl: './sign-in.component.html',
  styleUrls: ['./sign-in.component.scss']
})
export class SignInComponent implements OnInit {

  userForm: FormGroup;

  constructor(private formBuilder: FormBuilder, private autenticationService: AuthenticationService, private router: Router) { }

  ngOnInit() {
    this.userForm = this.formBuilder.group({

      login: [''],
      name: [''],
      password: [''],
    });
  }

  onSubmit(f) {
    this.autenticationService.registerUser(f.value).subscribe((result) => {
      if (result) {
        this.router.navigate(['home']);
      } else {
      }
    });
  }
}
