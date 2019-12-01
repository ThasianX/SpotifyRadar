//
//  SignInViewModel.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

class SignInViewModel {
    
    private let loginPresenter: SpotifyLoginPresenter
    
    init(loginPresenter: SpotifyLoginPresenter) {
        self.loginPresenter = loginPresenter
    }
    
    func presentSignInBrowser(vc: SignInViewController){
        loginPresenter.login(from: vc, scopes: [.userReadPrivate, .userReadEmail])
    }
}
