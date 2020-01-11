//
//  UIViewController+Present.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/6/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentOnTop(_ viewController: UIViewController, animated: Bool) {
        var topViewController = self
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        topViewController.present(viewController, animated: animated)
    }
}
