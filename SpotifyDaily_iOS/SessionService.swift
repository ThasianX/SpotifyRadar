//
//  SessionService.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/24/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import RxSwift

class SessionService: Authentication {
    func signIn() -> Single<SignInResponse> {
        return Single<SignInResponse>.create { single in
            // call to backend
            single(.success(SignInResponse(token: "12345", userId: "5678")))
            return Disposables.create()
        }
    }
}
