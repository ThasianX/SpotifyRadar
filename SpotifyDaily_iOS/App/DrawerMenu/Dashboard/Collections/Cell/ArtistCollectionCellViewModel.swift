//
//  CollectionCellViewModel.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/4/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//
import Foundation
import RxSwift

protocol CollectionCellViewModelInput {}
protocol CollectionCellViewModelOutput {
    var artist: Observable<Artist> { get }
}
protocol CollectionCellViewModelType {
    var input: CollectionCellViewModelInput { get }
    var output: CollectionCellViewModelOutput { get }
}

class ArtistCollectionCellViewModel: CollectionCellViewModelType,
                                CollectionCellViewModelInput,
                                CollectionCellViewModelOutput {

    // MARK: Input & Output
    var input: CollectionCellViewModelInput { return self }
    var output: CollectionCellViewModelOutput { return self }

    // MARK: Output
    let artist: Observable<Artist>

    // MARK: Init
    init(artist: Artist) {
        self.artist = Observable.just(artist)
    }
}
