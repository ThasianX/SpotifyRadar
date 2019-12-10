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
    /// Call when the bottom of the list is reached
    var loadMore: BehaviorSubject<Bool> { get }

     /// Call when an artist is selected
    func trackSelected(from viewController: (UIViewController), track: RecentlyPlayedTrack)
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
    let loadMore = BehaviorSubject<Bool>(value: false)
    
    func trackSelected(from viewController: (UIViewController), track: RecentlyPlayedTrack){
        safariService.presentSafari(from: viewController, for: track.externalURL)
    }

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
        
        trackCollections = sessionService.getRecentlyPlayedTracks(limit: 10)
            .flatMapLatest { [unowned self] tracks -> Observable<[RecentlyPlayedTrack]> in
                var updatedTracks = [RecentlyPlayedTrack]()
                
                for track in tracks {
                    var urls = [URL]()
                    for url in track.artistURLs {
                        self.sessionService.getArtist(href: url)
                            .bind(onNext: { urls.append($0.image)})
                            .disposed(by: self.disposeBag)
                    }
                    
                    let updatedTrack = RecentlyPlayedTrack(trackName: track.trackName, albumName: track.albumName, artistURLs: urls, duration: track.duration, playedFrom: track.playedFrom, playedAt: track.playedFrom, externalURL: track.externalURL)
                    updatedTracks.append(updatedTrack)
                }
                
                return Observable.just(updatedTracks)
        }
    }
}

