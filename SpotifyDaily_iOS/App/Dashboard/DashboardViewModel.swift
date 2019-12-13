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

protocol DashboardViewModelInput {
    func artistSelected(from viewController: (UIViewController), artist: Artist)
    func trackSelected(from viewController: (UIViewController), track: Track)
    func recentTrackSelected(from viewController: (UIViewController), track: RecentlyPlayedTrack)
    
    var presentTopArtists: PublishSubject<Void> { get }
    var presentTopTracks: PublishSubject<Void> { get }
    var presentRecentlyPlayed: PublishSubject<Void> { get }
    
    var childDismissed: PublishSubject<Void> { get }
}

protocol DashboardViewModelOutput {
    var topArtistsCellModelType: Observable<[ArtistCollectionCellViewModelType]> { get }
    var topTracksCellModelType: Observable<[TrackCollectionCellViewModelType]> { get }
    var recentlyPlayedCellModelType: Observable<[RecentlyPlayedCellViewModelType]> { get }
}

protocol DashboardViewModelType {
    var input: DashboardViewModelInput { get }
    var output: DashboardViewModelOutput { get }
}

class DashboardViewModel: DashboardViewModelType, DashboardViewModelInput, DashboardViewModelOutput {
    // MARK: Inputs & Outputs
    var input: DashboardViewModelInput { return self }
    var output: DashboardViewModelOutput { return self }
    
    // MARK: - Properties
    // MARK: Dependencies
    private let sessionService: SessionService
    private let dataManager: DataManager
    private let safariService: SafariService
    
    // MARK: Private fields
    private let disposeBag = DisposeBag()
    
    // MARK: Inputs
    func artistSelected(from viewController: (UIViewController), artist: Artist) {
        safariService.presentSafari(from: viewController, for: artist.externalURL)
    }
    
    func trackSelected(from viewController: (UIViewController), track: Track) {
        safariService.presentSafari(from: viewController, for: track.externalURL)
    }
    
    func recentTrackSelected(from viewController: (UIViewController), track: RecentlyPlayedTrack) {
        safariService.presentSafari(from: viewController, for: track.externalURL)
    }
    
    let presentTopArtists = PublishSubject<Void>()
    let presentTopTracks = PublishSubject<Void>()
    let presentRecentlyPlayed = PublishSubject<Void>()
    
    let childDismissed = PublishSubject<Void>()
    
    // MARK: Outputs
    lazy var topArtistsCellModelType: Observable<[ArtistCollectionCellViewModelType]> = {
        return artistCollections.mapMany { ArtistCollectionCellViewModel(artist: $0) }
    }()
    
    lazy var topTracksCellModelType: Observable<[TrackCollectionCellViewModelType]> = {
        return trackCollections.mapMany { TrackCollectionCellViewModel(track: $0) }
    }()
    
    lazy var recentlyPlayedCellModelType: Observable<[RecentlyPlayedCellViewModelType]> = {
        return recentlyPlayedCollections.mapMany { RecentlyPlayedCellViewModel(track: $0) }
    }()
    
    // MARK: Private
    private var artistCollections: Observable<[Artist]>!
    private var trackCollections: Observable<[Track]>!
    private var recentlyPlayedCollections: Observable<[RecentlyPlayedTrack]>!
    
    // MARK: - Initialization
    init(sessionService: SessionService, dataManager: DataManager, safariService: SafariService) {
        self.sessionService = sessionService
        self.dataManager = dataManager
        self.safariService = safariService
        
        guard let artistsCollectionState = self.dataManager.get(key: DataKeys.topArtistsCollectionState, type: TopArtistsViewControllerState.self) else { return }
        
        guard let tracksCollectionState = self.dataManager.get(key: DataKeys.topTracksCollectionState, type: TopTracksViewControllerState.self) else { return }
        
        artistCollections = self.sessionService.getTopArtists(timeRange: artistsCollectionState.artistsTimeRange, limit: 2)
        
        trackCollections = self.sessionService.getTopTracks(timeRange: tracksCollectionState.tracksTimeRange, limit: 2)
        
        recentlyPlayedCollections = self.sessionService.getRecentlyPlayedTracks(limit: 3)
    }
    
    deinit {
        Logger.info("DashboardViewModel dellocated")
    }
    
}
