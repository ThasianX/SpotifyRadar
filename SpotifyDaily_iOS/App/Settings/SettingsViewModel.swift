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
    
    let title = "Settings"
    
    init(sessionService: SessionService, dataManager: DataManager) {
        self.sessionService = sessionService
        self.dataManager = dataManager
    }
    
    func refreshProfile(){
        sessionService.refreshProfile()
    }
    
    func logout(){
        sessionService.signOut()
    }
}
