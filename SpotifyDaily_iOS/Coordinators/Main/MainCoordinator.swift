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
        let recommendationsVc = recommendationsCoordinator.navigationController
        recommendationsVc.tabBarItem = UITabBarItem(title: "Recommendations", image: UIImage(named: "recommendations"), tag: 0)
        
        let dashboardVc = dashboardCoordinator.navigationController
        dashboardVc.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(named: "dashboard"), tag: 1)
        
        let settingsVc = settingsCoordinator.navigationController
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
        Logger.info("Recieved log out call from delegate")
        self.navigationController.viewControllers = []
        self.parentCoordinator?.didFinish(coordinator: self)
        (self.parentCoordinator as? LogOutListener)?.didLogOut()
    }
}

extension MainCoordinator: TabSelectedListener {
    func tabSelected(index: Int) {
        switch index {
        case 0:
            Logger.info("Recommendations Tab selected")
            self.start(coordinator: recommendationsCoordinator)
        case 1:
            Logger.info("Dashboard Tab selected")
            self.start(coordinator: dashboardCoordinator)
        case 2:
            Logger.info("Settings Tab selected")
            self.start(coordinator: settingsCoordinator)
        default:
            Logger.error("Invalid Tab selected")
        }
    }
}
