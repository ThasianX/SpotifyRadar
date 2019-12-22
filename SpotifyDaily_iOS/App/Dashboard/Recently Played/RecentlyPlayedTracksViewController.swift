//
//  RecentlyPlayedTracksViewController.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/10/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class RecentlyPlayedTracksViewController: UIViewController, BindableType {
    
    // MARK: - Properties
    // MARK: Section model
    typealias TracksSectionModel = SectionModel<String, RecentlyPlayedCellViewModelType>
    
    // MARK: Viewmodel
    var viewModel: RecentlyPlayedTracksViewModelType!
    
    // MARK: View components
    private var tableView = UITableView.defaultTableView
    private let recentlyPlayedTitle = UILabel.modalTitle
    
    // MARK: Private
    private var dataSource: RxTableViewSectionedReloadDataSource<TracksSectionModel>!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    deinit {
        Logger.info("RecentlyPlayedTracksViewController dellocated")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.input.dismissed.onNext(Void())
    }
    
    private func setUpView() {
        self.view.backgroundColor = ColorPreference.secondaryColor
        
        configureTableView()
        
        self.view.addSubview(recentlyPlayedTitle)
        self.view.addSubview(tableView)
        
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        recentlyPlayedTitle.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: Constraints.outerMargins).isActive = true
        recentlyPlayedTitle.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        recentlyPlayedTitle.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: recentlyPlayedTitle.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

    private func configureTableView() {
        tableView.register(RecentlyPlayedCell.self, forCellReuseIdentifier: "recentlyPlayedCell")
        dataSource = RxTableViewSectionedReloadDataSource<TracksSectionModel>(
            configureCell:  tableViewDataSource
        )
    }
    
    func bindViewModel() {
        let input = viewModel.input
        let output = viewModel.output
        
        output.tableViewCellsModelType
            .map { [TracksSectionModel(model: "", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.title
            .bind(to: recentlyPlayedTitle.rx.text)
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .flatMap { [weak self] indexPath -> Observable<RecentlyPlayedCell> in
                guard let cell = self?.tableView.cellForRow(at: indexPath) as? RecentlyPlayedCell
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
            var cell: RecentlyPlayedCell = tableView.dequeueReusableCell(withIdentifier: "recentlyPlayedCell", for: indexPath) as! RecentlyPlayedCell
            cell.bind(to: cellModel)
            return cell
        }
    }
    
}

private struct Constraints {
    static let outerMargins = CGFloat(16)
}
