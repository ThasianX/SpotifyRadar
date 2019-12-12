//
//  MainViewController.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/25/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa

final class DashboardViewController: ViewControllerWithSideMenu, BindableType {
    // MARK: - Properties
    // MARK: View components
    private lazy var topArtistsButton = UIButton.topArtistsButton
    private lazy var topTracksButton = UIButton.topTracksButton
    private lazy var recentlyPlayedButton = UIButton.recentlyPlayedButton
    private lazy var topArtistsCollectionView = UICollectionView.defaultCollectionView
    private lazy var topTracksCollectionView = UICollectionView.defaultCollectionView
    private var recentlyPlayedTracksTableView: UITableView!
    
    // MARK: Section models
    typealias ArtistsSectionModel = SectionModel<String, ArtistCollectionCellViewModelType>
    typealias TracksSectionModel = SectionModel<String, TrackCollectionCellViewModelType>
    typealias RecentlyPlayedTracksSectionModel = SectionModel<String, RecentlyPlayedCellViewModelType>
    
    // MARK: Data sources
    private var topArtistsDataSource: RxCollectionViewSectionedReloadDataSource<ArtistsSectionModel>!
    private var topTracksDataSource: RxCollectionViewSectionedReloadDataSource<TracksSectionModel>!
    private var recentlyPlayedTracksDataSource: RxTableViewSectionedReloadDataSource<RecentlyPlayedTracksSectionModel>!
    
    // MARK: Private fields
    private let disposeBag = DisposeBag()
    
    // MARK: Public fields
    var viewModel: DashboardViewModel!
    
    override func viewDidLayoutSubviews() {
        view.layoutIfNeeded()
        topArtistsButton.disclosureButton()
        topTracksButton.disclosureButton()
        recentlyPlayedButton.disclosureButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Spotify Daily Dashboard"
        self.setUpView()
    }
    
