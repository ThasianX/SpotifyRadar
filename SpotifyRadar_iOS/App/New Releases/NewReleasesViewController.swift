//
//  NewTracksViewController.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/16/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class NewReleasesViewController: ViewControllerWithSideMenu, BindableType {
    
    // MARK: - Properties
    // MARK: Section model
    typealias TracksSectionModel = SectionModel<String, NewTracksCellViewModelType>
    
    // MARK: Viewmodel
    var viewModel: NewReleasesViewModelType!
    
    // MARK: View components
    private lazy var tableView = UITableView.defaultTableView
    private lazy var emptyLabel = UILabel.emptyLabel
    private lazy var sliderTimeRange = UILabel.sliderTimeRangeLabel
    private lazy var newReleasesSlider = UISlider.newReleasesSlider
    private var editPortfolio: UIBarButtonItem!
    
    // MARK: Private
    private var dataSource: RxTableViewSectionedReloadDataSource<TracksSectionModel>!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        setUpView()
        createTickView()
    }
    
    deinit {
        Logger.info("NewReleasesViewController dellocated")
    }
    
    private func setUpView() {
        self.view.backgroundColor = ColorPreference.secondaryColor
        self.view.addSubview(tableView)
        self.view.addSubview(emptyLabel)
        self.view.addSubview(sliderTimeRange)
        self.view.addSubview(newReleasesSlider)
        
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        sliderTimeRange.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: Constraints.outerMargins).isActive = true
        sliderTimeRange.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        sliderTimeRange.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        sliderTimeRange.heightAnchor.constraint(equalToConstant: Constraints.height).isActive = true
        
        newReleasesSlider.topAnchor.constraint(equalTo: sliderTimeRange.bottomAnchor, constant: Constraints.outerMargins).isActive = true
        newReleasesSlider.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: Constraints.outerMargins).isActive = true
        newReleasesSlider.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -Constraints.outerMargins).isActive = true
        newReleasesSlider.heightAnchor.constraint(equalToConstant: Constraints.height).isActive = true
        
        // adds target to method snap functionality on the newReleasesSlider UISlider
        newReleasesSlider.addTarget(self, action: #selector(sliderChanged), for: .touchUpInside)
        newReleasesSlider.isContinuous = false
        
        tableView.topAnchor.constraint(equalTo: newReleasesSlider.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        emptyLabel.topAnchor.constraint(equalTo: newReleasesSlider.bottomAnchor).isActive = true
        emptyLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: Constraints.outerMargins).isActive = true
        emptyLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -Constraints.outerMargins).isActive = true
        emptyLabel.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
    }
    
    private func configureNavigationBar() {
        self.title = "New Releases"
        
        if #available(iOS 13.0, *) {
            editPortfolio = UIBarButtonItem(image: UIImage(systemName: "archivebox"), style: .plain, target: self, action: nil)
        } else {
            editPortfolio = UIBarButtonItem(title: "Edit Portfolio", style: .plain, target: self, action: nil)
        }
        
        self.navigationItem.rightBarButtonItem = editPortfolio
    }

    private func configureTableView() {
        tableView.register(NewTrackCell.self, forCellReuseIdentifier: "newTrackCell")
        dataSource = RxTableViewSectionedReloadDataSource<TracksSectionModel>(
            configureCell:  tableViewDataSource
        )
    }
    
    // creates the tick mark view and inserts it on top of the newReleasesSlider UISlider
    private func createTickView() {
        var tick : UIView
        let tickArray = Array(1...12)
        for i in 0..<tickArray.count {
            tick = UIView(frame: CGRect(x: (newReleasesSlider.frame.size.width / 3) * CGFloat(i), y: (newReleasesSlider.frame.size.height - 13) / 2, width: 2, height: 13))
            tick.backgroundColor = ColorPreference.tertiaryColor
            newReleasesSlider.insertSubview(tick, belowSubview: newReleasesSlider)
        }
    }
    
    // provides the snap functionality on the newReleasesSlider UISlider
    @objc func sliderChanged(){
        let step:Float = 1
        let roundedStepValue = round(newReleasesSlider.value / step) * step
        newReleasesSlider.value = roundedStepValue
    }
    
    func bindViewModel() {
        let input = viewModel.input
        let output = viewModel.output
        
        output.newTracksCellModelType
            .map {
                [TracksSectionModel(model: "New Releases", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        Observable.combineLatest(output.emptyPortfolio, output.emptyTracks)
            .bind(onNext: { [unowned self] emptyPortfolio, emptyTracks in
                if emptyPortfolio {
                    self.tableView.isHidden = true
                    self.emptyLabel.isHidden = false
                    self.emptyLabel.text = "Add artists to your portfolio to see new releases"
                } else if emptyTracks {
                    self.tableView.isHidden = true
                    self.emptyLabel.isHidden = false
                    self.emptyLabel.text = "No new releases"
                } else {
                    self.tableView.isHidden = false
                    self.emptyLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .flatMap { [weak self] indexPath -> Observable<NewTrackCell> in
                guard let cell = self?.tableView.cellForRow(at: indexPath) as? NewTrackCell
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
        
        editPortfolio.rx.tap
            .bind(to: input.presentPortfolio)
        .disposed(by: disposeBag)
        
        newReleasesSlider.value = input.sliderValue.value
        
        newReleasesSlider.rx.value
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(onNext: { [unowned self] value in
                // value.rounded() makes sure sliderTimeRange.text is accurate after thumbnail snaps to closest Int
                self.sliderTimeRange.text = "New releases within the past \(Int(value.rounded())) months"
                input.sliderValue.accept(value)
            })
        .disposed(by: disposeBag)
    }

    private var tableViewDataSource:
        RxTableViewSectionedReloadDataSource<TracksSectionModel>.ConfigureCell {
        return { _, tableView, indexPath, cellModel in
            var cell: NewTrackCell = tableView.dequeueReusableCell(withIdentifier: "newTrackCell", for: indexPath) as! NewTrackCell
            cell.bind(to: cellModel)
            return cell
        }
    }
}

private struct Constraints {
    static let outerMargins = CGFloat(16)
    static let height = CGFloat(30)
}

private extension UILabel {
    static var emptyLabel: UILabel {
        let label = UILabel()
        label.font = UIFont.init(helveticaStyle: .bold, size: 40)
        label.textColor = ColorPreference.tertiaryColor
        label.backgroundColor = ColorPreference.secondaryColor
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    static var sliderTimeRangeLabel: UILabel {
        let label = UILabel()
        label.font = UIFont.init(helveticaStyle: .bold, size: 15)
        label.textColor = ColorPreference.tertiaryColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
}

private extension UISlider {
    static var newReleasesSlider: UISlider {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 12
        slider.minimumTrackTintColor = UIColor(hexString: "#4CAF50")
        slider.maximumTrackTintColor = ColorPreference.tertiaryColor
        
        let thumbImage = UIImage(named: "spotify_thumb_image")?.resize(targetSize: CGSize(width: 30, height: 30))
        slider.setThumbImage(thumbImage, for: .normal)
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        return slider
    }
}
