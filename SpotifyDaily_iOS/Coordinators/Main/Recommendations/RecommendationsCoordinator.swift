//
//  RecommendationsCoordinator.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/27/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

class RecommendationsCoordinator: BaseCoordinator {
    
    override init() {
        super.init()
        self.navigationController.viewControllers = [RecommendationsViewController()]
    }
    
    override func start() {
    }
}
