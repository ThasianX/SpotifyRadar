//
//  SignInViewModel.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

class SignInViewModel {
    
    private let safariService: SafariService
    
    init(safariService: SafariService) {
        self.safariService = safariService
    }
    
    deinit {
        Logger.info("SignInViewModel dellocated")
    }
    
    func presentSignInBrowser(vc: SignInViewController){
        safariService.login(from: vc, scopes: [.userReadPrivate, .userReadEmail, .userReadTop, .userReadRecentlyPlayed])
    }
}
