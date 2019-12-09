//
//  TopTracksCollectionViewController.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/8/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class TopTracksCollectionViewController: UIViewController, BindableType {
    
    // MARK: - Properties
    // MARK: Section model
    typealias TracksSectionModel = SectionModel<String, TrackCollectionCellViewModelType>
    
    // MARK: Viewmodel
    var viewModel: TopTracksCollectionsViewModelType!
    
    // MARK: View components
    private var collectionView: UICollectionView!
    private let artistsTimeRangeControl = UISegmentedControl.timeRangeControl
    private let topTracksTitle = UILabel.modalTitle
    
    // MARK: Private
    private var dataSource: RxCollectionViewSectionedReloadDataSource<TracksSectionModel>!
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
        
        self.view.addSubview(topTracksTitle)
        self.view.addSubview(collectionView)
        self.view.addSubview(artistsTimeRangeControl)
        
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        topTracksTitle.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: Constraints.controlMargin).isActive = true
        topTracksTitle.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        topTracksTitle.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        
        artistsTimeRangeControl.topAnchor.constraint(equalTo: topTracksTitle.bottomAnchor, constant: Constraints.controlMargin).isActive = true
        artistsTimeRangeControl.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        artistsTimeRangeControl.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        artistsTimeRangeControl.heightAnchor.constraint(equalToConstant: Constraints.height).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: artistsTimeRangeControl.bottomAnchor, constant: Constraints.controlMargin*2).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: artistsTimeRangeControl.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: artistsTimeRangeControl.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let spacing = (1 / UIScreen.main.scale) + 16
        let cellWidth = (UIScreen.main.bounds.width / 2) - spacing

        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        flowLayout.sectionInset = UIEdgeInsets(top: 16.0, left: 8.0, bottom: 0, right: 8.0)
        flowLayout.minimumLineSpacing = spacing

        collectionView.register(TrackCollectionCell.self, forCellWithReuseIdentifier: "trackCollectionCell")
        dataSource = RxCollectionViewSectionedReloadDataSource<TracksSectionModel>(
            configureCell:  collectionViewDataSource
        )
    }
    
    func bindViewModel() {
        let input = viewModel.input
        let output = viewModel.output
        
        self.artistsTimeRangeControl.selectedSegmentIndex = self.timeRangeItems.firstIndex(of: viewModel.input.tracksTimeRange.value)!
        
        output.collectionCellsModelType
            .map { [TracksSectionModel(model: "", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.title
            .bind(to: topTracksTitle.rx.text)
            .disposed(by: disposeBag)
        
        artistsTimeRangeControl.rx.selectedSegmentIndex
            .bind(onNext: { [weak self] index in
            let title = self?.artistsTimeRangeControl.titleForSegment(at: index)
            input.tracksTimeRange.accept(title!)
        })
            .disposed(by: disposeBag)

        collectionView.rx.reachedBottom()
            .bind(to: input.loadMore)
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .flatMap { [weak self] indexPath -> Observable<TrackCollectionCell> in
                guard let cell = self?.collectionView.cellForItem(at: indexPath) as? TrackCollectionCell
                    else { return .empty() }
                return .just(cell)
            }
        .map { $0.viewModel }
        .flatMap { $0.output.track }
        .bind(onNext: { [unowned self] in
            input.trackSelected(from: self, track: $0)
        })
        .disposed(by: self.disposeBag)
    }

    private var collectionViewDataSource: CollectionViewSectionedDataSource<TracksSectionModel>.ConfigureCell {
        return { _, tableView, indexPath, cellModel in
            var cell: TrackCollectionCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "trackCollectionCell", for: indexPath) as! TrackCollectionCell
            cell.bind(to: cellModel)
            return cell
        }
    }
    
}

private struct Constraints {
    static let controlMargin = CGFloat(16)
    static let height = CGFloat(30)
}
