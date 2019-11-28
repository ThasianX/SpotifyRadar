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

protocol LogOutListener {
    func didLogOut()
}

class AppCoordinator: BaseCoordinator {
    
    var window = UIWindow(frame: UIScreen.main.bounds)
    
    override func start() {
        log.info("App coordinator start called")
        self.window.rootViewController = self.navigationController
        self.window.makeKeyAndVisible()
        
        // check if user is signed in and show appropriate screen
        SpotifyLogin.shared.getAccessToken { [weak self] (accessToken, error) in
            guard let `self` = self else { return }
            
            if error != nil, accessToken == nil {
                // User is not logged in, show log in flow.
                self.createSignIn()
            } else {
                self.didSignIn()
            }
        }
    }
    
    private func createSignIn(){
        let coordinator = SignInCoordinator()
        coordinator.navigationController = self.navigationController
        self.start(coordinator: coordinator)
    }
}

extension AppCoordinator: SignInListener {
    func didSignIn() {
        log.info("Signed In. Navigation to Main View Controller.")
        log.info("Stored country string has value: \(SpotifyLogin.shared.country!)")
        log.info("Stored display name string has value: \(SpotifyLogin.shared.displayName!)")
        log.info("Stored filter enabled boolean has value: \(SpotifyLogin.shared.filterEnabled!)")
        log.info("Stored profile url string has value: \(SpotifyLogin.shared.profileUrl!)")
        log.info("Stored number of followers int has value: \(SpotifyLogin.shared.numberOfFollowers!)")
        log.info("Stored endpoint url string has value: \(SpotifyLogin.shared.endpointUrl!)")
        log.info("Stored id string has value: \(SpotifyLogin.shared.id!)")
        log.info("Stored avatar url string has value: \(SpotifyLogin.shared.avatarUrl!)")
        log.info("Stored subscription level string has value: \(SpotifyLogin.shared.subscriptionLevel!)")
        log.info("Stored uri url string has value: \(SpotifyLogin.shared.uriUrl!)")
        
        let coordinator = MainCoordinator()
        coordinator.navigationController = self.navigationController
        self.start(coordinator: coordinator)
    }
}

extension AppCoordinator: LogOutListener {
    func didLogOut() {
        self.createSignIn()
    }
}
