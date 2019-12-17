//
//  EditPortfolioCell.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/17/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class EditPortfolioCell: UITableViewCell, BindableType {
    // MARK: - Properties
    // MARK: View components
    private lazy var artistName = UILabel.artistLabel
    private lazy var dateAdded = UILabel.dateAdded
    private lazy var artistImage = UIImageView.artistImage
    
    // MARK: Rx
    private let disposeBag = DisposeBag()
    
    // MARK: Viewmodel
    var viewModel: EditPortfolioCellViewModelType!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Loading this view from a nib is unsupported in favor of initializer dependency injection.")
    }
    
    deinit {
        Logger.info("EditPortfolioCell dellocated")
    }

    private func setUpView() {
        self.addSubview(artistName)
        self.addSubview(dateAdded)
        self.addSubview(artistImage)
        
        self.setUpConstraints()
    }
    
    private func setUpConstraints() {
        let layoutGuide = self.safeAreaLayoutGuide
        
        self.artistImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.artistImage.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: Constraints.outerMargins).isActive = true
        self.artistImage.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: Constraints.outerMargins).isActive = true
        self.artistImage.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -Constraints.outerMargins).isActive = true
        
        self.artistName.leadingAnchor.constraint(equalTo: artistImage.trailingAnchor, constant: Constraints.innerMargins).isActive = true
        self.artistName.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor).isActive = true
        self.artistName.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor, multiplier: 0.6).isActive = true
        
        self.dateAdded.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor).isActive = true
        self.dateAdded.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -Constraints.outerMargins).isActive = true
        
    }
    
    func bindViewModel() {
        let output = viewModel.output
        
        output.artist
            .map { $0.name }
            .bind(to: artistName.rx.text)
            .disposed(by: disposeBag)
        
        output.artist
            .map { $0.image }
            .bind(onNext: { url in
                if let url = url {
                    self.artistImage.load(url: url, targetSize: CGSize(width: 40, height: 40))
                } else {
                    let image = UIImage(named: "default_artist_image")?.resize(targetSize: CGSize(width: 40, height: 40))
                    self.artistImage.image = image
                }
            })
            .disposed(by: disposeBag)
        
        output.dateAdded
            .map { $0.mediumDateShortTime }
            .bind(to: dateAdded.rx.text)
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

private extension UILabel {
    static var artistLabel: UILabel {
        let label = UILabel()
        label.textColor = ColorPreference.tertiaryColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .left
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    static var dateAdded: UILabel {
        let label = UILabel()
        label.textColor = ColorPreference.tertiaryColor
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .right
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
}

