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
    private var window = UIWindow(frame: UIScreen.main.bounds)
    
    init(dashboardViewModel: DashboardViewModel, dataManager: DataManager) {
        self.dashboardViewModel = dashboardViewModel
        self.dataManager = dataManager
        
        super.init()
        setUpBindings()
    }

    override func start() {
        let viewController = DashboardViewController()
        viewController.viewModel = dashboardViewModel
        
        self.navigationController.navigationItem.title = "User Dashboard"
        self.navigationController.viewControllers = [viewController]
    }
    
    private func setUpBindings() {
        dashboardViewModel.presentTopArtist.bind(onNext: { [weak self] in
            Logger.info("called in coord")
            self?.presentTopArtists()
        })
        .disposed(by: disposeBag)
    }
    
    private func presentTopArtists() {
        Logger.info("Presenting top artists")
        
        self.removeChildCoordinators()
        
        let coordinator = AppDelegate.container.resolve(ArtistsCollectionCoordinator.self)!
        self.start(coordinator: coordinator)
        
        ViewControllerUtils.setRootViewController(
            window: parentCoordinator.,
        viewController: coordinator.navigationController,
        withAnimation: true)
    }
}
