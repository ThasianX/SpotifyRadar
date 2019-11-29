//
//  SignInCoordinator.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/25/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

class SignInCoordinator: BaseCoordinator {
    
    private let viewModel: SignInViewModel
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() {
        let viewController = SignInViewController()
        viewController.viewModel = viewModel
        
        self.navigationController.isNavigationBarHidden = true
        self.navigationController.viewControllers = [viewController]
    }
}
