//
//  RecentlyPlayedTracksViewModel.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/9/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol RecentlyPlayedTracksViewModelInput {
    /// Call when an artist is selected
    func trackSelected(from viewController: (UIViewController), track: RecentlyPlayedTrack)
    
    /// Call when view controller is dismissed
    var dismissed: PublishSubject<Void> { get }
}
protocol RecentlyPlayedTracksViewModelOutput {
    /// Emites the child viewModels
    var tableViewCellsModelType: Observable<[RecentlyPlayedCellViewModelType]> { get }
    
    /// Emits the title of the view controller
    var title: Observable<String>! { get }
}
protocol RecentlyPlayedTracksViewModelType {
    var input: RecentlyPlayedTracksViewModelInput { get }
    var output: RecentlyPlayedTracksViewModelOutput { get }
}

class RecentlyPlayedTracksViewModel: RecentlyPlayedTracksViewModelType,
    RecentlyPlayedTracksViewModelInput,
RecentlyPlayedTracksViewModelOutput {
    // MARK: Inputs & Outputs
    var input: RecentlyPlayedTracksViewModelInput { return self }
    var output: RecentlyPlayedTracksViewModelOutput { return self }
    
    // MARK: Inputs
    func trackSelected(from viewController: (UIViewController), track: RecentlyPlayedTrack){
        safariService.presentSafari(from: viewController, for: track.externalURL)
    }
    
    let dismissed = PublishSubject<Void>()
    
    // MARK: Outputs
    lazy var tableViewCellsModelType: Observable<[RecentlyPlayedCellViewModelType]> = {
        return trackCollections.mapMany { RecentlyPlayedCellViewModel(track: $0) }
    }()
    
    var title: Observable<String>!
    
    // MARK: Private
    private let sessionService: SessionService
    private let dataManager: DataManager
    private let safariService: SafariService
    
    private let disposeBag = DisposeBag()
    private var trackCollections: Observable<[RecentlyPlayedTrack]>!
    
    // MARK: Init
    init(sessionService: SessionService, dataManager: DataManager, safariService: SafariService) {
        
        self.sessionService = sessionService
        self.dataManager = dataManager
        self.safariService = safariService
        
        // Initializing utputs
        title = Observable.just("Your Recently Played Tracks")
        
        trackCollections = sessionService.getRecentlyPlayedTracks(limit: 50)
            .flatMapLatest { [unowned self] tracks -> Observable<[RecentlyPlayedTrack]> in
                var updatedTracks = [RecentlyPlayedTrack]()
                
                for track in tracks {
                    var urls = [URL]()
                    for url in track.artistURLs {
                        self.sessionService.getArtist(href: url)
                            .compactMap { $0.image }
                            .bind(onNext: {
                                Logger.info("Artist Image: \($0.absoluteString)")
                                urls.append($0)
                            })
                            .disposed(by: self.disposeBag)
                    }
                    let updatedTrack = RecentlyPlayedTrack(trackName: track.trackName, albumName: track.albumName, artistURLs: urls, duration: track.duration, playedAt: track.playedAt, externalURL: track.externalURL)
                    updatedTracks.append(updatedTrack)
                }
                
                return Observable.just(updatedTracks)
        }
    }
    
    deinit {
        Logger.info("RecentlyPlayedTracksViewModel dellocated")
    }
}

