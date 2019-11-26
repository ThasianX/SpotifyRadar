//
//  AppCoordinator.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/25/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit
import SpotifyLogin

protocol SignInListener {
    func didSignIn()
}

class AppCoordinator: BaseCoordinator {
    
    var window = UIWindow(frame: UIScreen.main.bounds)
    
    override func start() {
        print("App coordinator start called")
        self.navigationController.navigationBar.isHidden = true
        self.window.rootViewController = self.navigationController
        self.window.makeKeyAndVisible()
        
        
        // check if user is signed in and show appropriate screen
        SpotifyLogin.shared.getAccessToken { [weak self] (accessToken, error) in
            guard let `self` = self else { return }
            
            if error != nil, accessToken == nil {
                // User is not logged in, show log in flow.
                let coordinator = SignInCoordinator()
                coordinator.navigationController = self.navigationController
                self.start(coordinator: coordinator)
            } else {
                self.didSignIn()
            }
        }
    }
}

extension AppCoordinator: SignInListener {
    func didSignIn() {
        print("Signed In. Navigation to Main View Controller")
        let coordinator = DashboardCoordinator()
        coordinator.navigationController = self.navigationController
        self.start(coordinator: coordinator)
    }
}
