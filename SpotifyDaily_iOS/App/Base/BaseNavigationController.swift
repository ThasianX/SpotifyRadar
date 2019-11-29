//
//  BaseNavigationController.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit

class BaseNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = .white
        self.navigationBar.barTintColor = ColorPreference.mainColor
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}

enum ColorPreference {
    static let mainColor = UIColor(red: 0x71 / 0xFF, green: 0xBC / 0xFF, blue: 0xBD / 0xFF, alpha: 1)
}
