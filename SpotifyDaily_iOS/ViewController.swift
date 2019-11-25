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

private extension UIImageView {
    static var backgroundImageView: UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sign_in_background")
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

private extension UIButton {
    static var spotifySignInButton: UIButton {
        let button = UIButton()
        button.setTitle("Sign In With Spotify", for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
}

private extension UILabel {
    static var titleLabel: UILabel {
        let label = UILabel()
        label.text = "Spotify Daily"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    static var missionStatementLabel: UILabel {
        let label = UILabel()
        label.text = "Providing you with motivating song recommendations and sublime charts"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
}

final class ViewController: BaseViewController {
    
    private var viewModel: SignInViewModel!
    
    private lazy var backgroundImageView = UIImageView.backgroundImageView
    private lazy var logoImageView = UIImageView.logoImageView
    private lazy var titleLabel = UILabel.titleLabel
    private lazy var missionStatementLabel = UILabel.missionStatementLabel
    private lazy var spotifySignInButton = UIButton.spotifySignInButton
    
    // MARK: Initializing
    
    override init() { }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        
        self.viewModel = SignInViewModel(authentication: SessionService())
        self.setUpBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func addViews(){
        self.view.addSubview(backgroundImageView)
        self.view.addSubview(spotifySignInButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        let layoutGuide = self.view
        
        backgroundImageView.heightAnchor.constraint(equalTo: layoutGuide!.heightAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalTo: layoutGuide!.widthAnchor).isActive = true
        backgroundImageView.centerXAnchor.constraint(equalTo: layoutGuide!.centerXAnchor).isActive = true
        backgroundImageView.centerYAnchor.constraint(equalTo: layoutGuide!.centerYAnchor).isActive = true
        
        
    }
    
    // MARK: Binding
    
    private func setUpBindings() {
//        self.signInButton.rx.tap
//            .bind { [weak self] in self?.viewModel.signInTapped() }
//            .disposed(by: self.disposeBag)
//
//        self.viewModel.isSignInActive
//            .bind(to: self.signInButton.rx.isEnabled)
//            .disposed(by: self.disposeBag)
//
//        self.viewModel.didSignIn
//            .subscribe(onNext: { [weak self] in
//                self?.showAlert(title: "Success", message: "Signed in")
//                // do smth
//            })
//            .disposed(by: self.disposeBag)
//
//        self.viewModel.didFailSignIn
//            .subscribe(onNext: { error in
//                print("Failed: \(error)")
//                // do smth
//            })
//            .disposed(by: self.disposeBag)
    }
}

