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
        
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        topArtistsButton.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 8).isActive = true
        topArtistsButton.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        
        self.setUpBindings()
    }
    
    
    private func setUpBindings() {
        guard let viewModel = self.viewModel else { return }
        
        title = viewModel.title
        
        topArtistsButton.rx.tap.bind(onNext: { [weak self] in
//            viewModel.presentTopArtist.onNext(Void())
        })
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
}
