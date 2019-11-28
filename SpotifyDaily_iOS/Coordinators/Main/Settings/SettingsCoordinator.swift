//
//  SettingsCoordinator.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/27/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

class SettingsCoordinator: BaseCoordinator {

    let settingsViewController = SettingsViewController()
    
    override func start() {
        // Coordinator subscribes to events and notifies parentCoordinator
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: .UserLogout, object: nil)
        
        self.navigationController.viewControllers = [settingsViewController]
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func logout(){
        self.navigationController.viewControllers = []
        self.parentCoordinator?.didFinish(coordinator: self)
        (self.parentCoordinator as? LogOutListener)?.didLogOut()
    }
}
