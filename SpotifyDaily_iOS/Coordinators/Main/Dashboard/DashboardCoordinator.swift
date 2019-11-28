//
//  DashboardCoordinator.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/25/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

class DashboardCoordinator: BaseCoordinator {

    let dashboardViewController = DashboardViewController()
    
    override func start() {
        // Coordinator subscribes to events and notifies parentCoordinator
        self.navigationController.viewControllers.append(dashboardViewController)
    }
}
