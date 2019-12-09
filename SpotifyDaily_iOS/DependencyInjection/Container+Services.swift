//
//  Container+Services.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Swinject
import SwinjectAutoregistration

extension Container {
    func registerServices() {
        self.autoregister(DataManager.self, initializer: UserDataManager.init).inObjectScope(.container)
        self.autoregister(SessionService.self, initializer: SessionService.init).inObjectScope(.container)
        self.autoregister(SpotifyLogin.self, initializer: SpotifyLogin.init).inObjectScope(.container)
        self.autoregister(SafariService.self, initializer: SafariService.init).inObjectScope(.container)
        self.autoregister(Networking.self, initializer: Networking.init).inObjectScope(.container)
        self.autoregister(Configuration.self, initializer: Configuration.init).inObjectScope(.container)
    }
}
