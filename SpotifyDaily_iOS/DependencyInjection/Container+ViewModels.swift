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
        self.autoregister(NewReleasesViewModel.self, initializer: NewReleasesViewModel.init)
        self.autoregister(EditPortfolioViewModel.self, initializer: EditPortfolioViewModel.init)
        self.autoregister(AddArtistsViewModel.self, initializer: AddArtistsViewModel.init)
        self.autoregister(DashboardViewModel.self, initializer: DashboardViewModel.init)
        self.autoregister(TopArtistsCollectionViewModel.self, initializer: TopArtistsCollectionViewModel.init)
        self.autoregister(TopTracksCollectionViewModel.self, initializer: TopTracksCollectionViewModel.init)
        self.autoregister(RecentlyPlayedTracksViewModel.self, initializer: RecentlyPlayedTracksViewModel.init)
        self.autoregister(SettingsViewModel.self, initializer: SettingsViewModel.init)
    }
}
