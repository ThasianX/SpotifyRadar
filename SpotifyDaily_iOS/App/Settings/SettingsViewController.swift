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

final class SettingsViewController: ViewControllerWithSideMenu {
    
    //MARK: Properties
    
    private lazy var avatarImageView = UIImageView.avatar
    private lazy var containerView = UIView.containerView
    private lazy var logoutButton = UIButton.logoutButton
    
    private let disposeBag = DisposeBag()
    var viewModel: SettingsViewModel?
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setUpBindings()
    }
    
    //MARK: View configuration
    
    private func setUpView(){
        addViews()
        setupConstraints()
    }
    
    private func addViews(){
        self.view.addSubview(avatarImageView)
        self.view.addSubview(containerView)
        self.view.addSubview(logoutButton)
    }
    
    private func setupConstraints() {
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        avatarImageView.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: .labelSpacing*2).isActive = true
        avatarImageView.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        
        containerView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: .labelSpacing*4).isActive = true
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
        
        self.title = viewModel.title
        
        // Do some viewmodel bindings here
    }
    
//    @objc private func logoutTapped(){
//        Logger.info("Log out tapped")
//        SpotifyLogin.shared.logout()
//        NotificationCenter.default.post(name: .UserLogout, object: nil)
//    }
}

//public extension Notification.Name {
//    static let UserLogout = Notification.Name("UserLogout")
//}

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

private extension UIView {
    static var containerView: UIView {
        let view = UIView()
        view.backgroundColor = .containerViewBackground
        view.layer.cornerRadius = .profileContainerCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let profileStackView = UIStackView.profileStack
        
        view.addSubview(profileStackView)
        
        profileStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: .labelSpacing).isActive = true
        profileStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .labelSpacing).isActive = true
        profileStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.labelSpacing).isActive = true
        profileStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.labelSpacing).isActive = true
        
        return view
    }
}

private extension UIStackView {
    static var profileStack: UIStackView {
        let stack = UIStackView()
        
        let displayNameLabel = UILabel.displayName
        let countryLabel = UILabel.country
        let filterEnabledLabel = UILabel.filterEnabled
        let profileUrlLabel = UILabel.profileUrl
        let numberOfFollowersLabel = UILabel.numberOfFollowers
        let endpointUrlLabel = UILabel.endpointUrl
        let idLabel = UILabel.id
        let subscriptionLevelLabel = UILabel.subscriptionLevel
        let uriUrlLabel = UILabel.uriUrl
        
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
}

private extension UIButton {
    static var logoutButton: UIButton {
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

private extension UIImageView {
    static var avatar: UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        let url = URL(string: SpotifyLogin.shared.avatarUrl!)
        imageView.load(url: url!)
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
}

private extension UILabel {
    static var profileLabel: UILabel {
        let label = UILabel()
        label.font = .profileLabel
        label.textColor = .profileLabel
        label.numberOfLines = .numberOfLines
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    static var displayName: UILabel {
        let label = profileLabel
        
        label.text = "Display name: \(SpotifyLogin.shared.displayName!)"
        label.font = .displayNameLabel
        
        return label
    }
    
    static var country: UILabel {
        let label = profileLabel
        
        label.text = "Country: \(SpotifyLogin.shared.country!)"
        
        return label
    }
    
    static var filterEnabled: UILabel {
        let label = profileLabel
        
        label.text = "Content filter enabled: \(SpotifyLogin.shared.filterEnabled!)"
        
        return label
    }
    
    static var profileUrl: UILabel {
        let label = profileLabel
        
        label.text = "Profile URL: \(SpotifyLogin.shared.profileUrl!)"
        
        return label
    }
    
    static var numberOfFollowers: UILabel {
        let label = profileLabel
        
        label.text = "Number of followers: \(SpotifyLogin.shared.numberOfFollowers!)"
        
        return label
    }
    
    static var endpointUrl: UILabel {
        let label = profileLabel
        
        label.text = "Web API endpoint URL: \(SpotifyLogin.shared.endpointUrl!)"
        
        return label
    }
    
    static var id: UILabel {
        let label = profileLabel
        
        label.text = "Id: \(SpotifyLogin.shared.id!)"
        
        return label
    }
    
    static var subscriptionLevel: UILabel {
        let label = profileLabel
        
        label.text = "Subscription level: \(SpotifyLogin.shared.subscriptionLevel!)"
        
        return label
    }
    
    static var uriUrl: UILabel {
        let label = profileLabel
        
        label.text = "Resource identifier: \(SpotifyLogin.shared.uriUrl!)"
        
        return label
    }
}
