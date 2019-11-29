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
    private let sessionService: SessionService
    private let disposeBag = DisposeBag()
    
    let isLoading = BehaviorSubject<Bool>(value: false)
    
    init(sessionService: SessionService) {
        self.sessionService = sessionService
    }
    
    func signIn() {
        self.isLoading.onNext(true)
        
        Observable.create { observer in
            self.sessionService.signIn()
        }
        
        Observable
            .combineLatest(self.email, self.password, self.isSignInActive)
            .take(1)
            .filter { _, _, active in active }
            .map { username, password, _ in Credentials(username: username, password: password) }
            .flatMapLatest { [weak self] in self?.sessionService.signIn(credentials: $0) ?? Completable.empty() }
            .subscribe { [weak self] _ in self?.isLoading.onNext(false) }
            .disposed(by: self.disposeBag)
    }
}
