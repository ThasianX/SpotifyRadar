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
        dashboardViewModel.presentTopArtist.bind(onNext: { [weak self] in
            self?.presentTopArtists()
        })
        .disposed(by: disposeBag)
    }
    
    private func presentTopArtists() {
        Logger.info("Presenting top artists")
        
        let coordinator = AppDelegate.container.resolve(ArtistsCollectionCoordinator.self)!
        coordinator.navigationController = self.navigationController
        
        self.start(coordinator: coordinator)
    }
}
