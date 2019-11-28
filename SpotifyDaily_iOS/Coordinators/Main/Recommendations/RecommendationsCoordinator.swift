//
//  RecommendationsCoordinator.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/27/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

class RecommendationsCoordinator: BaseCoordinator {
    
    let rootViewController = UINavigationController(rootViewController: RecommendationsViewController())
    
    override func start() {
        // Coordinator subscribes to events and notifies parentCoordinator
        
        self.navigationController = rootViewController
    }
}
