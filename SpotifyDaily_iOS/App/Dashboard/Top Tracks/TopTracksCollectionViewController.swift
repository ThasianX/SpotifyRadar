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
    private var collectionView = UICollectionView.defaultCollectionView
    private let tracksTimeRangeControl = UISegmentedControl.timeRangeControl
    private let topTracksTitle = UILabel.modalTitle
    
    // MARK: Private
    private var dataSource: RxCollectionViewSectionedReloadDataSource<TracksSectionModel>!
    private let disposeBag = DisposeBag()
    private let timeRangeItems = ["short_term", "medium_term", "long_term"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    deinit {
        Logger.info("TopTracksCollectionViewController dellocated")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Logger.info("View did disappear")
        viewModel.input.dismissed.onNext(Void())
    }
    
    private func setUpView() {
        self.view.backgroundColor = ColorPreference.secondaryColor
        
        configureCollectionView()
        
        self.view.addSubview(topTracksTitle)
        self.view.addSubview(collectionView)
        self.view.addSubview(tracksTimeRangeControl)
        
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        topTracksTitle.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: Constraints.controlMargin).isActive = true
        topTracksTitle.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        topTracksTitle.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        
        tracksTimeRangeControl.topAnchor.constraint(equalTo: topTracksTitle.bottomAnchor, constant: Constraints.controlMargin).isActive = true
        tracksTimeRangeControl.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        tracksTimeRangeControl.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        tracksTimeRangeControl.heightAnchor.constraint(equalToConstant: Constraints.height).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: tracksTimeRangeControl.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

    private func configureCollectionView() {
        collectionView.register(TrackCollectionCell.self, forCellWithReuseIdentifier: "trackCollectionCell")
        dataSource = RxCollectionViewSectionedReloadDataSource<TracksSectionModel>(
            configureCell:  collectionViewDataSource
        )
    }
    
    func bindViewModel() {
        let input = viewModel.input
        let output = viewModel.output
        
        tracksTimeRangeControl.selectedSegmentIndex = self.timeRangeItems.firstIndex(of: viewModel.input.tracksTimeRange.value)!
        
        tracksTimeRangeControl.rx.selectedSegmentIndex
            .skip(1)
            .bind(onNext: { [weak self] index in
            let title = self?.tracksTimeRangeControl.titleForSegment(at: index)
            input.tracksTimeRange.accept(title!)
        })
            .disposed(by: disposeBag)
        
        output.collectionCellsModelType
            .map { [TracksSectionModel(model: "", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.title
            .bind(to: topTracksTitle.rx.text)
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
        return { _, collectionView, indexPath, cellModel in
            var cell: TrackCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackCollectionCell", for: indexPath) as! TrackCollectionCell
            cell.bind(to: cellModel)
            return cell
        }
    }
    
}

private struct Constraints {
    static let controlMargin = CGFloat(16)
    static let height = CGFloat(30)
}
