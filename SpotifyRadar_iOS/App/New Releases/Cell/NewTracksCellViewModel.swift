//
//  NewTracksCell.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/16/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import RxSwift

protocol NewTracksCellViewModelInput {}
protocol NewTracksCellViewModelOutput {
    var track: Observable<NewTrack> { get }
}
protocol NewTracksCellViewModelType {
    var input: NewTracksCellViewModelInput { get }
    var output: NewTracksCellViewModelOutput { get }
}

class NewTracksCellViewModel: NewTracksCellViewModelType,
                                NewTracksCellViewModelInput,
                                NewTracksCellViewModelOutput {

    // MARK: Input & Output
    var input: NewTracksCellViewModelInput { return self }
    var output: NewTracksCellViewModelOutput { return self }

    // MARK: Output
    let track: Observable<NewTrack>

    // MARK: Init
    init(track: NewTrack) {
        self.track = Observable.just(track)
    }
    
    deinit {
        Logger.info("NewTracksCellViewModel dellocated")
    }
}
