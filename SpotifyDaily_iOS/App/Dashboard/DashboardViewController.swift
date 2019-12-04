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
    private let artistsTimeRangeControl = UISegmentedControl.timeRangeControl
    private var selectedArtistTimeRange = 0
    
    // MARK: Public fields
    var viewModel: DashboardViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    private func setUpView() {
        self.view.addSubview(artistsTimeRangeControl)
        
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        artistsTimeRangeControl.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: Constraints.controlMargin).isActive = true
        artistsTimeRangeControl.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        artistsTimeRangeControl.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        artistsTimeRangeControl.heightAnchor.constraint(equalToConstant: Metric.height).isActive = true
        
        self.setUpBindings()
    }
    
    
    private func setUpBindings() {
        guard let viewModel = self.viewModel else { return }
        
        self.title = viewModel.title
        
        self.artistsTimeRangeControl.selectedSegmentIndex = viewModel.timeRangeItems.firstIndex(of: viewModel.artistsTimeRange.value)!
        
    }
}

internal struct Constraints {
    static let controlMargin = CGFloat(16)
}

internal struct Metric {
    static let radius = CGFloat(9)
    static let height = CGFloat(30)
    static let tintColor = UIColor.black
    
}

private extension UISegmentedControl {
    static var timeRangeControl: UISegmentedControl {
        let items = ["short_term", "medium_term", "long_term"]
        let control = UISegmentedControl(items: items)
        control.layer.cornerRadius = Metric.radius
        control.tintColor = Metric.tintColor
        control.layer.masksToBounds = true
        
        control.translatesAutoresizingMaskIntoConstraints = false
        
        return control
    }
}
