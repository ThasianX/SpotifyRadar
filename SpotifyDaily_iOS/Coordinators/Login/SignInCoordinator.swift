//
//  SignInCoordinator.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/25/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

class SignInCoordinator: BaseCoordinator {
    
    override func start() {
        let signInViewController = LoginViewController()
        
        // Coordinator observes events and notifies parentCoordinator
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccessful), name: .SpotifyLoginSuccessful, object: nil)
        
        self.navigationController.viewControllers = [signInViewController]
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func loginSuccessful(){
        self.navigationController.viewControllers = []
        self.parentCoordinator?.didFinish(coordinator: self)
        (self.parentCoordinator as? SignInListener)?.didSignIn()
    }
}
