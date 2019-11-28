//
//  AppDelegate.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/24/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit
import SpotifyLogin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    let appCoordinator = AppCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let redirectURL: URL = URL(string: "spotify-daily-login://")!
        SpotifyLogin.shared.configure(clientID: "8cece41fa2cc49a48e66b70cbc7789fc",
                                      clientSecret: "89faaf509a5e49569abb3fc93ebe4740",
                                      redirectURL: redirectURL)
        
        Logger.info("Configured clientID, clientSecret, and redirectURL")
        
        self.appCoordinator.start()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = SpotifyLogin.shared.applicationOpenURL(url) { _ in }
        return handled
    }
}

