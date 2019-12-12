//
//  ArtistsCollectionCell.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/4/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ArtistCollectionCell: UICollectionViewCell, BindableType {
    // MARK: - Properties
    // MARK: View components
    fileprivate let artistBackground = UIImageView.artistBackground
    fileprivate let artistNameLabel = UILabel.artistNameLabel
    fileprivate let followersLabel = UILabel.followersLabel
    
    // MARK: Rx
    private let disposeBag = DisposeBag()
    
    // MARK: Viewmodel
    var viewModel: ArtistCollectionCellViewModelType!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Loading this view from a nib is unsupported in favor of initializer dependency injection.")
    }
    
    deinit {
        Logger.info("ArtistCollectionCell dellocated")
    }
    
    private func setUpView() {
        self.addSubview(artistBackground)
        self.addSubview(artistNameLabel)
        self.addSubview(followersLabel)
        
        self.setUpConstraints()
    }
    
    private func setUpConstraints() {
        let layoutGuide = self.safeAreaLayoutGuide
        
        self.artistBackground.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        self.artistBackground.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        self.artistBackground.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        self.artistBackground.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        
        self.artistNameLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 8).isActive = true
        self.artistNameLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -8).isActive = true
        self.artistNameLabel.centerYAnchor.constraint(equalTo: self.artistBackground.centerYAnchor, constant: -16).isActive = true
        
        self.followersLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 8).isActive = true
        self.followersLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -8).isActive = true
        self.followersLabel.topAnchor.constraint(equalTo: self.artistNameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    func bindViewModel() {
        let output = viewModel.output
        
        output.artist
            .map { $0.image }
            .bind(onNext: { url in
                if let url = url {
                    self.artistBackground.load(url: url, targetSize: CGSize(width: 200, height: 200))
                } else {
                    let image = UIImage(named: "default_artist_image")?.resize(targetSize: CGSize(width: 200, height: 200))
                    self.artistBackground.image = image
                }
            })
            .disposed(by: self.disposeBag)
        
        output.artist
            .map { $0.name }
            .bind(to: self.artistNameLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        output.artist
            .map { "Followers: \($0.followers)" }
            .bind(to: self.followersLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
}

private extension UIImageView {
    static var artistBackground: UIImageView {
        let imageView = UIImageView()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.dim(withAlpha: 0.2)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
}

private extension UILabel {
    static var artistNameLabel: UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    static var followersLabel: UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
}
