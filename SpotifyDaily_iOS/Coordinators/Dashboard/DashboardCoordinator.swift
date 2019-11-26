//
//  DashboardCoordinator.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/25/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

class DashboardCoordinator: BaseCoordinator {
    
    override func start() {
        let dashboardViewController = DashboardViewController()
        
        // Coordinator subscribes to events and notifies parentCoordinator
        
        self.navigationController.viewControllers = [dashboardViewController]
    }
}
