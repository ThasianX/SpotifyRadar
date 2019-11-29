//
//  Container+Coordinators.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Swinject

extension Container {
    
    func registerCoordinators() {
        self.autoregister(AppCoordinator.self, initializer: AppCoordinator.init)
        self.autoregister(SignInCoordinator.self, initializer: SignInCoordinator.init)
        self.autoregister(DrawerMenuCoordinator.self, initializer: DrawerMenuCoordinator.init)
        self.autoregister(RecommendationsCoordinator.self, initializer: RecommendationsCoordinator.init)
        self.autoregister(DashboardCoordinator.self, initializer: DashboardCoordinator.init)
        self.autoregister(SettingsCoordinator.self, initializer: SettingsCoordinator.init)
    }
}
