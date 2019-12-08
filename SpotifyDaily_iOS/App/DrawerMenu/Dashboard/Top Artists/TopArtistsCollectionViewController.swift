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

final class TopArtistsCollectionViewController: UIViewController, BindableType {
    
    // MARK: - Properties
    // MARK: Section model
    typealias ArtistsSectionModel = SectionModel<String, ArtistCollectionCellViewModelType>
    
    // MARK: Viewmodel
    var viewModel: TopArtistsCollectionsViewModelType!
    
    // MARK: View components
    private var collectionView: UICollectionView!
    private let artistsTimeRangeControl = UISegmentedControl.timeRangeControl
    private let topArtistsTitle = UILabel.modalTitle
    
    // MARK: Private
    private var dataSource: RxCollectionViewSectionedReloadDataSource<ArtistsSectionModel>!
    private let disposeBag = DisposeBag()
    private var selectedArtistTimeRange = 0
    private let timeRangeItems = ["short_term", "medium_term", "long_term"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    private func setUpView() {
        self.view.backgroundColor = ColorPreference.mainColor
        
        configureCollectionView()
        
        self.view.addSubview(topArtistsTitle)
        self.view.addSubview(collectionView)
        self.view.addSubview(artistsTimeRangeControl)
        
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        topArtistsTitle.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: Constraints.controlMargin).isActive = true
        topArtistsTitle.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        topArtistsTitle.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        
        artistsTimeRangeControl.topAnchor.constraint(equalTo: topArtistsTitle.bottomAnchor, constant: Constraints.controlMargin).isActive = true
        artistsTimeRangeControl.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        artistsTimeRangeControl.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        artistsTimeRangeControl.heightAnchor.constraint(equalToConstant: Constraints.height).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: artistsTimeRangeControl.bottomAnchor, constant: Constraints.controlMargin*2).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: artistsTimeRangeControl.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: artistsTimeRangeControl.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
    }

    private func configureCollectionView() {
        Logger.info("Configuring collection view")
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    func bindViewModel() {
        Logger.info("Binding view model")
        
        let input = viewModel.input
        let output = viewModel.output
        
        self.artistsTimeRangeControl.selectedSegmentIndex = self.timeRangeItems.firstIndex(of: viewModel.input.artistsTimeRange.value)!
        
        output.collectionCellsModelType
            .map { [ArtistsSectionModel(model: "", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.title
            .bind(to: topArtistsTitle.rx.text)
            .disposed(by: disposeBag)
        
        artistsTimeRangeControl.rx.selectedSegmentIndex
            .bind(onNext: { [weak self] index in
            let title = self?.artistsTimeRangeControl.titleForSegment(at: index)
            input.artistsTimeRange.accept(title!)
        })
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

    private var collectionViewDataSource: CollectionViewSectionedDataSource<ArtistsSectionModel>.ConfigureCell {
        return { _, tableView, indexPath, cellModel in
            Logger.info("Binding cell to view model")
            var cell: ArtistCollectionCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "artistCollectionCell", for: indexPath) as! ArtistCollectionCell
            cell.bind(to: cellModel)
            return cell
        }
    }
    
}

private struct Constraints {
    static let controlMargin = CGFloat(16)
    static let height = CGFloat(30)
}
