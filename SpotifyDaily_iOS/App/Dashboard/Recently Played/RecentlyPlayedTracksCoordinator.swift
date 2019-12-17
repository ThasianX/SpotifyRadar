//
//  RecentlyPlayedTracksCoordinator.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/10/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class RecentlyPlayedTracksCoordinator: BaseCoordinator {
    
    var recentlyPlayedViewController: BaseNavigationController!
    weak var parentViewModel: DashboardViewModel!
    
    private let viewModel: RecentlyPlayedTracksViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: RecentlyPlayedTracksViewModel) {
        self.viewModel = viewModel
    }
    
    deinit {
        Logger.info("RecentlyPlayedTracksCoordinator dellocated")
    }
    
    override func start() {
        var viewController = RecentlyPlayedTracksViewController()
        viewController.bind(to: self.viewModel)
        
        recentlyPlayedViewController = BaseNavigationController(rootViewController: viewController)
        recentlyPlayedViewController.navigationBar.isHidden = true
        
        self.navigationController.presentOnTop(recentlyPlayedViewController, animated: true)
        
        viewModel.input.dismissed
            .bind(to: parentViewModel.input.childDismissed)
            .disposed(by: disposeBag)
    }
    
}
