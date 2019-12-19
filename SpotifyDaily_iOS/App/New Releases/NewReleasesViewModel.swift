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
    
    var presentPortfolio: PublishSubject<Void> { get }
    
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
    
    let presentPortfolio = PublishSubject<Void>()
    let childDismissed = PublishSubject<Void>()
    
    // MARK: Outputs
    lazy var newTracksCellModelType: Observable<[NewTracksCellViewModelType]> = {
        return newTracks.mapMany { NewTracksCellViewModel(track: $0) }
    }()
    
    // MARK: Private
    private var newTracks: Observable<[NewTrack]>!
    private var portfolioArtists: BehaviorRelay<[Artist]>
    
    // MARK: - Initialization
    init(sessionService: SessionService, dataManager: DataManager, safariService: SafariService) {
        self.sessionService = sessionService
        self.dataManager = dataManager
        self.safariService = safariService
        
        let userPortfolioState = self.dataManager.get(key: DataKeys.userPortfolioState, type: UserPortfolioState.self)!
        
        self.portfolioArtists = BehaviorRelay<[Artist]>(value: userPortfolioState.artists)
        
        newTracks = portfolioArtists
            .distinctUntilChanged()
            .flatMapLatest { [unowned self] artists -> Observable<[NewTrack]> in
                var observable = Observable<[NewTrack]>.empty()
                for artist in artists {
                    observable = observable.concat(self.sessionService.getNewTracksForArtist(artist: artist)).scan([], accumulator: +)
                }
                return observable
        }
        
        childDismissed.bind(onNext: { [unowned self] in
            let userPortfolioState = self.dataManager.get(key: DataKeys.userPortfolioState, type: UserPortfolioState.self)!
            self.portfolioArtists.accept(userPortfolioState.artists)
        })
        .disposed(by: disposeBag)
    }
    
    deinit {
        Logger.info("NewReleasesViewModel dellocated")
    }
}
