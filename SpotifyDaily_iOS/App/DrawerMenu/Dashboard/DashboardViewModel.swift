//
//  DashboardViewModel.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DashboardViewModel {
    
    // MARK: - Properties
    // MARK: Dependencies
    private let sessionService: SessionService
    private let dataManager: DataManager
    
    // MARK: Private fields
    private let disposeBag = DisposeBag()
    
    // MARK: Public fields
    
    init(sessionService: SessionService, dataManager: DataManager) {
        self.sessionService = sessionService
        self.dataManager = dataManager
        
    }
    
    private func setUpBindings() {
    }
    
}
