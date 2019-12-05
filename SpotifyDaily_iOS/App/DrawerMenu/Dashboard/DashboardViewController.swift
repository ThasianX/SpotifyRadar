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
    private let disposeBag = DisposeBag()
    
    // MARK: Public fields
    var viewModel: DashboardViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    private func setUpView() {
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        self.setUpBindings()
    }
    
    
    private func setUpBindings() {
        guard let viewModel = self.viewModel else { return }
        
    }
}
