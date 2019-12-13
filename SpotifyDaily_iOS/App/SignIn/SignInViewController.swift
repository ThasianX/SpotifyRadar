//
//  ViewController.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/24/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SignInViewController: UIViewController {
    
    //MARK: Properties
    
    private lazy var backgroundImageView = UIImageView.backgroundImageView
    
    private var spotifySignInButton = UIButton.spotifyLoginButton

    private let disposeBag = DisposeBag()
    var viewModel: SignInViewModel?
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        setUpConstraints()
        setUpBindings()
    }
    
    deinit {
        Logger.info("SignInViewController dellocated")
    }
    
    //MARK: View configuration
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return UIStatusBarStyle.darkContent
        } else {
            return UIStatusBarStyle.lightContent
        }
    }
    
    private func addViews(){
        self.view.addSubview(backgroundImageView)
        self.view.addSubview(spotifySignInButton)
    }
    
    private func setUpConstraints() {
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        spotifySignInButton.heightAnchor.constraint(equalToConstant: .buttonHeight).isActive = true
        spotifySignInButton.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: .buttonMargin).isActive = true
        spotifySignInButton.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -.buttonMargin).isActive = true
        spotifySignInButton.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor).isActive = true
    }
    
    private func setUpBindings() {
        spotifySignInButton.rx.tap.bind { [unowned self] in
            self.viewModel?.presentSignInBrowser(vc: self)
        }
        .disposed(by: self.disposeBag)
    }
}

private extension Int {
    static let numberOfLines = 0
}

private extension CGFloat {
    static let cornerRadius = CGFloat(55/2)
    
    static let buttonHeight = CGFloat(55)
    static let buttonMargin = CGFloat(50)
}

private extension UIButton {
    static var spotifyLoginButton: UIButton {
        let button = SpotifyLoginButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
}

private extension UIImageView {
    static var backgroundImageView: UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sign_in_background")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }

    static var logoImageView: UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }
}
