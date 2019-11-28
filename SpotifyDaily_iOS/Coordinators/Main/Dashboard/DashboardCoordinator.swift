//
//  DashboardCoordinator.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/25/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

class DashboardCoordinator: BaseCoordinator {

    override init() {
        super.init()
        self.navigationController.viewControllers = [DashboardViewController()]
    }
    
    override func start() {
    }
}
