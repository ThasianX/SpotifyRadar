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

class AddArtistsViewController: UIViewController, BindableType {
    
    // MARK: - Properties
    // MARK: Section model
    typealias AddArtistSectionModel = SectionModel<String, SearchArtistCellViewModelType>
    
    // MARK: View model
    var viewModel: AddArtistsViewModel!
    
    // MARK: UIView Components
    private var resultsTableView = UITableView.defaultTableView
    private var searchController: UISearchController!
    
    // MARK: Public
    var searchBar: UISearchBar { return searchController.searchBar }
    
    // MARK: Private
    private let disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<AddArtistSectionModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureSearchController()
        setUpView()
    }
    
    deinit {
        Logger.info("AddArtistsViewController dellocated")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Logger.info("View did disappear")
        searchController.dismiss(animated: true, completion: nil)
        viewModel.input.dismissed.onNext(Void())
    }
    
    
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Enter Artist Name..."
        searchBar.barTintColor = ColorPreference.secondaryColor
        searchBar.tintColor = ColorPreference.mainColor
        searchBar.searchTextField.textColor = ColorPreference.mainColor
        resultsTableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    
    private func configureTableView() {
        resultsTableView.register(SearchArtistCell.self, forCellReuseIdentifier: "searchArtistCell")
        dataSource = RxTableViewSectionedReloadDataSource<AddArtistSectionModel>(
            configureCell:  tableViewDataSource
        )
    }
    
    private func setUpView() {
        self.view.backgroundColor = ColorPreference.secondaryColor
        
        self.view.addSubview(resultsTableView)
        
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        resultsTableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        resultsTableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        resultsTableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        resultsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
    }
    
    func bindViewModel() {
        let input = viewModel.input
        let output = viewModel.output
        
        searchBar.rx.textDidBeginEditing
            .bind(onNext: { self.searchBar.showsCancelButton = true })
            .disposed(by: disposeBag)
        
        searchBar.rx.textDidEndEditing
            .bind(onNext: { self.searchBar.showsCancelButton = false })
            .disposed(by: disposeBag)
        
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
            .map {
                return [AddArtistSectionModel(model: "", items: $0)]
        }
        .bind(to: resultsTableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        resultsTableView.rx.itemSelected
            .flatMap { [weak self] indexPath -> Observable<SearchArtistCell> in
                guard let cell = self?.resultsTableView.cellForRow(at: indexPath) as? SearchArtistCell
                    else { return .empty() }
                cell.portfolioDescription.text = "In Portfolio"
                self?.resultsTableView.deselectRow(at: indexPath, animated: true)
                return .just(cell)
        }
        .map { $0.viewModel }
        .flatMap { $0.output.artist }
        .bind(onNext: { [unowned self] in
            input.artistSelected(from: self, artist: $0)
        })
            .disposed(by: self.disposeBag)
    }
    
    private var tableViewDataSource: TableViewSectionedDataSource<AddArtistSectionModel>.ConfigureCell {
        return { _, tableView, indexPath, cellModel in
            var cell: SearchArtistCell = tableView.dequeueReusableCell(withIdentifier: "searchArtistCell", for: indexPath) as! SearchArtistCell
            cell.bind(to: cellModel)
            return cell
        }
    }
}
