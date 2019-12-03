//
//  DashboardViewModel.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import RxSwift

class DashboardViewModel {
    
    private let sessionService: SessionService
    private let dataManager: DataManager
    private let disposeBag = DisposeBag()
    
    let title = "Dashboard"
    var state: BehaviorSubject<DashboardViewControllerState>
    
    // TODO: Add a call to session service to retrieve a list of artists
    init(sessionService: SessionService, dataManager: DataManager) {
        self.sessionService = sessionService
        self.dataManager = dataManager
        
        self.state = BehaviorSubject<DashboardViewControllerState>(value: DashboardViewControllerState(artistsTimeRange: "medium_term", artistsLimit: 5))
        
        self.loadState()
    }
    
    private func loadState() {
        if let dashboardState = self.dataManager.get(key: DataKeys.dashboardState, type: DashboardViewControllerState.self) {
            state.onNext(dashboardState)
        }
    }
    
    private func updateState(dashboardState: DashboardViewControllerState) {
        self.dataManager.set(key: DataKeys.dashboardState, value: dashboardState)
    }
    
}
