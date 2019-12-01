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
    private lazy var titleLabel = UILabel.titleLabel
    private lazy var missionStatementLabel = UILabel.missionStatementLabel
    
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
    
    //MARK: View configuration
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func addViews(){
        self.view.addSubview(backgroundImageView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(missionStatementLabel)
        self.view.addSubview(spotifySignInButton)
    }
    
    private func setUpConstraints() {
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        titleLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: .labelPadding).isActive = true
        
        missionStatementLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .labelPadding).isActive = true
        missionStatementLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: .labelPadding).isActive = true
        missionStatementLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -.labelPadding).isActive = true
        
        spotifySignInButton.heightAnchor.constraint(equalToConstant: .buttonHeight).isActive = true
        spotifySignInButton.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: .buttonMargin).isActive = true
        spotifySignInButton.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -.buttonMargin).isActive = true
        spotifySignInButton.topAnchor.constraint(equalTo: missionStatementLabel.bottomAnchor, constant: .buttonMargin).isActive = true
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
    
    static let labelPadding = CGFloat(16)
    
    static let buttonHeight = CGFloat(55)
    static let buttonMargin = CGFloat(50)
}

private extension UIFont {
    static let titleLabel = UIFont.boldSystemFont(ofSize: 30)
    static let missionStatementLabel = UIFont.boldSystemFont(ofSize: 15)
}

private extension UIColor {
    static let titleLabelText = UIColor.white
    static let missionStatementText = UIColor.white
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
//
//    static var logoImageView: UIImageView {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "logo")
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//
//        return imageView
//    }
}

private extension UILabel {
    static var titleLabel: UILabel {
        let label = UILabel()
        label.text = "Spotify Daily"
        label.font = .titleLabel
        label.textColor = .titleLabelText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    static var missionStatementLabel: UILabel {
        let label = UILabel()
        label.text = "Providing you with motivating song recommendations and sublime charts"
        label.font = .missionStatementLabel
        label.textColor = .missionStatementText
        label.numberOfLines = .numberOfLines
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
}
