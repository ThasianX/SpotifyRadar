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

class AppCoordinator: BaseCoordinator {
    
    var window = UIWindow(frame: UIScreen.main.bounds)
    
    override func start() {
        self.window.rootViewController = self.navigationController
        self.window.makeKeyAndVisible()
        
        SpotifyLogin.shared.getAccessToken { [weak self] (accessToken, error) in
            guard let `self` = self else { return }
            
            if error != nil, accessToken == nil {
                self.createSignIn()
            } else {
                self.didSignIn()
            }
        }
    }
    
    //MARK: Helper methods
    
    private func createSignIn(){
        Logger.info("User not authenticated. Creating Sign In Coordinator")
        let coordinator = SignInCoordinator()
        coordinator.navigationController = self.navigationController
        self.start(coordinator: coordinator)
    }
}

protocol SignInListener {
    func didSignIn()
}

extension AppCoordinator: SignInListener {
    func didSignIn() {
        Logger.info("User authenticated. Creating Main Coordinator")
        let coordinator = MainCoordinator()
        coordinator.navigationController = self.navigationController
        self.start(coordinator: coordinator)
    }
}

protocol LogOutListener {
    func didLogOut()
}

extension AppCoordinator: LogOutListener {
    func didLogOut() {
        self.createSignIn()
    }
}
