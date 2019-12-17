//
//  NewTracksViewController.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/16/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class NewReleasesViewController: UIViewController, BindableType {
    
    // MARK: - Properties
    // MARK: Section model
    typealias TracksSectionModel = SectionModel<String, NewTracksCellViewModelType>
    
    // MARK: Viewmodel
    var viewModel: NewReleasesViewModelType!
    
    // MARK: View components
    private var tableView = UITableView.defaultTableView
    
    // MARK: Private
    private var dataSource: RxTableViewSectionedReloadDataSource<TracksSectionModel>!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    deinit {
        Logger.info("NewReleasesViewController dellocated")
    }
    
    private func setUpView() {
        self.view.backgroundColor = ColorPreference.secondaryColor
        
        configureTableView()
        
        self.view.addSubview(tableView)
        
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

    private func configureTableView() {
        tableView.register(NewTrackCell.self, forCellReuseIdentifier: "newTrackCell")
        dataSource = RxTableViewSectionedReloadDataSource<TracksSectionModel>(
            configureCell:  tableViewDataSource
        )
    }
    
    func bindViewModel() {
        let input = viewModel.input
        let output = viewModel.output
        
        output.newTracksCellModelType
            .map { [TracksSectionModel(model: "", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .flatMap { [weak self] indexPath -> Observable<NewTrackCell> in
                guard let cell = self?.tableView.cellForRow(at: indexPath) as? NewTrackCell
                    else { return .empty() }
                self?.tableView.deselectRow(at: indexPath, animated: true)
                return .just(cell)
            }
        .map { $0.viewModel }
        .flatMap { $0.output.track }
        .bind(onNext: { [unowned self] in
            input.trackSelected(from: self, track: $0)
        })
        .disposed(by: self.disposeBag)
    }

    private var tableViewDataSource:
        RxTableViewSectionedReloadDataSource<TracksSectionModel>.ConfigureCell {
        return { _, tableView, indexPath, cellModel in
            var cell: NewTrackCell = tableView.dequeueReusableCell(withIdentifier: "newTrackCell", for: indexPath) as! NewTrackCell
            cell.bind(to: cellModel)
            return cell
        }
    }
    
}

private struct Constraints {
    static let outerMargins = CGFloat(16)
}
