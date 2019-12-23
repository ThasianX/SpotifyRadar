//
//  TopTracksCollectionViewModel.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/8/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol TopTracksCollectionsViewModelInput {
    /// Call when a time range is selected for querying the user's top artists
    var tracksTimeRange: BehaviorRelay<String> { get }

     /// Call when an artist is selected
    func trackSelected(from viewController: (UIViewController), track: Track)
    
    /// Call when view controller is dismissed
    var dismissed: PublishSubject<Void> { get }
}
protocol TopTracksCollectionsViewModelOutput {
    /// Emites the child viewModels
    var collectionCellsModelType: Observable<[TrackCollectionCellViewModelType]> { get }
    
    var title: Observable<String>! { get }
}
protocol TopTracksCollectionsViewModelType {
    var input: TopTracksCollectionsViewModelInput { get }
    var output: TopTracksCollectionsViewModelOutput { get }
}

class TopTracksCollectionViewModel: TopTracksCollectionsViewModelType,
                            TopTracksCollectionsViewModelInput,
                            TopTracksCollectionsViewModelOutput {
    // MARK: Inputs & Outputs
    var input: TopTracksCollectionsViewModelInput { return self }
    var output: TopTracksCollectionsViewModelOutput { return self }

    // MARK: Inputs
    func trackSelected(from viewController: (UIViewController), track: Track){
        safariService.presentSafari(from: viewController, for: track.externalURL)
    }
    
    let dismissed = PublishSubject<Void>()
    
    // MARK: Outputs
    lazy var collectionCellsModelType: Observable<[TrackCollectionCellViewModelType]> = {
        return trackCollections.mapMany { TrackCollectionCellViewModel(track: $0) }
    }()
    
    var title: Observable<String>!

    // MARK: Private
    private let sessionService: SessionService
    private let dataManager: DataManager
    private let safariService: SafariService
    
    private let disposeBag = DisposeBag()
    private var trackCollections: Observable<[Track]>!
    
    var tracksTimeRange: BehaviorRelay<String>

    // MARK: Init
    init(sessionService: SessionService, dataManager: DataManager, safariService: SafariService) {

        self.sessionService = sessionService
        self.dataManager = dataManager
        self.safariService = safariService
        
        // Initializing utputs
        title = Observable.just("Your Top Tracks")
        
        let tracksCollectionState = self.dataManager.get(key: DataKeys.topTracksCollectionState, type: TopTracksViewControllerState.self)!
        
        self.tracksTimeRange = BehaviorRelay<String>(value: tracksCollectionState.tracksTimeRange)
        
        trackCollections = self.tracksTimeRange
            .flatMap { [unowned self] timeRange -> Observable<[Track]> in
                let newDashboardState = TopTracksViewControllerState(tracksTimeRange: timeRange)
                self.dataManager.set(key: DataKeys.topTracksCollectionState, value: newDashboardState)
                return self.sessionService.getTopTracks(timeRange: timeRange, limit: 50)
        }
    }
    
    deinit {
        Logger.info("TopTracksCollectionViewModel dellocated")
    }
}
