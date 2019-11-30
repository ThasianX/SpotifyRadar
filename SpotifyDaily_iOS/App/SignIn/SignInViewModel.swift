//
//  SignInViewModel.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

import RxSwift

class SignInViewModel {
    let sessionService: SessionService
    private let disposeBag = DisposeBag()
    
    init(sessionService: SessionService) {
        self.sessionService = sessionService
    }
}
