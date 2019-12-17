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
    
    var addArtistsViewController: BaseNavigationController!
    var parentViewModel: NewReleasesViewModel!
    
    private let disposeBag = DisposeBag()
    private let viewModel: AddArtistsViewModel
    
    init(viewModel: AddArtistsViewModel) {
        self.viewModel = viewModel
    }
    
    deinit {
        Logger.info("AddArtistsCoordinator dellocated")
    }
    
    override func start() {
        var viewController = AddArtistsViewController()
        viewController.bind(to: viewModel)
        
        addArtistsViewController = BaseNavigationController(rootViewController: viewController)
        addArtistsViewController.navigationBar.isHidden = true
        addArtistsViewController.navigationBar.barTintColor = ColorPreference.secondaryColor
        
        self.navigationController.presentOnTop(addArtistsViewController, animated: true)
        
        viewModel.input.dismissed
            .bind(to: parentViewModel.input.childDismissed)
        .disposed(by: disposeBag)
    }
}
