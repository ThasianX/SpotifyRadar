//
//  DrawerMenuViewModel.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import RxSwift

class DrawerMenuViewModel {
    
    private let disposeBag = DisposeBag()
    private let sessionService: SessionService
    private let dataManager: DataManager
    
    let didSelectScreen = BehaviorSubject(value: DrawerMenuScreen.dashboard)
    
    let menuItems = Observable.just([
        "New Releases",
        "Dashboard",
        "Settings"
    ])
    
    init(sessionService: SessionService, dataManager: DataManager) {
        self.sessionService = sessionService
        self.dataManager = dataManager
    }
    
    deinit {
        Logger.info("DrawerMenuViewModel dellocated")
    }
}
