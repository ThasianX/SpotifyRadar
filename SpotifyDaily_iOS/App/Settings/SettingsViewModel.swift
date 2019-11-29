//
//  SettingsViewModel.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import RxSwift

class SettingsViewModel {
    
    private let dataManager: DataManager
    private let disposeBag = DisposeBag()
    
    let title = "Settings"
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
}
