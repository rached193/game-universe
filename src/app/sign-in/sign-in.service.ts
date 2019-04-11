import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class SignInService {



  constructor(private http: HttpClient) { }


  registerUser(user): Observable<number> {
    return this.http.post<number>('register', user)
      // .pipe(
      //   catchError(this.handleError('addHero', hero))
      // );
  }

  handleError(a, b) {
    return 1;
  }

}
