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

class AddArtistsCoordinator: BaseCoordinator {
    
    private let disposeBag = DisposeBag()
    private let sessionService: SessionService
    private let addArtistsViewModel: AddArtistsViewModel
    
    init(sessionService: SessionService, addArtistsViewModel: AddArtistsViewModel) {
        self.sessionService = sessionService
        self.addArtistsViewModel = addArtistsViewModel
    }
    
    deinit {
        Logger.info("AddArtistsCoordinator dellocated")
    }
    
    override func start() {
        var viewController = AddArtistsViewController()
        self.navigationController.viewControllers = [viewController]
        viewController.bind(to: addArtistsViewModel)
    }
}
