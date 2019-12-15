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
    private var collectionView = UICollectionView.defaultCollectionView
    private let artistsTimeRangeControl = UISegmentedControl.timeRangeControl
    private let topArtistsTitle = UILabel.modalTitle
    
    // MARK: Private
    private var dataSource: RxCollectionViewSectionedReloadDataSource<ArtistsSectionModel>!
    private let disposeBag = DisposeBag()
    private let timeRangeItems = ["short_term", "medium_term", "long_term"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    deinit {
        Logger.info("TopArtistsCollectionViewController dellocated")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Logger.info("View did disappear")
        viewModel.input.dismissed.onNext(Void())
    }
    
    private func setUpView() {
        self.view.backgroundColor = ColorPreference.secondaryColor
        
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
        collectionView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

    private func configureCollectionView() {
        collectionView.register(ArtistCollectionCell.self, forCellWithReuseIdentifier: "artistCollectionCell")
        dataSource = RxCollectionViewSectionedReloadDataSource<ArtistsSectionModel>(
            configureCell:  collectionViewDataSource
        )
    }
    
    func bindViewModel() {
        let input = viewModel.input
        let output = viewModel.output
        
        artistsTimeRangeControl.selectedSegmentIndex = self.timeRangeItems.firstIndex(of: viewModel.input.artistsTimeRange.value)!
        
        artistsTimeRangeControl.rx.selectedSegmentIndex
            .skip(1)
            .bind(onNext: { [weak self] index in
            let title = self?.artistsTimeRangeControl.titleForSegment(at: index)
            input.artistsTimeRange.accept(title!)
        })
            .disposed(by: disposeBag)
        
        output.collectionCellsModelType
            .map { [ArtistsSectionModel(model: "", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.title
            .bind(to: topArtistsTitle.rx.text)
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
        .bind(onNext: { [unowned self] in
            input.artistSelected(from: self, artist: $0)
        })
        .disposed(by: self.disposeBag)
    }

    private var collectionViewDataSource: CollectionViewSectionedDataSource<ArtistsSectionModel>.ConfigureCell {
        return { _, collectionView, indexPath, cellModel in
            var cell: ArtistCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "artistCollectionCell", for: indexPath) as! ArtistCollectionCell
            cell.bind(to: cellModel)
            return cell
        }
    }
    
}

private struct Constraints {
    static let controlMargin = CGFloat(16)
    static let height = CGFloat(30)
}
