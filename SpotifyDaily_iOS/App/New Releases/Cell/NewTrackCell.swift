//
//  NewTrackCell.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/16/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class NewTrackCell: UITableViewCell, BindableType {
    // MARK: - Properties
    // MARK: View components
    private lazy var trackName = UILabel.trackLabel
    private lazy var albumName = UILabel.albumLabel
    private lazy var trackDuration = UILabel.rightLabel
    
    // MARK: Rx
    private let disposeBag = DisposeBag()
    
    // MARK: Viewmodel
    var viewModel: NewTracksCellViewModelType!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Loading this view from a nib is unsupported in favor of initializer dependency injection.")
    }
    
    deinit {
        Logger.info("NewTrackCell dellocated")
    }

    private func setUpView() {
        self.addSubview(trackName)
        self.addSubview(albumName)
        self.addSubview(trackDuration)
        
        self.setUpConstraints()
    }
    
    private func setUpConstraints() {
        let layoutGuide = self.safeAreaLayoutGuide
        
        self.trackName.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: Constraints.outerMargins).isActive = true
        self.trackName.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: Constraints.outerMargins).isActive = true
        self.trackName.trailingAnchor.constraint(equalTo: layoutGuide.centerXAnchor, constant: Constraints.outerMargins).isActive = true
        
        self.albumName.topAnchor.constraint(equalTo: trackName.bottomAnchor, constant: Constraints.innerMargins).isActive = true
        self.albumName.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: Constraints.outerMargins).isActive = true
        self.albumName.trailingAnchor.constraint(equalTo: layoutGuide.centerXAnchor, constant: Constraints.outerMargins).isActive = true
        self.albumName.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -Constraints.outerMargins).isActive = true
        
        self.trackDuration.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: Constraints.outerMargins).isActive = true
        self.trackDuration.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -Constraints.outerMargins).isActive = true
        self.trackDuration.leadingAnchor.constraint(equalTo: layoutGuide.centerXAnchor, constant: Constraints.outerMargins).isActive = true
        
    }
    
    func bindViewModel() {
        let output = viewModel.output
        
        output.track
            .map { $0.trackName }
            .bind(to: trackName.rx.text)
            .disposed(by: disposeBag)
        
        output.track
            .map { $0.albumName }
            .bind(to: albumName.rx.text)
        .disposed(by: disposeBag)
        
        output.track
            .map { $0.duration }
            .bind(to: trackDuration.rx.text)
        .disposed(by: disposeBag)
    }
}

private struct Constraints {
    static let outerMargins = CGFloat(8)
    static let innerMargins = CGFloat(4)
}

private extension UILabel {
    static var trackLabel: UILabel {
        let label = UILabel()
        label.textColor = ColorPreference.tertiaryColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .left
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    static var albumLabel: UILabel {
        let label = UILabel()
        label.textColor = ColorPreference.tertiaryColor
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    static var rightLabel: UILabel {
        let label = UILabel()
        label.textColor = ColorPreference.tertiaryColor
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .right
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
}

