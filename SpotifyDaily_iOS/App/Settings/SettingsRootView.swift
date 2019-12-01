//
//  SettingsRootView.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/30/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

private extension Int {
    static let numberOfLines = 0
}

private extension CGFloat {
    static let logoutButtonCornerRadius = CGFloat(55/2)
    static let profileContainerCornerRadius = CGFloat(60)
    
    static let labelSpacing = CGFloat(8)
    
    static let buttonHeight = CGFloat(55)
    static let buttonMargin = CGFloat(50)
}

private extension UIFont {
    static let profileLabel = UIFont.boldSystemFont(ofSize: 15)
    static let displayNameLabel = UIFont.boldSystemFont(ofSize: 20)
    
    static let logoutButtonTitle = UIFont.boldSystemFont(ofSize: 20)
}

private extension UIColor {
    static let profileLabel = UIColor.black
    
    static let containerViewBackground = UIColor.lightGray
    
    static let logoutButtonText = UIColor.white
    static let logoutButtonBackground = UIColor.red
}

class SettingsRootView: UIView {
    
    lazy var avatar: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//        let url = URL(string: (viewModel.sessionService.sessionState?.user.avatarUrl)!)
//        imageView.load(url: url!)
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .containerViewBackground
        view.layer.cornerRadius = .profileContainerCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let profileStackView = profileStack
        
        view.addSubview(profileStackView)
        
        profileStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: .labelSpacing).isActive = true
        profileStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .labelSpacing).isActive = true
        profileStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.labelSpacing).isActive = true
        profileStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.labelSpacing).isActive = true
        
        return view
    }()
    
    lazy var profileStack: UIStackView = {
        let stack = UIStackView()
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = .labelSpacing
        
        stack.addArrangedSubview(displayName)
        stack.addArrangedSubview(email)
        stack.addArrangedSubview(country)
        stack.addArrangedSubview(filterEnabled)
        stack.addArrangedSubview(profileUrl)
        stack.addArrangedSubview(numberOfFollowers)
        stack.addArrangedSubview(endpointUrl)
        stack.addArrangedSubview(id)
        stack.addArrangedSubview(subscriptionLevel)
        stack.addArrangedSubview(uriUrl)
        
        return stack
    }()
    
    lazy var displayName: UILabel = {
        let label = UILabel()
        
//        label.text = "Display name: \((viewModel.sessionService.sessionState?.user.displayName)!)"
        label.font = .displayNameLabel
        label.textColor = .profileLabel
        label.numberOfLines = .numberOfLines
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var country: UILabel = {
        let label = UILabel()
        label.font = .profileLabel
        label.textColor = .profileLabel
        label.numberOfLines = .numberOfLines
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
//        label.text = "Country: \((viewModel.sessionService.sessionState?.user.country)!)"
        
        return label
    }()
    
    lazy var email: UILabel = {
        let label = UILabel()
        label.font = .profileLabel
        label.textColor = .profileLabel
        label.numberOfLines = .numberOfLines
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
//        label.text = "Country: \((viewModel.sessionService.sessionState?.user.email)!)"
        
        return label
    }()
    
    lazy var filterEnabled: UILabel = {
        let label = UILabel()
        label.font = .profileLabel
        label.textColor = .profileLabel
        label.numberOfLines = .numberOfLines
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
//        label.text = "Content filter enabled: \((viewModel.sessionService.sessionState?.user.filterEnabled)!)"
        
        return label
    }()
    
    lazy var profileUrl: UILabel = {
        let label = UILabel()
        label.font = .profileLabel
        label.textColor = .profileLabel
        label.numberOfLines = .numberOfLines
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
//        label.text = "Profile URL: \((viewModel.sessionService.sessionState?.user.profileUrl)!)"
        
        return label
    }()
    
    lazy var numberOfFollowers: UILabel = {
        let label = UILabel()
        label.font = .profileLabel
        label.textColor = .profileLabel
        label.numberOfLines = .numberOfLines
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
//        label.text = "Number of followers: \((viewModel.sessionService.sessionState?.user.numberOfFollowers)!)"
        
        return label
    }()
    
    lazy var endpointUrl: UILabel = {
        let label = UILabel()
        label.font = .profileLabel
        label.textColor = .profileLabel
        label.numberOfLines = .numberOfLines
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
//        label.text = "Web API endpoint URL: \((viewModel.sessionService.sessionState?.user.endpointUrl)!)"
        
        return label
    }()
    
    lazy var id: UILabel = {
        let label = UILabel()
        label.font = .profileLabel
        label.textColor = .profileLabel
        label.numberOfLines = .numberOfLines
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
//        label.text = "Id: \((viewModel.sessionService.sessionState?.user.id)!)"
        
        return label
    }()
    
    lazy var subscriptionLevel: UILabel = {
        let label = UILabel()
        label.font = .profileLabel
        label.textColor = .profileLabel
        label.numberOfLines = .numberOfLines
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
//        label.text = "Subscription level: \((viewModel.sessionService.sessionState?.user.subscriptionLevel)!)"
        
        return label
    }()
    
    lazy var uriUrl: UILabel = {
        let label = UILabel()
        label.font = .profileLabel
        label.textColor = .profileLabel
        label.numberOfLines = .numberOfLines
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
//        label.text = "Resource identifier: \((viewModel.sessionService.sessionState?.user.uriUrl)!)"
        
        return label
    }()
    
    lazy var logoutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Log out", for: .normal)
        button.setTitleColor(.logoutButtonText, for: .normal)
        button.titleLabel?.font = .logoutButtonTitle
        button.backgroundColor = .logoutButtonBackground
        button.layer.cornerRadius = .logoutButtonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let viewModel: SettingsViewModel
    private let disposeBag = DisposeBag()
    
    init(frame: CGRect = .zero, viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        self.setupView()
        self.setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Loading this view from a nib is unsupported in favor of initializer dependency injection.")
    }
    
    private func setupView(){
        self.addSubview(avatar)
        self.addSubview(containerView)
        self.addSubview(logoutButton)
        self.setupConstraints()
        self.setupBindings()
        
        self.backgroundColor = .white
    }
    
    private func setupConstraints(){
        let layoutGuide = self.safeAreaLayoutGuide
        
        avatar.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: .labelSpacing*2).isActive = true
        avatar.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        
        containerView.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: .labelSpacing*4).isActive = true
        containerView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: .labelSpacing*4).isActive = true
        containerView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -.labelSpacing*4).isActive = true
        
        logoutButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: .labelSpacing*4).isActive = true
        logoutButton.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: .buttonMargin).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -.buttonMargin).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: .buttonHeight).isActive = true
    }
    
    private func setupBindings() {
        
        // MARK: Actions
        logoutButton.rx.tap.bind { [weak self] in
            self?.viewModel.logout()
        }
        .disposed(by: disposeBag)
        
        // MARK: Values
        viewModel.userSubject
            .map { $0?.country }
        .distinctUntilChanged()
        .bind(onNext: { [weak self] country in
            Logger.info(country!)
            self?.country.text = country
        })
        .disposed(by: disposeBag)
        
        viewModel.userSubject
        .map { $0?.displayName }
        .distinctUntilChanged()
        .bind(onNext: { [weak self] displayName in
            Logger.info(displayName!)
            self?.displayName.text = displayName
        })
        .disposed(by: disposeBag)
        
        viewModel.userSubject
        .map { $0?.email }
        .distinctUntilChanged()
        .bind(onNext: { [weak self] email in
            self?.email.text = email
        })
        .disposed(by: disposeBag)
        
        viewModel.userSubject
            .map { $0?.filterEnabled.description }
        .distinctUntilChanged()
        .bind(onNext: { [weak self] filterEnabled in
            self?.filterEnabled.text = filterEnabled
        })
        .disposed(by: disposeBag)
        
        viewModel.userSubject
        .map { $0?.profileUrl }
        .distinctUntilChanged()
        .bind(onNext: { [weak self] profileUrl in
            self?.profileUrl.text = profileUrl
        })
        .disposed(by: disposeBag)
        
        viewModel.userSubject
            .map { $0?.numberOfFollowers }
        .distinctUntilChanged()
        .bind(onNext: { [weak self] numberOfFollowers in
            self?.numberOfFollowers.text = "\(numberOfFollowers!)"
        })
        .disposed(by: disposeBag)
        
        viewModel.userSubject
        .map { $0?.endpointUrl }
        .distinctUntilChanged()
        .bind(onNext: { [weak self] endpointUrl in
            self?.endpointUrl.text = endpointUrl
        })
        .disposed(by: disposeBag)
        
        viewModel.userSubject
        .map { $0?.id }
        .distinctUntilChanged()
        .bind(onNext: { [weak self] id in
            self?.id.text = id
        })
        .disposed(by: disposeBag)
        
        viewModel.userSubject
            .map { $0?.avatarUrl }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] url in
                self?.avatar.load(url: URL(string: url!)!)
            })
            .disposed(by: disposeBag)
        
        viewModel.userSubject
        .map { $0?.subscriptionLevel }
        .distinctUntilChanged()
        .bind(onNext: { [weak self] subscriptionLevel in
            self?.subscriptionLevel.text = subscriptionLevel
        })
        .disposed(by: disposeBag)
        
        viewModel.userSubject
        .map { $0?.uriUrl }
        .distinctUntilChanged()
        .bind(onNext: { [weak self] uriUrl in
            self?.uriUrl.text = uriUrl
        })
        .disposed(by: disposeBag)
    }
}
