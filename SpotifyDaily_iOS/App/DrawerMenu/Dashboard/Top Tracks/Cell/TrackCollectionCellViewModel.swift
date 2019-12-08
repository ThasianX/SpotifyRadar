//
//  TopTracksCollectionCell.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/7/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import RxSwift

protocol TrackCollectionCellViewModelInput {}
protocol TrackCollectionCellViewModelOutput {
    var track: Observable<Track> { get }
}
protocol TrackCollectionCellViewModelType {
    var input: TrackCollectionCellViewModelInput { get }
    var output: TrackCollectionCellViewModelOutput { get }
}

class TrackCollectionCellViewModel: TrackCollectionCellViewModelType,
                                TrackCollectionCellViewModelInput,
                                TrackCollectionCellViewModelOutput {

    // MARK: Input & Output
    var input: TrackCollectionCellViewModelInput { return self }
    var output: TrackCollectionCellViewModelOutput { return self }

    // MARK: Output
    let track: Observable<Track>

    // MARK: Init
    init(track: Track) {
        self.track = Observable.just(track)
    }
}
