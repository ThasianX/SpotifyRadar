//
//  RecommendationsViewController.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/27/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SearchArtistsViewController: ViewControllerWithSideMenu {
    
    // MARK: - Properties
    // MARK: Section model
    typealias SearchArtistSectionModel = SectionModel<String, SearchArtistCellViewModelType>
    
    // MARK: View model
    var viewModel: SearchArtistsViewModel!
    
    // MARK: UIView Components
    private var resultsTableView = UITableView.defaultTableView
    private let searchController = UISearchController(searchResultsController: nil)
    var searchBar: UISearchBar { return searchController.searchBar }
    
    // MARK: Private
    private let disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<SearchArtistSectionModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        self.setUpView()
        self.setUpBindings()
    }
    
    deinit {
        Logger.info("SearchArtistsViewController dellocated")
    }
    
    private func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Enter Artist Name..."
        resultsTableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor.red
    }
    
    private func setUpView() {
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        resultsTableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        resultsTableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        resultsTableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        resultsTableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        
    }
    
    private func setUpBindings() {
        let input = viewModel.input
        let output = viewModel.output
        
        self.title = viewModel.output.title
        
        searchBar.rx.text.orEmpty
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
        .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .bind(to: input.searchText)
        .disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked
            .map { "" }
            .bind(to: input.searchText)
        .disposed(by: disposeBag)
        
        output.tableViewCellsModelType
            .map { [SearchArtistSectionModel(model: "", items: $0)] }
            .bind(to: resultsTableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        resultsTableView.rx.itemSelected
            .flatMap { [weak self] indexPath -> Observable<SearchArtistCell> in
                    guard let cell = self?.resultsTableView.cellForRow(at: indexPath) as? SearchArtistCell
                        else { return .empty() }
                    self?.resultsTableView.deselectRow(at: indexPath, animated: true)
                    return .just(cell)
                }
            .map { $0.viewModel }
            .flatMap { $0.output.artist }
            .bind(onNext: { [unowned self] in
                input.artistSelected(from: self, track: $0)
            })
            .disposed(by: self.disposeBag)
        
        // TODO: Add binding to update resulttableview after click
    }
    
    private func configureTableView() {
        resultsTableView.register(SearchArtistCell.self, forCellReuseIdentifier: "searchArtistCell")
        dataSource = RxTableViewSectionedReloadDataSource<SearchArtistSectionModel>(
            configureCell:  tableViewDataSource
        )
    }
    
    private var tableViewDataSource: TableViewSectionedDataSource<SearchArtistSectionModel>.ConfigureCell {
        return { _, tableView, indexPath, cellModel in
            var cell: SearchArtistCell = tableView.dequeueReusableCell(withIdentifier: "searchArtistCell", for: indexPath) as! SearchArtistCell
            cell.bind(to: cellModel)
            return cell
        }
    }

    
}

private extension UIView {
}
