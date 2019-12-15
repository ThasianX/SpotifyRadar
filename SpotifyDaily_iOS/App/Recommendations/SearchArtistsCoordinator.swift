//
//  RecommendationsCoordinator.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/27/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchArtistsCoordinator: BaseCoordinator {
    
    private let disposeBag = DisposeBag()
    private let sessionService: SessionService
    private let searchArtistsViewModel: SearchArtistsViewModel
    
    init(sessionService: SessionService, searchArtistsViewModel: SearchArtistsViewModel) {
        self.sessionService = sessionService
        self.searchArtistsViewModel = searchArtistsViewModel
    }
    
    deinit {
        Logger.info("SearchArtistsCoordinator dellocated")
    }
    
    override func start() {
        let viewController = SearchArtistsViewController()
        viewController.viewModel = self.searchArtistsViewModel
        
        self.navigationController.viewControllers = [viewController]
    }
}
