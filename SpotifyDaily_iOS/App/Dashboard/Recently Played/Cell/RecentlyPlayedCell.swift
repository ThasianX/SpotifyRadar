//
//  RecentlyPlayedTableViewCell.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/9/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class RecentlyPlayedCell: UITableViewCell, BindableType {
    // MARK: - Properties
    // MARK: View components
    private lazy var trackName = UILabel.trackLabel
    private lazy var albumName = UILabel.albumLabel
    private lazy var artistImages = UIStackView.artistsStackView
    private lazy var trackDuration = UILabel.rightLabel
    private lazy var playedFrom = UILabel.rightLabel
    private lazy var playedAt = UILabel.rightLabel
    
    // MARK: Rx
    private let disposeBag = DisposeBag()
    
    // MARK: Viewmodel
    var viewModel: RecentlyPlayedCellViewModelType!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Loading this view from a nib is unsupported in favor of initializer dependency injection.")
    }
    
    deinit {
        Logger.info("RecentlyPlayedCell dellocated")
    }

    private func setUpView() {
        self.addSubview(trackName)
        self.addSubview(albumName)
        self.addSubview(artistImages)
        self.addSubview(trackDuration)
        self.addSubview(playedFrom)
        self.addSubview(playedAt)
        
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
        
        self.trackDuration.centerYAnchor.constraint(equalTo: trackName.centerYAnchor).isActive = true
        self.trackDuration.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -Constraints.outerMargins).isActive = true
        self.trackDuration.leadingAnchor.constraint(equalTo: layoutGuide.centerXAnchor, constant: Constraints.outerMargins).isActive = true
        
        self.playedAt.centerYAnchor.constraint(equalTo: albumName.centerYAnchor).isActive = true
        self.playedAt.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -Constraints.outerMargins).isActive = true
        self.playedAt.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: Constraints.outerMargins).isActive = true
        
        self.artistImages.topAnchor.constraint(equalTo: playedAt.bottomAnchor, constant: Constraints.innerMargins).isActive = true
        self.artistImages.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: Constraints.outerMargins).isActive = true
        self.artistImages.trailingAnchor.constraint(equalTo: layoutGuide.centerXAnchor, constant: -Constraints.outerMargins).isActive = true
        self.artistImages.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -Constraints.outerMargins).isActive = true
        
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
            .map { $0.artistURLs }
        .bind(onNext: { [unowned self] urls in
            for url in urls {
                let image = UIImageView.artistImage
                image.load(url: url, targetSize: CGSize(width: 40, height: 40))
                self.artistImages.addArrangedSubview(image)
            }
        })
        .disposed(by: disposeBag)
        
        output.track
            .map { $0.duration }
            .bind(to: trackDuration.rx.text)
        .disposed(by: disposeBag)
        
        output.track
            .map{ $0.playedAt }
            .bind(to: playedAt.rx.text)
        .disposed(by: disposeBag)
    }
}

private struct Constraints {
    static let outerMargins = CGFloat(8)
    static let innerMargins = CGFloat(4)
}

private extension UIImageView {
    static var artistImage: UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
}

private extension UIStackView {
    static var artistsStackView: UIStackView {
        let stack = UIStackView()
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 4
        
        return stack
    }
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
