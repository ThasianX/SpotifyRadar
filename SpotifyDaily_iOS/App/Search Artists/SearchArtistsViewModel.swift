//
//  RecommendationsViewModel.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchArtistsViewModelViewModelInput {
    /// Call when an artist is selected
    func artistSelected(from viewController: (UIViewController), artist: Artist)
    
    /// Call when user inputs text into search bar
    var searchText: PublishSubject<String> { get }
}
protocol SearchArtistsViewModelViewModelOutput {
    /// Emites the child viewModels
    var tableViewCellsModelType: Observable<[SearchArtistCellViewModelType]> { get }
    
    var title: String { get }
}
protocol SearchArtistsViewModelViewModelType {
    var input: SearchArtistsViewModelViewModelInput { get }
    var output: SearchArtistsViewModelViewModelOutput { get }
}

class SearchArtistsViewModel: SearchArtistsViewModelViewModelType,
    SearchArtistsViewModelViewModelInput,
SearchArtistsViewModelViewModelOutput {
    // MARK: Inputs & Outputs
    var input: SearchArtistsViewModelViewModelInput { return self }
    var output: SearchArtistsViewModelViewModelOutput { return self }
    
    // MARK: Inputs
    func artistSelected(from viewController: (UIViewController), artist: Artist) {
        portfolioArtists.insert(artist)
    }
    
    let searchText = PublishSubject<String>()
    
    // MARK: Outputs
    lazy var tableViewCellsModelType: Observable<[SearchArtistCellViewModelType]> = {
        return artistResults.mapMany { [unowned self] in SearchArtistCellViewModel(artist: $0, inPortfolio: self.portfolioArtists.contains($0)) }
    }()
    
    let title = "Search Artists"
    
    // MARK: Private
    private let sessionService: SessionService
    private let dataManager: DataManager
    private let safariService: SafariService
    
    private let disposeBag = DisposeBag()
    private var artistResults: Observable<[Artist]>!
    private var portfolioArtists: Set<Artist>
    
    // MARK: Init
    init(sessionService: SessionService, dataManager: DataManager, safariService: SafariService) {
        
        self.sessionService = sessionService
        self.dataManager = dataManager
        self.safariService = safariService
        
        let artistPortfolioState = self.dataManager.get(key: DataKeys.artistPortfolioState, type: ArtistPortfolioState.self)!
        
        self.portfolioArtists = artistPortfolioState.artists
        
        searchText.bind(onNext: { [unowned self] text in
            self.artistResults = self.sessionService.searchArtistResults(query: text, limit: 15)
        })
        .disposed(by: disposeBag)
        
    }
    
    deinit {
        Logger.info("SearchArtistsViewModel dellocated")
    }
}
