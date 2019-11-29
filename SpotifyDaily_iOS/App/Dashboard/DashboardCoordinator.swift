//
//  DashboardCoordinator.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/25/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit

class DashboardCoordinator: BaseCoordinator {
    
    private let dashboardViewModel: DashboardViewModel
    private let dataManager: DataManager
    
    init(dashboardViewModel: DashboardViewModel, dataManager: DataManager) {
        self.dashboardViewModel = dashboardViewModel
        self.dataManager = dataManager
    }

    override func start() {
        let viewController = DashboardViewController()
        viewController.viewModel = dashboardViewModel
        
        self.navigationController.navigationItem.title = "User Dashboard"
        self.navigationController.viewControllers = [viewController]
        
    }
    
}
