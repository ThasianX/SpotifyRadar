//
//  TrackCollectionCell.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/7/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class TrackCollectionCell: UICollectionViewCell, BindableType {
    // MARK: - Properties
    // MARK: View components
    private lazy var albumBackground = UIImageView.albumBackground
    private lazy var trackName = UILabel.trackLabel
    private lazy var artistName = UILabel.artistLabel
    private lazy var trackDuration = UILabel.durationLabel
    
    // MARK: Rx
    private let disposeBag = DisposeBag()
    
    // MARK: Viewmodel
    var viewModel: TrackCollectionCellViewModelType!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Loading this view from a nib is unsupported in favor of initializer dependency injection.")
    }
    
    deinit {
        Logger.info("TrackCollectionCell dellocated")
    }
    
    private func setUpView() {
        self.addSubview(albumBackground)
        self.addSubview(trackName)
        self.addSubview(artistName)
        self.addSubview(trackDuration)
        
        self.setUpConstraints()
    }
    
    private func setUpConstraints() {
        let layoutGuide = self.safeAreaLayoutGuide
        
        self.albumBackground.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        self.albumBackground.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        self.albumBackground.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        self.albumBackground.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        
        self.trackName.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 8).isActive = true
        self.trackName.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -8).isActive = true
        self.trackName.centerYAnchor.constraint(equalTo: self.albumBackground.centerYAnchor, constant: -16).isActive = true
        
        self.artistName.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 8).isActive = true
        self.artistName.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -8).isActive = true
        self.artistName.topAnchor.constraint(equalTo: self.trackName.bottomAnchor, constant: 8).isActive = true
        
        self.trackDuration.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 8).isActive = true
        self.trackDuration.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -8).isActive = true
        self.trackDuration.topAnchor.constraint(equalTo: self.artistName.bottomAnchor, constant: 8).isActive = true
    }
    
    func bindViewModel() {
        let output = viewModel.output
        
        output.track
            .map { $0.albumImage }
            .bind(onNext: { [unowned self] url in
                self.albumBackground.load(url: url, targetSize: CGSize(width: 200, height: 200))
            })
            .disposed(by: self.disposeBag)
        
        output.track
            .map { $0.name }
            .bind(to: trackName.rx.text)
        .disposed(by: disposeBag)
        
        output.track
            .map { $0.artists }
            .bind(to: artistName.rx.text)
        .disposed(by: disposeBag)
        
        output.track
            .map { $0.duration }
            .bind(to: trackDuration.rx.text)
        .disposed(by: disposeBag)
    }
}

private extension UIImageView {
    static var albumBackground: UIImageView {
        let imageView = UIImageView()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.dim(withAlpha: 0.2)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
}

private extension UILabel {
    static var trackLabel: UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    static var artistLabel: UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    static var durationLabel: UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
}