    private func setUpView() {
        self.view.addSubview(topArtistsButton)
        self.view.addSubview(topTracksButton)
        self.view.addSubview(recentlyPlayedButton)
        
        configureCollectionViews()
        configureTableView()
        self.view.addSubview(topArtistsCollectionView)
        self.view.addSubview(topTracksCollectionView)
        self.view.addSubview(recentlyPlayedTracksTableView)
        
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        topArtistsButton.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: Constraints.outerMargins).isActive = true
        topArtistsButton.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: Constraints.outerMargins).isActive = true
        topArtistsButton.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -Constraints.outerMargins).isActive = true
        
        topArtistsCollectionView.topAnchor.constraint(equalTo: topArtistsButton.bottomAnchor, constant: Constraints.innerMargins).isActive = true
        topArtistsCollectionView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        topArtistsCollectionView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        topArtistsCollectionView.heightAnchor.constraint(equalToConstant: Constraints.offset).isActive = true
        
        topTracksButton.topAnchor.constraint(equalTo: topArtistsCollectionView.bottomAnchor).isActive = true
        topTracksButton.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: Constraints.outerMargins).isActive = true
        topTracksButton.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -Constraints.outerMargins).isActive = true
        
        topTracksCollectionView.topAnchor.constraint(equalTo: topTracksButton.bottomAnchor, constant: Constraints.innerMargins).isActive = true
        topTracksCollectionView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        topTracksCollectionView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        topTracksCollectionView.heightAnchor.constraint(equalToConstant: Constraints.offset).isActive = true
        
        recentlyPlayedButton.topAnchor.constraint(equalTo: topTracksCollectionView.bottomAnchor).isActive = true
        recentlyPlayedButton.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: Constraints.outerMargins).isActive = true
        recentlyPlayedButton.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -Constraints.outerMargins).isActive = true
        
        recentlyPlayedTracksTableView.topAnchor.constraint(equalTo: recentlyPlayedButton.bottomAnchor, constant: Constraints.innerMargins).isActive = true
        recentlyPlayedTracksTableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        recentlyPlayedTracksTableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        recentlyPlayedTracksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func configureCollectionViews() {
        topArtistsCollectionView.register(ArtistCollectionCell.self, forCellWithReuseIdentifier: "artistCollectionCell")
        topArtistsDataSource = RxCollectionViewSectionedReloadDataSource<ArtistsSectionModel>(
            configureCell:  topArtistsCollectionViewDataSource
        )
        
        topTracksCollectionView.register(TrackCollectionCell.self, forCellWithReuseIdentifier: "trackCollectionCell")
        topTracksDataSource = RxCollectionViewSectionedReloadDataSource<TracksSectionModel>(
            configureCell:  topTracksCollectionViewDataSource
        )
    }
    
    private func configureTableView() {
        recentlyPlayedTracksTableView = UITableView()
        recentlyPlayedTracksTableView.backgroundColor = .white
        recentlyPlayedTracksTableView.translatesAutoresizingMaskIntoConstraints = false
        
        recentlyPlayedTracksTableView.register(RecentlyPlayedCell.self, forCellReuseIdentifier: "recentlyPlayedCell")
        recentlyPlayedTracksDataSource = RxTableViewSectionedReloadDataSource<RecentlyPlayedTracksSectionModel>(
            configureCell:  recentlyPlayedTracksTableViewDataSource
        )
    }
    
    func bindViewModel() {
        guard let viewModel = self.viewModel else { return }
        
        let input = viewModel.input
        let output = viewModel.output

        topArtistsButton.rx.tap
            .bind(to: input.presentTopArtists)
            .disposed(by: disposeBag)
        
        topTracksButton.rx.tap
            .bind(to: input.presentTopTracks)
            .disposed(by: disposeBag)
        
        recentlyPlayedButton.rx.tap
            .bind(to: input.presentRecentlyPlayed)
            .disposed(by: disposeBag)
        
        topArtistsCollectionView.rx.itemSelected
            .flatMap { [weak self] indexPath -> Observable<ArtistCollectionCell> in
                guard let cell = self?.topArtistsCollectionView.cellForItem(at: indexPath) as? ArtistCollectionCell
                    else { return .empty() }
                return .just(cell)
            }
        .map { $0.viewModel }
        .flatMap { $0.output.artist }
        .bind(onNext: { [unowned self] in
            input.artistSelected(from: self, artist: $0)
        })
        .disposed(by: self.disposeBag)
        
        topTracksCollectionView.rx.itemSelected
            .flatMap { [weak self] indexPath -> Observable<TrackCollectionCell> in
                guard let cell = self?.topTracksCollectionView.cellForItem(at: indexPath) as? TrackCollectionCell
                    else { return .empty() }
                return .just(cell)
            }
        .map { $0.viewModel }
        .flatMap { $0.output.track }
        .bind(onNext: { [unowned self] in
            input.trackSelected(from: self, track: $0)
        })
        .disposed(by: self.disposeBag)
        
        recentlyPlayedTracksTableView.rx.itemSelected
            .flatMap { [weak self] indexPath -> Observable<RecentlyPlayedCell> in
                guard let cell = self?.recentlyPlayedTracksTableView.cellForRow(at: indexPath) as? RecentlyPlayedCell
                    else { return .empty() }
                self?.recentlyPlayedTracksTableView.deselectRow(at: indexPath, animated: true)
                return .just(cell)
            }
        .map { $0.viewModel }
        .flatMap { $0.output.track }
        .bind(onNext: { [unowned self] in
            input.recentTrackSelected(from: self, track: $0)
        })
            .disposed(by: self.disposeBag)
        
        output.topArtistsCellModelType
            .map { [ArtistsSectionModel(model: "", items: $0)]}
            .bind(to: topArtistsCollectionView.rx.items(dataSource: topArtistsDataSource))
            .disposed(by: disposeBag)
        
        output.topTracksCellModelType
            .map { [TracksSectionModel(model: "", items: $0)]}
            .bind(to: topTracksCollectionView.rx.items(dataSource: topTracksDataSource))
            .disposed(by: disposeBag)
        
        output.recentlyPlayedCellModelType
            .map { [RecentlyPlayedTracksSectionModel(model: "", items: $0)]}
            .bind(to: recentlyPlayedTracksTableView.rx.items(dataSource: recentlyPlayedTracksDataSource))
            .disposed(by: disposeBag)
    }
    
    private var topArtistsCollectionViewDataSource: CollectionViewSectionedDataSource<ArtistsSectionModel>.ConfigureCell {
        return { _, collectionView, indexPath, cellModel in
            var cell: ArtistCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "artistCollectionCell", for: indexPath) as! ArtistCollectionCell
            cell.bind(to: cellModel)
            return cell
        }
    }
    
    private var topTracksCollectionViewDataSource: CollectionViewSectionedDataSource<TracksSectionModel>.ConfigureCell {
        return { _, collectionView, indexPath, cellModel in
            var cell: TrackCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackCollectionCell", for: indexPath) as! TrackCollectionCell
            cell.bind(to: cellModel)
            return cell
        }
    }
    
    private var recentlyPlayedTracksTableViewDataSource:
        RxTableViewSectionedReloadDataSource<RecentlyPlayedTracksSectionModel>.ConfigureCell {
        return { _, tableView, indexPath, cellModel in
            var cell: RecentlyPlayedCell = tableView.dequeueReusableCell(withIdentifier: "recentlyPlayedCell", for: indexPath) as! RecentlyPlayedCell
            cell.bind(to: cellModel)
            return cell
        }
    }
}

private extension UIButton {
    static var topArtistsButton: UIButton {
        let button = UIButton()
        button.setTitle("Your Top Artists", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    static var topTracksButton: UIButton {
        let button = UIButton()
        button.setTitle("Your Top Tracks", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    static var recentlyPlayedButton: UIButton {
        let button = UIButton()
        button.setTitle("Your Recently Played Tracks", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
}

private struct Constraints {
    static let innerMargins = CGFloat(2)
    static let outerMargins = CGFloat(8)
    static let offset = UIScreen.main.bounds.height/4
}
