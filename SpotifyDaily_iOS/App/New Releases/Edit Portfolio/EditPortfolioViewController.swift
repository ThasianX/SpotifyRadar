//
//  EditPortfolioViewController.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/17/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class EditPortfolioViewController: UIViewController, BindableType {
    
    // MARK: - Properties
    // MARK: Section model
    typealias PortfolioSectionModel = SectionModel<String, EditPortfolioCellViewModelType>
    
    // MARK: Viewmodel
    var viewModel: EditPortfolioViewModelType!
    
    // MARK: View components
    private var tableView = UITableView.defaultTableView
    private var addButton: UIBarButtonItem!
    
    // MARK: Private
    private var dataSource: RxTableViewSectionedReloadDataSource<PortfolioSectionModel>!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        setUpView()
    }
    
    deinit {
        Logger.info("EditPortfolioViewController dellocated")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.input.dismissed.onNext(Void())
    }
    
    private func setUpView() {
        self.view.backgroundColor = ColorPreference.secondaryColor
        self.view.addSubview(tableView)
        
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    private func configureNavigationBar() {
        self.title = "Your Portfolio"
        
        addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: nil)
        
        self.navigationItem.rightBarButtonItem = addButton
    }

    private func configureTableView() {
        tableView.allowsSelection = false
        tableView.register(EditPortfolioCell.self, forCellReuseIdentifier: "editPortfolioCell")
        dataSource = RxTableViewSectionedReloadDataSource<PortfolioSectionModel>(
            configureCell:  tableViewDataSource,
            canEditRowAtIndexPath: tableViewCanEdit
        )
    }
    
    func bindViewModel() {
        let input = viewModel.input
        let output = viewModel.output
    
        addButton.rx.tap
            .bind(to: input.addArtists)
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .bind(onNext: { input.artistDeleted(at: $0) })
            .disposed(by: disposeBag)
            
        output.tableViewCellsModelType
            .map { [PortfolioSectionModel(model: "", items: $0)]}
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    private var tableViewDataSource: RxTableViewSectionedReloadDataSource<PortfolioSectionModel>.ConfigureCell {
        return { _, tableView, indexPath, cellModel in
            var cell: EditPortfolioCell = tableView.dequeueReusableCell(withIdentifier: "editPortfolioCell", for: indexPath) as! EditPortfolioCell
            cell.bind(to: cellModel)
            return cell
        }
    }
    
    private var tableViewCanEdit: RxTableViewSectionedReloadDataSource<PortfolioSectionModel>.CanEditRowAtIndexPath {
        return { _, _ in
            return true
        }
    }
}

private struct Constraints {
    static let outerMargins = CGFloat(16)
}
