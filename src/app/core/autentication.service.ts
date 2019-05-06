// Angular Dependences
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';

// @types
import { Observable, Subject } from 'rxjs';
import { User } from './model/user';

@Injectable({
  providedIn: 'root'
})
export class AuthenticationService {


  private _currentUser: User;

  get currentUser() {
    // Freeze user
    return Object.assign({}, this._currentUser);
  }

  constructor(private http: HttpClient) { }

  registerUser(user: User): Observable<boolean> {
    const register = new Subject<boolean>();

    this.http.post<boolean>('register', user).subscribe(response => {
      if (response) {
        this._currentUser = user;
      }
      register.next(response);
    });
    return register;
  }

  loginUser(userLogin: string, password: string): Observable<boolean> {
    const register = new Subject<boolean>();
    this.http.post<User | false>('auhtenticate', { userLogin, password }).subscribe(response => {

      if (response instanceof User && (response as User).userLogin) {
        this._currentUser = response;
        register.next(true);
      } else {
        register.next(false);
      }
    });

    return register;
  }

}
