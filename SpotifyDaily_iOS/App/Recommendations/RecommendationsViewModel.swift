//
//  RecommendationsViewModel.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

import Foundation
import RxSwift

class RecommendationsViewModel {
    
    private let sessionService: SessionService
    private let disposeBag = DisposeBag()
    
    let title = "Recommendations"
    
    init(sessionService: SessionService) {
        self.sessionService = sessionService
        
//        self.sessionService.refreshProfile()
//            .subscribe()
//            .disposed(by: self.disposeBag)
        
    }
    
    deinit {
        Logger.info("RecommendationsViewModel dellocated")
    }
}
