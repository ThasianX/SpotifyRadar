//
//  DashboardViewModel.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DashboardViewModel {
    
    // MARK: - Properties
    // MARK: Dependencies
    private let sessionService: SessionService
    private let dataManager: DataManager
    
    // MARK: Private fields
    private let disposeBag = DisposeBag()
    
    // MARK: Public fields
    let title = "Dashboard"
    let artistsTimeRange = BehaviorRelay<String>(value: "")
    let artistsLimit = BehaviorRelay<Int>(value: 0)
    let artists = BehaviorRelay<[Artist]>(value: [])
    
    let songsTimeRange = BehaviorRelay<String>(value: "")
    let songsLimit = BehaviorRelay<Int>(value: 0)
    let songs = BehaviorRelay<[Artist]>(value: [])
    
    let timeRangeItems = [
        "short_term",
        "medium_term",
        "long_term"
    ]
    
    init(sessionService: SessionService, dataManager: DataManager) {
        self.sessionService = sessionService
        self.dataManager = dataManager
        
        guard let dashboardState = self.dataManager.get(key: DataKeys.dashboardState, type: DashboardViewControllerState.self) else { return }
        
        self.artistsTimeRange.accept(dashboardState.artistsTimeRange)
        self.artistsLimit.accept(dashboardState.artistsLimit)
        self.songsTimeRange.accept(dashboardState.songsTimeRange)
        self.songsLimit.accept(dashboardState.songsLimit)
        
        self.setUpBindings()
    }
    
    private func setUpBindings() {
        Observable.combineLatest(self.artistsTimeRange, self.artistsLimit)
            .flatMap { timeRange, limit -> Observable<[Artist]> in
                return self.sessionService.getTopArtists(timeRange: timeRange, limit: limit)
        }
        .bind(to: artists)
        .disposed(by: self.disposeBag)
        
        Observable.combineLatest(self.artistsTimeRange, self.artistsLimit, self.songsTimeRange, self.songsLimit)
            .bind(onNext: { aTime, aLimit, sTime, sLimit in
                Logger.info("New dashboard state")
                let newDashboardState = DashboardViewControllerState(artistsTimeRange: aTime, artistsLimit: aLimit, songsTimeRange: sTime, songsLimit: sLimit)
                self.dataManager.set(key: DataKeys.dashboardState, value: newDashboardState)
            })
            .disposed(by: self.disposeBag)
    }
    
}
