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

class RecommendationsCoordinator: BaseCoordinator {
    
    private let disposeBag = DisposeBag()
    private let sessionService: SessionService
    private let recommendationsViewModel: RecommendationsViewModel
    
    init(sessionService: SessionService, recommendationsViewModel: RecommendationsViewModel) {
        self.sessionService = sessionService
        self.recommendationsViewModel = recommendationsViewModel
    }
    
    deinit {
        Logger.info("RecommendationsCoordinator dellocated")
    }
    
    override func start() {
        let viewController = RecommendationsViewController()
        viewController.viewModel = self.recommendationsViewModel
        
        self.navigationController.viewControllers = [viewController]
    }
}
