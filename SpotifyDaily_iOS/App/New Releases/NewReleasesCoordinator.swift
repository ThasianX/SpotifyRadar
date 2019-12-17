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
    
    private let viewModel: NewReleasesViewModelType
    private let dataManager: DataManager
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: NewReleasesViewModelType, dataManager: DataManager) {
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
        
        input.presentAddArtists.bind(onNext: { [weak self] in
            self?.presentAddArtists()
        })
            .disposed(by: disposeBag)
        
        input.presentEditPortfolio.bind(onNext: { [weak self] in
            self?.presentEditPortfolio()
        })
            .disposed(by: disposeBag)
        
        input.childDismissed.bind(onNext: { [weak self] in
            self?.removeChildCoordinators()
        })
        .disposed(by: disposeBag)
    }
    
    private func presentAddArtists() {
        Logger.info("Presenting add artists")

//        let coordinator = AppDelegate.container.resolve(TopArtistsCollectionCoordinator.self)!
//        coordinator.navigationController = self.navigationController
//        coordinator.parentViewModel = self.viewModel
//
//        self.start(coordinator: coordinator)
    }
    
    private func presentEditPortfolio() {
        Logger.info("Presenting edit portfolio")

//        let coordinator = AppDelegate.container.resolve(TopTracksCollectionCoordinator.self)!
//        coordinator.navigationController = self.navigationController
//        coordinator.parentViewModel = self.viewModel
//
//        self.start(coordinator: coordinator)
    }
    
}
