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
    let presentTopArtists = PublishSubject<Void>()
    let presentTopTracks = PublishSubject<Void>()
    let presentRecentlyPlayed = PublishSubject<Void>()
    let title = "User Dashboard"
    
    // MARK: - Initialization
    init(sessionService: SessionService, dataManager: DataManager) {
        self.sessionService = sessionService
        self.dataManager = dataManager
        
        presentRecentlyPlayed
            .bind(onNext: { self.printRecentlyPlayed() })
        .disposed(by: disposeBag)
    }
    
    private func printRecentlyPlayed() {
        Logger.info("Printing recently played tracks")
        
        let tracks = sessionService.getRecentlyPlayedTracks(limit: 10)
        
        tracks.bind(onNext: {
            for track in $0 {
                Logger.info("\(track)")
            }
        })
        .disposed(by: disposeBag)
    }
}
