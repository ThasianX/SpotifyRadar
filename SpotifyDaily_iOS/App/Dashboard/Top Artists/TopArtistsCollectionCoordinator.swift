//
//  ArtistsCollectionCoordinator.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/5/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit

class TopArtistsCollectionCoordinator: BaseCoordinator {
    
    var artistsCollectionViewController: BaseNavigationController!
    
    private let viewModel: TopArtistsCollectionViewModel
    
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
    }
    
}
