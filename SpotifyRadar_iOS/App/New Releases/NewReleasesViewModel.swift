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
    
    var sliderValue: BehaviorRelay<Float> { get }
}

protocol NewReleasesViewModelOutput {
    var newTracksCellModelType: Observable<[NewTracksCellViewModelType]> { get }
    var emptyPortfolio: BehaviorRelay<Bool> { get }
    var emptyTracks: BehaviorRelay<Bool> { get }
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
    let sliderValue: BehaviorRelay<Float>
    
    // MARK: Outputs
    lazy var newTracksCellModelType: Observable<[NewTracksCellViewModelType]> = {
        return newTracks.mapMany {
            return NewTracksCellViewModel(track: $0)
        }
    }()
    
    let emptyPortfolio = BehaviorRelay<Bool>(value: false)
    let emptyTracks = BehaviorRelay<Bool>(value: false)
    
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
        
        let newReleasesTimeRange = self.dataManager.get(key: DataKeys.newReleasesTimeRange, type: Float.self)!
        self.sliderValue = BehaviorRelay<Float>(value: newReleasesTimeRange)
        
        newTracks = Observable.combineLatest(portfolioArtists, sliderValue)
            .flatMapLatest { [unowned self] artists, value -> Observable<[NewTrack]> in
                artists.isEmpty ? self.emptyPortfolio.accept(true) : self.emptyPortfolio.accept(false)
                
                var observable = Observable<[NewTrack]>.just([])
                for artist in artists {
                    observable = observable.concat(self.sessionService.getNewTracksForArtist(artist: artist, months: Double(value))).scan([], accumulator: +)
                }
                return observable
        }
        
        newTracks.bind(onNext: { [unowned self] tracks in
            Logger.info("Newtracks bind: \(tracks.isEmpty) && \(!self.emptyPortfolio.value)")
            tracks.isEmpty ? self.emptyTracks.accept(true) : self.emptyTracks.accept(false)
        })
            .disposed(by: disposeBag)
        
        // Skips the initial behavior value and also the initial value call from the view controller's slider
        sliderValue.skip(2).bind(onNext: { [unowned self] value in
            self.dataManager.set(key: DataKeys.newReleasesTimeRange, value: value)
        })
            .disposed(by: disposeBag)
        
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
