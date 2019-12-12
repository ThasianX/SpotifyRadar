//
//  TopTracksCoordinator.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/8/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit

class TopTracksCollectionCoordinator: BaseCoordinator {
    
    var topTracksViewController: BaseNavigationController!
    
    private let viewModel: TopTracksCollectionViewModel
    
    init(viewModel: TopTracksCollectionViewModel) {
        self.viewModel = viewModel
    }
    
    deinit {
        Logger.info("TopTracksCollectionCoordinator dellocated")
    }

    override func start() {
        var viewController = TopTracksCollectionViewController()
        viewController.bind(to: self.viewModel)
        
        topTracksViewController = BaseNavigationController(rootViewController: viewController)
        topTracksViewController.navigationBar.isHidden = true
        
        self.navigationController.presentOnTop(topTracksViewController, animated: true)
    }
    
}
