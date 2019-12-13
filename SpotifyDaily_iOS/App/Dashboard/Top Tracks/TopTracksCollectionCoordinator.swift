//
//  TopTracksCoordinator.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/8/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class TopTracksCollectionCoordinator: BaseCoordinator {
    
    var topTracksViewController: BaseNavigationController!
    weak var parentViewModel: DashboardViewModel!
    
    private let viewModel: TopTracksCollectionViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: TopTracksCollectionViewModel) {
        self.viewModel = viewModel
    }
    
    deinit {
        Logger.info("TopTracksCollectionCoordinator dellocated")
    }

    override func start() {
        var viewController = TopTracksCollectionViewController()
        viewController.bind(to: self.viewModel)
        
        topTracksViewController = BaseNavigationController(rootViewController: viewController)
        topTracksViewController.navigationBar.isHidden = true
        
        self.navigationController.presentOnTop(topTracksViewController, animated: true)
        
        viewModel.input.dismissed
        .bind(to: parentViewModel.childDismissed)
        .disposed(by: disposeBag)
    }
    
}
