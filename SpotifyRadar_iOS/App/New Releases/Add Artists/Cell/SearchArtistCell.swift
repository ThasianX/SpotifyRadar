//
//  SearchArtistCell.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/14/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SearchArtistCell: UITableViewCell, BindableType {
    // MARK: - Properties
    // MARK: View components
    private lazy var artistName = UILabel.artistName
    private lazy var artistImage = UIImageView.artistImage
    lazy var portfolioDescription = UILabel.portfolioDescription
    
    // MARK: Rx
    private let disposeBag = DisposeBag()
    
    // MARK: Viewmodel
    var viewModel: SearchArtistCellViewModelType!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Loading this view from a nib is unsupported in favor of initializer dependency injection.")
    }
    
    deinit {
        Logger.info("SearchArtistCell dellocated")
    }

    private func setUpView() {
        self.addSubview(artistName)
        self.addSubview(artistImage)
        self.addSubview(portfolioDescription)
        
        self.setUpConstraints()
    }
    
    private func setUpConstraints() {
        let layoutGuide = self.safeAreaLayoutGuide
        
        
        self.artistImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.artistImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.artistImage.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor).isActive = true
        self.artistImage.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: Constraints.outerMargins).isActive = true
        
        self.artistName.leadingAnchor.constraint(equalTo: artistImage.trailingAnchor, constant: Constraints.innerMargins).isActive = true
        self.artistName.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor).isActive = true
        self.artistName.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor, multiplier: 0.6).isActive = true
        
        self.portfolioDescription.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor).isActive = true
        self.portfolioDescription.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -Constraints.outerMargins).isActive = true
    }
    
    func bindViewModel() {
        let output = viewModel.output
        
        output.artist
            .map { $0.image }
            .bind(onNext: { url in
                if let url = url {
                    self.artistImage.load(url: url, targetSize: CGSize(width: 40, height: 40))
                } else {
                    let image = UIImage(named: "default_artist")?.resize(targetSize: CGSize(width: 40, height: 40))
                    self.artistImage.image = image
                }
            })
            .disposed(by: disposeBag)
        
        output.artist
            .map { $0.name }
            .bind(to: artistName.rx.text )
            .disposed(by: disposeBag)
        
        output.inPortfolio
            .bind(onNext: { isIn in
                self.portfolioDescription.text = isIn ? "In Portfolio" : "Add to Portfolio"
            })
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
    static var artistName: UILabel {
        let label = UILabel()
        label.textColor = ColorPreference.tertiaryColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    static var portfolioDescription: UILabel {
        let label = UILabel()
        label.textColor = ColorPreference.tertiaryColor
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
}
