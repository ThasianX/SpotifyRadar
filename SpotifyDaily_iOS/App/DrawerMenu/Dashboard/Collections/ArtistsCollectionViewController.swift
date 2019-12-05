//
//  ArtistsCollectionViewController.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/4/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ArtistsCollectionViewController: UIViewController, BindableType {
    
    // MARK: - Properties
    // MARK: BindableType conformance
    typealias ArtistsSectionModel = SectionModel<String, CollectionCellViewModelType>
    
    // MARK: Viewmodel
    var viewModel: CollectionsViewModelType!
    
    // MARK: View components
    private var collectionView: UICollectionView!
    private var refreshControl: UIRefreshControl!
    private let artistsTimeRangeControl = UISegmentedControl.timeRangeControl
    
    // MARK: Private
    private var dataSource: RxCollectionViewSectionedReloadDataSource<ArtistsSectionModel>!
    private let disposeBag = DisposeBag()
    private var selectedArtistTimeRange = 0
    private let timeRangeItems = ["short_term", "medium_term", "long_term"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    func bindViewModel() {
        let input = viewModel.input
        let output = viewModel.output
        
        self.artistsTimeRangeControl.selectedSegmentIndex = self.timeRangeItems.firstIndex(of: viewModel.input.artistsTimeRange.value)!

        output.isRefreshing
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        output.collectionCellsModelType
            .map { [ArtistsSectionModel(model: "", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        collectionView.rx.reachedBottom()
            .bind(to: input.loadMore)
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .flatMap { [weak self] indexPath -> Observable<ArtistCollectionCell> in
                guard let cell = self?.collectionView.cellForItem(at: indexPath) as? ArtistCollectionCell
                    else { return .empty() }
                return .just(cell)
            }
        .map { $0.viewModel }
        .flatMap { $0.output.artist }
        .bind(onNext: { input.artistSelected(artist: $0)})
        .disposed(by: self.disposeBag)
    }
    
    private func setUpView() {
        configureCollectionView()
        configureRefreshControl()
        
        self.view.addSubview(collectionView)
        collectionView.addSubview(refreshControl)
        self.view.addSubview(artistsTimeRangeControl)
        
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        artistsTimeRangeControl.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: Constraints.controlMargin).isActive = true
        artistsTimeRangeControl.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        artistsTimeRangeControl.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        artistsTimeRangeControl.heightAnchor.constraint(equalToConstant: Metric.height).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: artistsTimeRangeControl.bottomAnchor, constant: Constraints.controlMargin*2).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: artistsTimeRangeControl.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: artistsTimeRangeControl.trailingAnchor).isActive = true
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let spacing = (1 / UIScreen.main.scale) + 16
        let cellWidth = (UIScreen.main.bounds.width / 2) - spacing

        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        flowLayout.sectionInset = UIEdgeInsets(top: 16.0, left: 8.0, bottom: 0, right: 8.0)
        flowLayout.minimumLineSpacing = spacing

        collectionView.register(ArtistCollectionCell.self, forCellWithReuseIdentifier: "artistCollectionCell")
        dataSource = RxCollectionViewSectionedReloadDataSource<ArtistsSectionModel>(
            configureCell:  collectionViewDataSource
        )
    }

    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }

    @objc private func refresh() {
        viewModel.input.refresh()
    }

    private var collectionViewDataSource: CollectionViewSectionedDataSource<ArtistsSectionModel>.ConfigureCell {
        return { _, tableView, indexPath, cellModel in
            var cell: ArtistCollectionCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cartistCollectionCell", for: indexPath) as! ArtistCollectionCell
            cell.bind(to: cellModel)
            return cell
        }
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
