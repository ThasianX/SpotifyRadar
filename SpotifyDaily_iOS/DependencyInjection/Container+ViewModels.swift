//
//  Container+ViewModels.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import Swinject
import SwinjectAutoregistration

extension Container {
    
    func registerViewModels() {
        self.autoregister(SignInViewModel.self, initializer: SignInViewModel.init)
        self.autoregister(DrawerMenuViewModel.self, initializer: DrawerMenuViewModel.init)
        self.autoregister(RecommendationsViewModel.self, initializer: RecommendationsViewModel.init)
        self.autoregister(DashboardViewModel.self, initializer: DashboardViewModel.init)
        self.autoregister(SettingsViewModel.self, initializer: SettingsViewModel.init)
        self.autoregister(TopArtistsCollectionViewModel.self, initializer: TopArtistsCollectionViewModel.init)
        self.autoregister(TopTracksCollectionViewModel.self, initializer: TopTracksCollectionViewModel.init)
    }
}
