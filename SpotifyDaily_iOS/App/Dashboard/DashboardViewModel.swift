//
//  DashboardViewModel.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import RxSwift

class DashboardViewModel {
    
    private let sessionService: SessionService
    private let disposeBag = DisposeBag()
    
    let title = "Dashboard"
    
    init(sessionService: SessionService) {
        self.sessionService = sessionService
        
//        self.sessionService.refreshProfile()
//            .subscribe()
//            .disposed(by: self.disposeBag)
        
    }
}
