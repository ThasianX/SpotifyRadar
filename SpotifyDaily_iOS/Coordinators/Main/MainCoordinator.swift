//
//  MainCoordinator.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/27/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit


final class MainCoordinator: BaseCoordinator {
    
    let mainTabBarController = MainTabBarController()
    let recommendationsCoordinator = RecommendationsCoordinator()
    let dashboardCoordinator = DashboardCoordinator()
    let settingsCoordinator = SettingsCoordinator()
    
    override func start() {
        let recommendationsVc = recommendationsCoordinator.rootViewController
        recommendationsVc.tabBarItem = UITabBarItem(title: "Recommendations", image: UIImage(named: "recommendations"), tag: 0)
        
        let dashboardVc = dashboardCoordinator.rootViewController
        dashboardVc.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(named: "dashboard"), tag: 1)
        
        let settingsVc = settingsCoordinator.rootViewController
        settingsVc.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings"), tag: 2)
        
        mainTabBarController.viewControllers = [recommendationsVc, dashboardVc, settingsVc]
        mainTabBarController.listener = self
        
        mainTabBarController.selectedIndex = 2
        tabSelected(index: 2)
        
        self.navigationController.viewControllers = [mainTabBarController]
        self.navigationController.navigationBar.isHidden = true
    }
    
}

extension MainCoordinator: LogOutListener {
    func didLogOut() {
        self.parentCoordinator?.didFinish(coordinator: self)
        (self.parentCoordinator as? LogOutListener)?.didLogOut()
    }
}

extension MainCoordinator: TabSelectedListener {
    func tabSelected(index: Int) {
        switch index {
        case 0:
            log.info("Recommendations Tab selected")
            self.childCoordinators = []
            self.start(coordinator: recommendationsCoordinator)
        case 1:
            log.info("Dashboard Tab selected")
            self.childCoordinators = []
            self.start(coordinator: dashboardCoordinator)
        case 2:
            log.info("Settings Tab selected")
            self.childCoordinators = []
            self.start(coordinator: settingsCoordinator)
        default:
            fatalError("Invalid tab selected")
        }
    }
}
