//
//  AppDelegate.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/24/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit
import Swinject
import SideMenu

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    
    private var appCoordinator: AppCoordinator!
    static let container = Container()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Container.loggingFunction = nil
        AppDelegate.container.registerDependencies()
        
        self.setUpSideMenu()
        
        self.appCoordinator = AppDelegate.container.resolve(AppCoordinator.self)
        self.appCoordinator.start()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let spotifyLogin = AppDelegate.container.resolve(SpotifyLogin.self)!
        let handled = spotifyLogin.applicationOpenURL(url) { _ in }
        return handled
    }
    
    // MARK: Helper methods
    
    private func setUpSideMenu() {
        let sideMenuController = SideMenuNavigationController(rootViewController: DrawerMenuViewController())
        sideMenuController.navigationBar.isHidden = true
        sideMenuController.statusBarEndAlpha = 0
        sideMenuController.presentationStyle = .menuSlideIn
        sideMenuController.menuWidth = max(round(min((UIScreen.main.bounds.width), (UIScreen.main.bounds.height)) * 0.75), 240)
    }
}

