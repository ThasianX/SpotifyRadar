//
//  RecentlyPlayedTableViewCellViewModel.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/9/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import RxSwift

protocol RecentlyPlayedCellViewModelInput {}
protocol RecentlyPlayedCellViewModelOutput {
    var track: Observable<RecentlyPlayedTrack> { get }
}
protocol RecentlyPlayedCellViewModelType {
    var input: RecentlyPlayedCellViewModelInput { get }
    var output: RecentlyPlayedCellViewModelOutput { get }
}

class RecentlyPlayedCellViewModel: RecentlyPlayedCellViewModelType,
                                RecentlyPlayedCellViewModelInput,
                                RecentlyPlayedCellViewModelOutput {

    // MARK: Input & Output
    var input: RecentlyPlayedCellViewModelInput { return self }
    var output: RecentlyPlayedCellViewModelOutput { return self }

    // MARK: Output
    let track: Observable<RecentlyPlayedTrack>

    // MARK: Init
    init(track: RecentlyPlayedTrack) {
        self.track = Observable.just(track)
    }
    
    deinit {
        Logger.info("RecentlyPlayedCellViewModel dellocated")
    }
}
