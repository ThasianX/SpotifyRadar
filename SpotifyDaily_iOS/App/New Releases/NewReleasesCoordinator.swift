//
//  NewReleasesCoordinator.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/16/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class NewReleasesCoordinator: BaseCoordinator {
    
    private let viewModel: NewReleasesViewModel
    private let dataManager: DataManager
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: NewReleasesViewModel, dataManager: DataManager) {
        self.viewModel = viewModel
        self.dataManager = dataManager
    }
    
    deinit {
        Logger.info("NewReleasesCoordinator dellocated")
    }
    
    override func start() {
        var viewController = NewReleasesViewController()
        
        self.navigationController.viewControllers = [viewController]
        
        viewController.bind(to: viewModel)
        setUpBindings()
    }
    
    private func setUpBindings() {
        let input = viewModel.input
        
        input.presentEditPortfolio.bind(onNext: { [weak self] in
            self?.presentEditPortfolio()
        })
            .disposed(by: disposeBag)
        
        input.childDismissed.bind(onNext: { [weak self] in
            self?.removeChildCoordinators()
        })
        .disposed(by: disposeBag)
    }
    
    private func presentEditPortfolio() {
        Logger.info("Presenting edit portfolio")

        let coordinator = AppDelegate.container.resolve(AddArtistsCoordinator.self)!
        coordinator.navigationController = self.navigationController
        coordinator.parentViewModel = self.viewModel

        self.start(coordinator: coordinator)
    }
    
}
