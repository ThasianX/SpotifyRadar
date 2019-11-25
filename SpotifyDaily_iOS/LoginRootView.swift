//
//  LoginView.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/24/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

private extension UIImageView {
    static var backgroundImageView: UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sign_in_background")
        
        return imageView
    }
}

class LoginRootView: UIView {
    
    private lazy var backgroundImageView = UIImageView.backgroundImageView
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override init(frame: CGRect){
        super.init(frame: frame)
        addViews()
    }
    
    func addViews(){
        addSubview(backgroundImageView)
    }
    
    func setupConstraints(){
        let layoutGuide = self.superview
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundImageView.heightAnchor.constraint(equalTo: layoutGuide!.heightAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalTo: layoutGuide!.widthAnchor).isActive = true
        backgroundImageView.centerXAnchor.constraint(equalTo: layoutGuide!.centerXAnchor).isActive = true
        backgroundImageView.centerYAnchor.constraint(equalTo: layoutGuide!.centerYAnchor).isActive = true
    }
    
    
}
