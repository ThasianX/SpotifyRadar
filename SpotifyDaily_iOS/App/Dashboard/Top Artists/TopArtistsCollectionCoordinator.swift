//
//  ArtistsCollectionCoordinator.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/5/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class TopArtistsCollectionCoordinator: BaseCoordinator {
    
    var artistsCollectionViewController: BaseNavigationController!
    weak var parentViewModel: DashboardViewModel!
    
    private let viewModel: TopArtistsCollectionViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: TopArtistsCollectionViewModel) {
        self.viewModel = viewModel
    }
    
    deinit {
        Logger.info("TopArtistsCollectionCoordinator dellocated")
    }

    override func start() {
        var viewController = TopArtistsCollectionViewController()
        viewController.bind(to: self.viewModel)
        
        artistsCollectionViewController = BaseNavigationController(rootViewController: viewController)
        artistsCollectionViewController.navigationBar.isHidden = true
        
        self.navigationController.presentOnTop(artistsCollectionViewController, animated: true)
        
        viewModel.input.dismissed
            .bind(to: parentViewModel.childDismissed)
            .disposed(by: disposeBag)
    }
    
}
