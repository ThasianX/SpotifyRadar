//
//  SettingsCoordinator.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/27/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

class SettingsCoordinator: BaseCoordinator {
    
    override init() {
        super.init()
        self.navigationController.viewControllers = [SettingsViewController()]
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: .UserLogout, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func start() {
        
    }
    
    @objc func logout(){
        Logger.info("Recieved logout tapped notification")
        self.navigationController.viewControllers = []
        self.parentCoordinator?.didFinish(coordinator: self)
        (self.parentCoordinator as? LogOutListener)?.didLogOut()
    }
}
