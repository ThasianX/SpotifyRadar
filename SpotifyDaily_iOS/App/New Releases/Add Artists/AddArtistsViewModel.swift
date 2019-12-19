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

protocol AddArtistsViewModelInput {
    /// Call when an artist is selected
    func artistSelected(from viewController: (UIViewController), artist: Artist)
    
    /// Call when user inputs text into search bar
    var searchText: PublishSubject<String> { get }
    
    /// Call when view controller is dismissed
    var dismissed: PublishSubject<Void> { get }
}
protocol AddArtistsViewModelOutput {
    /// Emites the child viewModels
    var tableViewCellsModelType: Observable<[SearchArtistCellViewModelType]> { get }
}
protocol AddArtistsViewModelViewModelType {
    var input: AddArtistsViewModelInput { get }
    var output: AddArtistsViewModelOutput { get }
}

class AddArtistsViewModel: AddArtistsViewModelViewModelType,
    AddArtistsViewModelInput,
AddArtistsViewModelOutput {
    // MARK: Inputs & Outputs
    var input: AddArtistsViewModelInput { return self }
    var output: AddArtistsViewModelOutput { return self }
    
    // MARK: Inputs
    func artistSelected(from viewController: (UIViewController), artist: Artist) {
        if !portfolioArtists.contains(artist) {
            portfolioArtists.append(artist)
            portfolioDates.append(Date())
            
            let state = UserPortfolioState(artists: portfolioArtists, dates: portfolioDates)
            dataManager.set(key: DataKeys.userPortfolioState, value: state)
            
            let alert = UIAlertController(title: "\(artist.name) was added to your portfolio", message: nil, preferredStyle: .alert)
            viewController.present(alert, animated: true, completion: nil)

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1){
              alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    let searchText = PublishSubject<String>()
    let dismissed = PublishSubject<Void>()
    
    // MARK: Outputs
    lazy var tableViewCellsModelType: Observable<[SearchArtistCellViewModelType]> = {
        return artistResults.mapMany { [unowned self] in SearchArtistCellViewModel(artist: $0, inPortfolio: self.portfolioArtists.contains($0)) }
    }()
    
    // MARK: Private
    private let sessionService: SessionService
    private let dataManager: DataManager
    private let safariService: SafariService
    
    private let disposeBag = DisposeBag()
    private var artistResults: Observable<[Artist]>!
    private var portfolioArtists: [Artist]!
    private var portfolioDates: [Date]!
    
    // MARK: Init
    init(sessionService: SessionService, dataManager: DataManager, safariService: SafariService) {
        
        self.sessionService = sessionService
        self.dataManager = dataManager
        self.safariService = safariService
        
        let userPortfolioState = self.dataManager.get(key: DataKeys.userPortfolioState, type: UserPortfolioState.self)!
        
        self.portfolioArtists = userPortfolioState.artists
        self.portfolioDates = userPortfolioState.dates
        
        self.artistResults = searchText.flatMapLatest { [unowned self] text -> Observable<[Artist]> in
            return (text == "") ? Observable.from([]) : self.sessionService.searchArtistResults(query: text, limit: 15)
        }
    }
    
    deinit {
        Logger.info("AddArtistsViewModel dellocated")
    }
}
