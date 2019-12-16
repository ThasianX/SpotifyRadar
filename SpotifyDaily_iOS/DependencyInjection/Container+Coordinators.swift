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
        self.autoregister(AddArtistsCoordinator.self, initializer: AddArtistsCoordinator.init)
        self.autoregister(DashboardCoordinator.self, initializer: DashboardCoordinator.init)
        self.autoregister(SettingsCoordinator.self, initializer: SettingsCoordinator.init)
        self.autoregister(TopArtistsCollectionCoordinator.self, initializer: TopArtistsCollectionCoordinator.init)
        self.autoregister(TopTracksCollectionCoordinator.self, initializer: TopTracksCollectionCoordinator.init)
        self.autoregister(RecentlyPlayedTracksCoordinator.self, initializer: RecentlyPlayedTracksCoordinator.init)
    }
}
