//
//  MainTabBarController.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/27/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

protocol TabSelectedListener: class {
    func tabSelected(index: Int)
}

class MainTabBarController: UITabBarController {

    weak var listener: TabSelectedListener?
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == (self.tabBar.items!)[0]{
            listener?.tabSelected(index: 0)
        }
        else if item == (self.tabBar.items!)[1]{
           listener?.tabSelected(index: 1)
        } else {
            listener?.tabSelected(index: 2)
        }
    }
}
