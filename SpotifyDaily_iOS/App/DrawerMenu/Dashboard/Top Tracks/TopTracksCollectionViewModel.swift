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
    /// Call when the bottom of the list is reached
    var loadMore: BehaviorSubject<Bool> { get }
    
    /// Call when a time range is selected for querying the user's top artists
    var tracksTimeRange: BehaviorRelay<String> { get }
    
    /// Call when a limit for the number of artists is selected for querying the user's top artists
    var tracksLimit: BehaviorRelay<Int> { get }

     /// Call when an artist is selected
    func trackSelected(track: Track)
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
    let loadMore = BehaviorSubject<Bool>(value: false)
    
    func trackSelected(track: Track) {
        
    }

    // MARK: Outputs
    lazy var collectionCellsModelType: Observable<[TrackCollectionCellViewModelType]> = {
        return trackCollections.mapMany { TrackCollectionCellViewModel(track: $0) }
    }()
    
    var title: Observable<String>!

    // MARK: Private
    private let sessionService: SessionService
    private let dataManager: DataManager
    
    private let disposeBag = DisposeBag()
    private var trackCollections: Observable<[Track]>!
    
    var tracksTimeRange = BehaviorRelay<String>(value: "")
    var tracksLimit = BehaviorRelay<Int>(value: 0)

    // MARK: Init
    init(sessionService: SessionService, dataManager: DataManager) {

        self.sessionService = sessionService
        self.dataManager = dataManager
        
        // Initializing utputs
        title = Observable.just("Your Top Tracks")
        
        guard let artistsCollectionState = self.dataManager.get(key: DataKeys.topArtistsCollectionState, type: ArtistsCollectionViewControllerState.self) else { return }
        
        self.tracksTimeRange.accept(artistsCollectionState.artistsTimeRange)
        self.tracksLimit.accept(artistsCollectionState.artistsLimit)
        
        trackCollections = Observable.combineLatest(self.tracksTimeRange, self.tracksLimit)
            .flatMap { timeRange, limit -> Observable<[Track]> in
                let newDashboardState = TopTracksViewControllerState(tracksTimeRange: timeRange, tracksLimit: limit)
                self.dataManager.set(key: DataKeys.topTracksCollectionState, value: newDashboardState)
                return self.sessionService.getTopTracks(timeRange: timeRange, limit: limit)
        }
    }
}

