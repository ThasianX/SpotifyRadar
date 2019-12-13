//
//  StartupViewController.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/12/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit

class StartupViewController: UIViewController {
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "logo")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        self.view.addSubview(backgroundImage)
        
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        backgroundImage.heightAnchor.constraint(equalToConstant: 128).isActive = true
        backgroundImage.widthAnchor.constraint(equalToConstant: 128).isActive = true
        backgroundImage.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        backgroundImage.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor).isActive = true
    }
}
