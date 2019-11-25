//
//  Authentication.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/24/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import RxSwift

protocol Authentication {
    func signIn() -> Single<SignInResponse>
}
