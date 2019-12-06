//
//  ViewControllerWithSideMenu.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

class ViewControllerWithSideMenu: UIViewController {
    
    var panGesture = UIPanGestureRecognizer()
    var edgeGesture = UIScreenEdgePanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.panGesture = SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        self.edgeGesture = SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view, forMenu: .left)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(self.hamburgerMenuClicked))
        self.navigationItem.leftBarButtonItem?.accessibilityIdentifier = "menuButton"
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.enableSideMenu()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.disableSideMenu()
    }
    
    func disableSideMenu() {
        self.panGesture.isEnabled = false
        self.edgeGesture.isEnabled = true
    }
    
    func enableSideMenu() {
        self.panGesture.isEnabled = true
        self.edgeGesture.isEnabled = true
    }
    
    func showSideMenu() { self.present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    @objc func hamburgerMenuClicked() {
        self.showSideMenu()
    }
}
