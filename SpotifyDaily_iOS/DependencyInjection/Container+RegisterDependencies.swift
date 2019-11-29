//
//  Container+RegisterDependencies.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Swinject

extension Container {
    
    func registerDependencies() {
        self.registerServices()
        self.registerViewModels()
        self.registerCoordinators()
    }
}
