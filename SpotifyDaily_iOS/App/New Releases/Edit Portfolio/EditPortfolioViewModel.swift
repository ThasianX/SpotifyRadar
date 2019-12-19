//
//  EditPortfolioViewModel.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/17/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol EditPortfolioViewModelInput {
    /// Call when an artist is selected
    func artistDeleted(at indexPath: IndexPath)
    
    /// Call when add button pressed
    var addArtists: PublishSubject<Void> { get }
    
    /// Call when view controller is dismissed
    var dismissed: PublishSubject<Void> { get }
    
    /// Call when view controller is dismissed
    var childDismissed: PublishSubject<Void> { get }
}
protocol EditPortfolioViewModelOutput {
    /// Emites the child viewModels
    var tableViewCellsModelType: Observable<[EditPortfolioCellViewModelType]> { get }
}
protocol EditPortfolioViewModelType {
    var input: EditPortfolioViewModelInput { get }
    var output: EditPortfolioViewModelOutput { get }
}

class EditPortfolioViewModel: EditPortfolioViewModelType,
    EditPortfolioViewModelInput,
EditPortfolioViewModelOutput {
    
    // MARK: Inputs & Outputs
    var input: EditPortfolioViewModelInput { return self }
    var output: EditPortfolioViewModelOutput { return self }
    
    // MARK: Inputs
    func artistDeleted(at indexPath: IndexPath) {
        var artists = portfolioArtists.value
        artists.remove(at: indexPath.row)
        var dates = portfolioDates.value
        dates.remove(at: indexPath.row)

        let newState = UserPortfolioState(artists: artists, dates: dates)
        dataManager.set(key: DataKeys.userPortfolioState, value: newState)
        
        portfolioArtists.accept(artists)
        portfolioDates.accept(dates)
    }
    
    let addArtists = PublishSubject<Void>()
    let dismissed = PublishSubject<Void>()
    var childDismissed = PublishSubject<Void>()
    
    // MARK: Outputs
    lazy var tableViewCellsModelType: Observable<[EditPortfolioCellViewModelType]> = {
        return portfolio.mapMany {
            EditPortfolioCellViewModel(artist: $0.0, dateAdded: $0.1)
        }
    }()
    
    // MARK: Private
    private let sessionService: SessionService
    private let dataManager: DataManager
    
    private let disposeBag = DisposeBag()
    private var portfolio: Observable<[(Artist, Date)]>!
    
    private var portfolioArtists: BehaviorRelay<[Artist]>
    private var portfolioDates: BehaviorRelay<[Date]>
    
    // MARK: Init
    init(sessionService: SessionService, dataManager: DataManager) {
        
        self.sessionService = sessionService
        self.dataManager = dataManager
        
        let userPortfolioState = self.dataManager.get(key: DataKeys.userPortfolioState, type: UserPortfolioState.self)!
        
        self.portfolioArtists = BehaviorRelay<[Artist]>(value: userPortfolioState.artists)
        self.portfolioDates = BehaviorRelay<[Date]>(value: userPortfolioState.dates)
        
        portfolio = Observable.combineLatest(portfolioArtists, portfolioDates)
            .flatMap { artists, dates -> Observable<[(Artist, Date)]> in
                return Observable.just(Array(zip(artists, dates)))
        }
        
        childDismissed.bind(onNext: { [unowned self] in
            let userPortfolioState = self.dataManager.get(key: DataKeys.userPortfolioState, type: UserPortfolioState.self)!
            self.portfolioArtists.accept(userPortfolioState.artists)
            self.portfolioDates.accept(userPortfolioState.dates)
        })
        .disposed(by: disposeBag)
    }
    
    deinit {
        Logger.info("EditPortfolioViewModel dellocated")
    }
}
