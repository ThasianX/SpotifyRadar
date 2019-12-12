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

class SettingsRootView: UIView {
    
    private lazy var userAvatar = UIImageView.avatar
    private lazy var userDetails = UIStackView.profileDetails
    private lazy var logoutButton = UIButton.logoutButton
    
    private lazy var country = UILabel.defaultLabel
    private lazy var displayName = UILabel.defaultLabel
    private lazy var email = UILabel.defaultLabel
    private lazy var filterEnabled = UILabel.defaultLabel
    private lazy var profileUrl = UILabel.defaultLabel
    private lazy var numberOfFollowers = UILabel.defaultLabel
    private lazy var endpointUrl = UILabel.defaultLabel
    private lazy var id = UILabel.defaultLabel
    private lazy var avatarUrl = UILabel.defaultLabel
    private lazy var subscriptionLevel = UILabel.defaultLabel
    private lazy var uriUrl = UILabel.defaultLabel
    
    // MARK: - Properties
    private let viewModel: SettingsViewModel
    private let disposeBag = DisposeBag()
    
    init(frame: CGRect = .zero, viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Loading this view from a nib is unsupported in favor of initializer dependency injection.")
    }
    
    private func setupView(){
        self.addSubview(userAvatar)
        self.addSubview(userDetails)
        self.addSubview(logoutButton)
        
        self.setupStackView()
        self.setupConstraints()
        self.setupBindings()
    }
    
    private func setupStackView() {
        userDetails.addArrangedSubview(displayName)
        userDetails.addArrangedSubview(email)
        userDetails.addArrangedSubview(country)
        userDetails.addArrangedSubview(numberOfFollowers)
        userDetails.addArrangedSubview(subscriptionLevel)
        userDetails.addArrangedSubview(filterEnabled)
        userDetails.addArrangedSubview(profileUrl)
        userDetails.addArrangedSubview(endpointUrl)
        userDetails.addArrangedSubview(id)
        userDetails.addArrangedSubview(uriUrl)
    }
    
