//
//  NewReleasesViewModel.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/16/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol NewReleasesViewModelInput {
    func trackSelected(from viewController: (UIViewController), track: NewTrack)
    
    var presentEditPortfolio: PublishSubject<Void> { get }
    
    var childDismissed: PublishSubject<Void> { get }
}

protocol NewReleasesViewModelOutput {
    var newTracksCellModelType: Observable<[NewTracksCellViewModelType]> { get }
}

protocol NewReleasesViewModelType {
    var input: NewReleasesViewModelInput { get }
    var output: NewReleasesViewModelOutput { get }
}

class NewReleasesViewModel: NewReleasesViewModelType, NewReleasesViewModelInput, NewReleasesViewModelOutput {
    // MARK: Inputs & Outputs
    var input: NewReleasesViewModelInput { return self }
    var output: NewReleasesViewModelOutput { return self }
    
    // MARK: - Properties
    // MARK: Dependencies
    private let sessionService: SessionService
    private let dataManager: DataManager
    private let safariService: SafariService
    
    // MARK: Private fields
    private let disposeBag = DisposeBag()
    
    // MARK: Inputs
    func trackSelected(from viewController: (UIViewController), track: NewTrack) {
        safariService.presentSafari(from: viewController, for: track.externalURL)
    }
    
    let presentEditPortfolio = PublishSubject<Void>()
    
    let childDismissed = PublishSubject<Void>()
    
    // MARK: Outputs
    lazy var newTracksCellModelType: Observable<[NewTracksCellViewModelType]> = {
        return newTracks.mapMany { NewTracksCellViewModel(track: $0) }
    }()
    
    // MARK: Private
    private var newTracks: Observable<[NewTrack]>!
    
    // MARK: - Initialization
    init(sessionService: SessionService, dataManager: DataManager, safariService: SafariService) {
        self.sessionService = sessionService
        self.dataManager = dataManager
        self.safariService = safariService
        
        // Scan through portfolio artists and append new tracks to newTracks
        newTracks = Observable.just([NewTrack(trackName: "fds", albumName: "dss", artistNames: ["Micheal","dss"], duration: "43", externalURL: URL(string: "fdfd")!)])
    }
    
    deinit {
        Logger.info("NewReleasesViewModel dellocated")
    }
    
}
