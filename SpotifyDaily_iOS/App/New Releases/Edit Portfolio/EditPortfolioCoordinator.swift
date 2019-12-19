//
//  EditPortfolioCoordinator.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/17/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class EditPortfolioCoordinator: BaseCoordinator {
    
    var editPortfolioViewController: BaseNavigationController!
    weak var parentViewModel: NewReleasesViewModel!
    
    private let viewModel: EditPortfolioViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: EditPortfolioViewModel) {
        self.viewModel = viewModel
    }
    
    deinit {
        Logger.info("EditPortfolioCoordinator dellocated")
    }
    
    override func start() {
        var viewController = EditPortfolioViewController()
        viewController.bind(to: viewModel)
        
        editPortfolioViewController = BaseNavigationController(rootViewController: viewController)
        
        self.navigationController.presentOnTop(editPortfolioViewController, animated: true)
        
        viewModel.input.dismissed
            .bind(to: parentViewModel.input.childDismissed)
            .disposed(by: disposeBag)
        
        viewModel.input.addArtists
            .bind(onNext: { [unowned self] in
                self.presentAddArtists()
            })
            .disposed(by: disposeBag)
        
        viewModel.input.childDismissed
            .bind(onNext: { [unowned self] in
                self.removeChildCoordinators()
            })
            .disposed(by: disposeBag)
    }
    
    private func presentAddArtists() {
        let coordinator = AppDelegate.container.resolve(AddArtistsCoordinator.self)!
        coordinator.navigationController = self.navigationController
        coordinator.parentViewModel = self.viewModel
        
        self.start(coordinator: coordinator)
    }
}
