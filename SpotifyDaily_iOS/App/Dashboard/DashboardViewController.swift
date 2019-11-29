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
    
    private let disposeBag = DisposeBag()
    var viewModel: DashboardViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    private func setUpView() {
        guard let viewModel = self.viewModel else { return }
        
        self.title = viewModel.title
        
//        viewModel.isLoading
//            .bind(to: self.activityIndicator.rx.isAnimating)
//            .disposed(by: self.disposeBag)
        
    }

}
