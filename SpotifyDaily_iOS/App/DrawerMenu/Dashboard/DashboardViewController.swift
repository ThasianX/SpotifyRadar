//
//  MainViewController.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/25/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit
import RxSwift

final class DashboardViewController: ViewControllerWithSideMenu {
    
    // MARK: - Properties
    // MARK: View components
    private lazy var topArtistsButton = UIButton.topArtistsButton
    private lazy var topTracksButton = UIButton.topTracksButton
    
    // MARK: Private fields
    private let disposeBag = DisposeBag()
    
    // MARK: Public fields
    var viewModel: DashboardViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    private func setUpView() {
        self.view.addSubview(topArtistsButton)
        self.view.addSubview(topTracksButton)
        
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        topArtistsButton.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 8).isActive = true
        topArtistsButton.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        
        topTracksButton.topAnchor.constraint(equalTo: topArtistsButton.bottomAnchor, constant: 16).isActive = true
        topTracksButton.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        
        self.setUpBindings()
    }
    
    
    private func setUpBindings() {
        guard let viewModel = self.viewModel else { return }
        
        title = viewModel.title
        
        topArtistsButton.rx.tap
            .bind(to: viewModel.presentTopArtists)
            .disposed(by: disposeBag)
        
        topTracksButton.rx.tap
            .bind(to: viewModel.presentTopTracks)
            .disposed(by: disposeBag)
    }
}

private extension UIButton {
    static var topArtistsButton: UIButton {
        let button = UIButton()
        button.setTitle("Navigate to Top Artists", for: .normal)
        button.backgroundColor = .blue
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    static var topTracksButton: UIButton {
        let button = UIButton()
        button.setTitle("Navigate to Top Tracks", for: .normal)
        button.backgroundColor = .blue
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
}
