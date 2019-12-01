//
//  SettingsCoordinator.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/27/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit

class SettingsCoordinator: BaseCoordinator {
    
    private let settingsViewModel: SettingsViewModel
    
    init(settingsViewModel: SettingsViewModel) {
        self.settingsViewModel = settingsViewModel
        self.settingsViewModel.refreshProfile()
    }
    
    override func start() {
        let viewController = SettingsViewController()
        viewController.viewModel = self.settingsViewModel
        
        self.navigationController.viewControllers = [viewController]
    }
}
