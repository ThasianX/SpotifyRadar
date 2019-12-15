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
    func artistSelected(from viewController: (UIViewController), track: Artist)
    
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
    func artistSelected(from viewController: (UIViewController), track: Artist) {
        // Present an alert asking if the user wants to add the artist
    }
    
    let searchText = PublishSubject<String>()
    
    // MARK: Outputs
    lazy var tableViewCellsModelType: Observable<[SearchArtistCellViewModelType]> = {
        return artistResults.mapMany { SearchArtistCellViewModel(artist: $0, inPortfolio: false) }
    }()
    
    let title = "Search Artists"
    
    // MARK: Private
    private let sessionService: SessionService
    private let dataManager: DataManager
    private let safariService: SafariService
    
    private let disposeBag = DisposeBag()
    private var artistResults: Observable<[Artist]>!
    
    // MARK: Init
    init(sessionService: SessionService, dataManager: DataManager, safariService: SafariService) {
        
        self.sessionService = sessionService
        self.dataManager = dataManager
        self.safariService = safariService
        
        // Initializing utputs
        
        // TODO: Initialize observable for artist results
        // TODO: Make a data structure to store user portfolio info and quert it to determine the inPortfolio boolean value
    }
    
    deinit {
        Logger.info("SearchArtistsViewModel dellocated")
    }
}
