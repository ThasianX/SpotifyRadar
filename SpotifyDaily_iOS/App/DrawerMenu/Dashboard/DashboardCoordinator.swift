//
//  DashboardCoordinator.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/25/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class DashboardCoordinator: BaseCoordinator {
    
    private let dashboardViewModel: DashboardViewModel
    private let dataManager: DataManager
    
    private let disposeBag = DisposeBag()
    
    init(dashboardViewModel: DashboardViewModel, dataManager: DataManager) {
        self.dashboardViewModel = dashboardViewModel
        self.dataManager = dataManager
    }

    override func start() {
        let viewController = DashboardViewController()
        viewController.viewModel = dashboardViewModel
        
        self.navigationController.viewControllers = [viewController]
        
        setUpBindings()
    }
    
    private func setUpBindings() {
        dashboardViewModel.presentTopArtists.bind(onNext: { [weak self] in
            self?.presentTopArtists()
        })
        .disposed(by: disposeBag)
        
        dashboardViewModel.presentTopTracks.bind(onNext: { [weak self] in
            self?.presentTopTracks()
        })
        .disposed(by: disposeBag)
    }
    
    private func presentTopArtists() {
        Logger.info("Presenting top artists")
        
        let coordinator = AppDelegate.container.resolve(TopArtistsCollectionCoordinator.self)!
        coordinator.navigationController = self.navigationController
        
        self.start(coordinator: coordinator)
    }
    
    private func presentTopTracks() {
        Logger.info("Presenting top tracks")
        
        let coordinator = AppDelegate.container.resolve(TopTracksCollectionCoordinator.self)!
        coordinator.navigationController = self.navigationController
        
        self.start(coordinator: coordinator)
    }
}
