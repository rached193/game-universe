import { Component, OnInit } from '@angular/core';
import { AuthenticationService } from '../core/autentication.service';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.scss']
})
export class NavbarComponent implements OnInit {

  currentUser;

  constructor(private authenticationService: AuthenticationService) { }

  ngOnInit() {
    this.currentUser = this.authenticationService.currentUser;
  }

}
