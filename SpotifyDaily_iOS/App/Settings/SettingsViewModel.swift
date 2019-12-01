//
//  SettingsViewModel.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import RxSwift

class SettingsViewModel {
    
    let sessionService: SessionService
    let dataManager: DataManager
    private let disposeBag = DisposeBag()
    
    let userSubject: BehaviorSubject<User?>
    
    let title = "Settings"
    
    init(sessionService: SessionService, dataManager: DataManager) {
        self.sessionService = sessionService
        self.dataManager = dataManager
        self.userSubject = BehaviorSubject<User?>(value: sessionService.sessionState?.user)
    }
    
    // TODO: Debug what's going on. Getting nil for user
    func refreshProfile(){
        sessionService.refreshProfile()
        .bind(onNext: { [weak self] user in
            Logger.info("Refresh profile user is \(user)")
            self?.userSubject.onNext(user)
        })
        .disposed(by: disposeBag)
    }
    
    func logout(){
        sessionService.signOut()
    }
}
