//
//  SettingsViewController.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/26/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class SettingsViewController: ViewControllerWithSideMenu {
    
    //MARK: Properties
    private let disposeBag = DisposeBag()
    var viewModel: SettingsViewModel?
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setUpBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel?.refreshProfile()
    }
    
    //MARK: View configuration
    
    private func setUpView(){
        addViews()
        setupConstraints()
    }
    
    private func addViews(){
        self.view.addSubview(avatar)
        self.view.addSubview(containerView)
        self.view.addSubview(logoutButton)
    }
    
    private func setupConstraints() {
        let layoutGuide = self.view.safeAreaLayoutGuide
        
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
    
    // MARK: Binding configurations
    
    private func setUpBindings() {
        guard let viewModel = self.viewModel else { return }
        
        // Bind the logout button to part of the viewmodel
        logoutButton.rx.tap.bind {
            viewModel.logout()
        }
        .disposed(by: disposeBag)
    }
    
}

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

extension SettingsViewController {
    var avatar: UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        let url = URL(string: (viewModel?.sessionService.sessionState?.user.avatarUrl)!)
        imageView.load(url: url!)
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
    
    var containerView: UIView {
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
    }
    
    var profileStack: UIStackView {
        let stack = UIStackView()
        
        let displayNameLabel = displayName
        let countryLabel = country
        let filterEnabledLabel = filterEnabled
        let profileUrlLabel = profileUrl
        let numberOfFollowersLabel = numberOfFollowers
        let endpointUrlLabel = endpointUrl
        let idLabel = id
        let subscriptionLevelLabel = subscriptionLevel
        let uriUrlLabel = uriUrl
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = .labelSpacing
        
        stack.addArrangedSubview(displayNameLabel)
        stack.addArrangedSubview(countryLabel)
        stack.addArrangedSubview(filterEnabledLabel)
        stack.addArrangedSubview(profileUrlLabel)
        stack.addArrangedSubview(numberOfFollowersLabel)
        stack.addArrangedSubview(endpointUrlLabel)
        stack.addArrangedSubview(idLabel)
        stack.addArrangedSubview(subscriptionLevelLabel)
        stack.addArrangedSubview(uriUrlLabel)
        
        return stack
    }
    
    var profileLabel: UILabel {
        let label = UILabel()
        label.font = .profileLabel
        label.textColor = .profileLabel
        label.numberOfLines = .numberOfLines
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    var displayName: UILabel {
        let label = profileLabel
        
        label.text = "Display name: \((viewModel?.sessionService.sessionState?.user.displayName)!)"
        label.font = .displayNameLabel
        
        return label
    }
    
    var country: UILabel {
        let label = profileLabel
        
        label.text = "Country: \((viewModel?.sessionService.sessionState?.user.country)!)"
        
        return label
    }
    
    var filterEnabled: UILabel {
        let label = profileLabel
        
        label.text = "Content filter enabled: \((viewModel?.sessionService.sessionState?.user.filterEnabled)!)"
        
        return label
    }
    
    var profileUrl: UILabel {
        let label = profileLabel
        
        label.text = "Profile URL: \((viewModel?.sessionService.sessionState?.user.profileUrl)!)"
        
        return label
    }
    
    var numberOfFollowers: UILabel {
        let label = profileLabel
        
        label.text = "Number of followers: \((viewModel?.sessionService.sessionState?.user.numberOfFollowers)!)"
        
        return label
    }
    
    var endpointUrl: UILabel {
        let label = profileLabel
        
        label.text = "Web API endpoint URL: \((viewModel?.sessionService.sessionState?.user.endpointUrl)!)"
        
        return label
    }
    
    var id: UILabel {
        let label = profileLabel
        
        label.text = "Id: \((viewModel?.sessionService.sessionState?.user.id)!)"
        
        return label
    }
    
    var subscriptionLevel: UILabel {
        let label = profileLabel
        
        label.text = "Subscription level: \((viewModel?.sessionService.sessionState?.user.subscriptionLevel)!)"
        
        return label
    }
    
    var uriUrl: UILabel {
        let label = profileLabel
        
        label.text = "Resource identifier: \((viewModel?.sessionService.sessionState?.user.uriUrl)!)"
        
        return label
    }
    
    var logoutButton: UIButton {
        let button = UIButton(type: .custom)
        button.setTitle("Log out", for: .normal)
        button.setTitleColor(.logoutButtonText, for: .normal)
        button.titleLabel?.font = .logoutButtonTitle
        button.backgroundColor = .logoutButtonBackground
        button.layer.cornerRadius = .logoutButtonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
}