    private func setupConstraints(){
        let layoutGuide = self.safeAreaLayoutGuide
        
        userAvatar.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: .labelSpacing*2).isActive = true
        userAvatar.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        
        userDetails.topAnchor.constraint(equalTo: userAvatar.bottomAnchor, constant: .labelSpacing*4).isActive = true
        userDetails.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: .labelSpacing*4).isActive = true
        userDetails.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -.labelSpacing*4).isActive = true
        
        logoutButton.topAnchor.constraint(equalTo: userDetails.bottomAnchor, constant: .labelSpacing*4).isActive = true
        logoutButton.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: .buttonMargin*2).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -.buttonMargin*2).isActive = true
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
        .map { $0?.avatarUrl }
        .distinctUntilChanged()
        .map { URL(string: $0!)!}
        .bind(onNext: { [unowned self] url in
            self.userAvatar.load(url: url, targetSize: CGSize(width: 200, height: 200))
        })
        .disposed(by: disposeBag)
        
        viewModel.userSubject
            .map { $0?.country }
        .distinctUntilChanged()
        .bind(onNext: { [unowned self] country in
            let attribute1 = [NSAttributedString.Key.font: UIFont(helveticaStyle: .thin, size: 15)]
            let myString = NSMutableAttributedString(string: "COUNTRY: ", attributes: attribute1)
            let attribute2 = [NSAttributedString.Key.font: UIFont(helveticaStyle: .thin, size: 18)]
            myString.append(NSMutableAttributedString(string: country!.uppercased(), attributes: attribute2))
            let myRange = NSRange(location: 0, length: 9)
            myString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorPreference.mainColor, range: myRange)
            
            self.country.attributedText = myString
        })
        .disposed(by: disposeBag)
        
        viewModel.userSubject
        .map { $0?.displayName }
        .distinctUntilChanged()
        .bind(onNext: { [unowned self] displayName in
            let attribute1 = [NSAttributedString.Key.font: UIFont(helveticaStyle: .thin, size: 20)]
            let myString = NSMutableAttributedString(string: "USER: ", attributes: attribute1)
            let attribute2 = [NSAttributedString.Key.font: UIFont(helveticaStyle: .thin, size: 45)]
            myString.append(NSMutableAttributedString(string: displayName!.uppercased(), attributes: attribute2))
            let myRange = NSRange(location: 0, length: 6)
            myString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorPreference.mainColor, range: myRange)
            
            self.displayName.attributedText = myString
        })
        .disposed(by: disposeBag)
        
        viewModel.userSubject
        .map { $0?.email }
        .distinctUntilChanged()
        .bind(onNext: { [unowned self] email in
            let attribute1 = [NSAttributedString.Key.font: UIFont(helveticaStyle: .thin, size: 15)]
            let myString = NSMutableAttributedString(string: "EMAIL: ", attributes: attribute1)
            let attribute2 = [NSAttributedString.Key.font: UIFont(helveticaStyle: .thin, size: 18)]
            myString.append(NSMutableAttributedString(string: email!.uppercased(), attributes: attribute2))
            let myRange = NSRange(location: 0, length: 7)
            myString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorPreference.mainColor, range: myRange)
            
            self.email.attributedText = myString
        })
        .disposed(by: disposeBag)
        
        viewModel.userSubject
            .map { $0?.filterEnabled.description }
        .distinctUntilChanged()
        .bind(onNext: { [unowned self] filterEnabled in
            let attribute1 = [NSAttributedString.Key.font: UIFont(helveticaStyle: .thin, size: 15)]
            let myString = NSMutableAttributedString(string: "FILTER ENABLED: ", attributes: attribute1)
            let attribute2 = [NSAttributedString.Key.font: UIFont(helveticaStyle: .thin, size: 18)]
            myString.append(NSMutableAttributedString(string: filterEnabled!.uppercased(), attributes: attribute2))
            let myRange = NSRange(location: 0, length: 16)
            myString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorPreference.mainColor, range: myRange)
            
            self.filterEnabled.attributedText = myString
        })
        .disposed(by: disposeBag)
        
        viewModel.userSubject
        .map { $0?.profileUrl }
        .distinctUntilChanged()
        .bind(onNext: { [unowned self] profileUrl in
            let attribute1 = [NSAttributedString.Key.font: UIFont(helveticaStyle: .thin, size: 15)]
            let myString = NSMutableAttributedString(string: "PROFILE LINK: ", attributes: attribute1)
            let attribute2 = [NSAttributedString.Key.font: UIFont(helveticaStyle: .thin, size: 18)]
            myString.append(NSMutableAttributedString(string: profileUrl!.uppercased(), attributes: attribute2))
            let myRange = NSRange(location: 0, length: 14)
            myString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorPreference.mainColor, range: myRange)
            
            self.profileUrl.attributedText = myString
        })
        .disposed(by: disposeBag)
        
        viewModel.userSubject
            .map { $0?.numberOfFollowers }
        .distinctUntilChanged()
        .bind(onNext: { [unowned self] numberOfFollowers in
            let attribute1 = [NSAttributedString.Key.font: UIFont(helveticaStyle: .thin, size: 20)]
            let myString = NSMutableAttributedString(string: "FOLLOWER COUNT: ", attributes: attribute1)
            let attribute2 = [NSAttributedString.Key.font: UIFont(helveticaStyle: .thin, size: 35)]
            myString.append(NSMutableAttributedString(string: "\(numberOfFollowers!)", attributes: attribute2))
            let myRange = NSRange(location: 0, length: 16)
            myString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorPreference.mainColor, range: myRange)
            
            self.numberOfFollowers.attributedText = myString
        })
        .disposed(by: disposeBag)
        
        viewModel.userSubject
        .map { $0?.endpointUrl }
        .distinctUntilChanged()
        .bind(onNext: { [unowned self] endpointUrl in
            let attribute1 = [NSAttributedString.Key.font: UIFont(helveticaStyle: .thin, size: 15)]
            let myString = NSMutableAttributedString(string: "PROFILE API ENDPOINT: ", attributes: attribute1)
            let attribute2 = [NSAttributedString.Key.font: UIFont(helveticaStyle: .thin, size: 18)]
            myString.append(NSMutableAttributedString(string: endpointUrl!.uppercased(), attributes: attribute2))
            let myRange = NSRange(location: 0, length: 22)
            myString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorPreference.mainColor, range: myRange)
            
            self.endpointUrl.attributedText = myString
        })
        .disposed(by: disposeBag)
        
        viewModel.userSubject
        .map { $0?.id }
        .distinctUntilChanged()
        .bind(onNext: { [unowned self] id in
            let attribute1 = [NSAttributedString.Key.font: UIFont(helveticaStyle: .thin, size: 15)]
            let myString = NSMutableAttributedString(string: "USER ID: ", attributes: attribute1)
            let attribute2 = [NSAttributedString.Key.font: UIFont(helveticaStyle: .thin, size: 18)]
            myString.append(NSMutableAttributedString(string: id!.uppercased(), attributes: attribute2))
            let myRange = NSRange(location: 0, length: 9)
            myString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorPreference.mainColor, range: myRange)
            
            self.id.attributedText = myString
        })
        .disposed(by: disposeBag)
        
        viewModel.userSubject
        .map { $0?.subscriptionLevel }
        .distinctUntilChanged()
        .bind(onNext: { [unowned self] subscriptionLevel in
            let attribute1 = [NSAttributedString.Key.font: UIFont(helveticaStyle: .thin, size: 15)]
            let myString = NSMutableAttributedString(string: "SUBSCRIPTION LEVEL: ", attributes: attribute1)
            let attribute2 = [NSAttributedString.Key.font: UIFont(helveticaStyle: .thin, size: 18)]
            myString.append(NSMutableAttributedString(string: subscriptionLevel!.uppercased(), attributes: attribute2))
            let myRange = NSRange(location: 0, length: 20)
            myString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorPreference.mainColor, range: myRange)
            
            self.subscriptionLevel.attributedText = myString
        })
        .disposed(by: disposeBag)
        
        viewModel.userSubject
        .map { $0?.uriUrl }
        .distinctUntilChanged()
        .bind(onNext: { [unowned self] uriUrl in
            let attribute1 = [NSAttributedString.Key.font: UIFont(helveticaStyle: .thin, size: 15)]
            let myString = NSMutableAttributedString(string: "PROFILE SEARCH URI: ", attributes: attribute1)
            let attribute2 = [NSAttributedString.Key.font: UIFont(helveticaStyle: .thin, size: 18)]
            myString.append(NSMutableAttributedString(string: uriUrl!.uppercased(), attributes: attribute2))
            let myRange = NSRange(location: 0, length: 20)
            myString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorPreference.mainColor, range: myRange)
            
            self.uriUrl.attributedText = myString
        })
        .disposed(by: disposeBag)
    }
}

private extension Int {
    static let numberOfLines = 0
}

private extension CGFloat {
    static let logoutButtonCornerRadius = CGFloat(55/2)
    static let profileContainerCornerRadius = CGFloat(30)
    
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
    static let defaultLabel = ColorPreference.tertiaryColor
    
    static let containerViewBackground = UIColor.clear
    
    static let logoutButtonText = ColorPreference.secondaryColor
    static let logoutButtonBackground = ColorPreference.tertiaryColor
}

private extension UILabel {
    static var defaultLabel: UILabel {
        let label = UILabel()
        label.textColor = .defaultLabel
        label.numberOfLines = .numberOfLines
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
}

private extension UIImageView {
    static var avatar: UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
}

private extension UIStackView {
    static var profileDetails: UIStackView {
        let stack = UIStackView()
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = .labelSpacing
        
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
