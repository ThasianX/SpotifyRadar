//
//  ArtistsCollectionViewModel.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/4/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol TopArtistsCollectionsViewModelInput {
    
    /// Call when a time range is selected for querying the user's top artists
    var artistsTimeRange: BehaviorRelay<String> { get }
    
     /// Call when an artist is selected
    func artistSelected(from viewController: (UIViewController), artist: Artist)
    
    /// Call when view controller is dismissed
    var dismissed: PublishSubject<Void> { get }
}
protocol TopArtistsCollectionsViewModelOutput {
    /// Emites the child viewModels
    var collectionCellsModelType: Observable<[ArtistCollectionCellViewModelType]> { get }
    
    var title: Observable<String>! { get }
}
protocol TopArtistsCollectionsViewModelType {
    var input: TopArtistsCollectionsViewModelInput { get }
    var output: TopArtistsCollectionsViewModelOutput { get }
}

class TopArtistsCollectionViewModel: TopArtistsCollectionsViewModelType,
                            TopArtistsCollectionsViewModelInput,
                            TopArtistsCollectionsViewModelOutput {
    // MARK: Inputs & Outputs
    var input: TopArtistsCollectionsViewModelInput { return self }
    var output: TopArtistsCollectionsViewModelOutput { return self }

    // MARK: Inputs
    func artistSelected(from viewController: (UIViewController), artist: Artist) {
        safariService.presentSafari(from: viewController, for: artist.externalURL)
    }
    
    let dismissed = PublishSubject<Void>()
    
    // MARK: Outputs
    lazy var collectionCellsModelType: Observable<[ArtistCollectionCellViewModelType]> = {
        return artistCollections.mapMany { ArtistCollectionCellViewModel(artist: $0) }
    }()
    
    var title: Observable<String>!

    // MARK: Private
    private let sessionService: SessionService
    private let dataManager: DataManager
    private let safariService: SafariService
    
    private let disposeBag = DisposeBag()
    private var artistCollections: Observable<[Artist]>!
    
    var artistsTimeRange: BehaviorRelay<String>

    // MARK: Init
    init(sessionService: SessionService, dataManager: DataManager, safariService: SafariService) {

        self.sessionService = sessionService
        self.dataManager = dataManager
        self.safariService = safariService
        
        // Initializing utputs
        title = Observable.just("Your Top Artists")
        
        let artistsCollectionState = self.dataManager.get(key: DataKeys.topArtistsCollectionState, type: TopArtistsViewControllerState.self)!
        
       
        self.artistsTimeRange = BehaviorRelay<String>(value: artistsCollectionState.artistsTimeRange)
       
        artistCollections = self.artistsTimeRange
            .flatMap { [unowned self] timeRange -> Observable<[Artist]> in
                let newDashboardState = TopArtistsViewControllerState(artistsTimeRange: timeRange)
                self.dataManager.set(key: DataKeys.topArtistsCollectionState, value: newDashboardState)
                return self.sessionService.getTopArtists(timeRange: timeRange, limit: 50)
        }
    }
    
    deinit {
        Logger.info("TopArtistsCollectionViewModel dellocated")
    }
}
