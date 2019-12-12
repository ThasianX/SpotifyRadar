//
//  CollectionCellViewModel.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/4/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//
import Foundation
import RxSwift

protocol ArtistCollectionCellViewModelInput {}
protocol ArtistCollectionCellViewModelOutput {
    var artist: Observable<Artist> { get }
}
protocol ArtistCollectionCellViewModelType {
    var input: ArtistCollectionCellViewModelInput { get }
    var output: ArtistCollectionCellViewModelOutput { get }
}

class ArtistCollectionCellViewModel: ArtistCollectionCellViewModelType,
                                ArtistCollectionCellViewModelInput,
                                ArtistCollectionCellViewModelOutput {

    // MARK: Input & Output
    var input: ArtistCollectionCellViewModelInput { return self }
    var output: ArtistCollectionCellViewModelOutput { return self }

    // MARK: Output
    let artist: Observable<Artist>

    // MARK: Init
    init(artist: Artist) {
        self.artist = Observable.just(artist)
    }
    
    deinit {
        Logger.info("ArtistCollectionCellViewModel dellocated")
    }
}
