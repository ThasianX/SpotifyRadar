//
//  SearchArtistCellViewModel.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/14/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchArtistCellViewModelInput {}
protocol SearchArtistCellViewModelOutput {
    var artist: Observable<Artist> { get }
    var inPortfolio: Observable<Bool> { get }
}
protocol SearchArtistCellViewModelType {
    var input: SearchArtistCellViewModelInput { get }
    var output: SearchArtistCellViewModelOutput { get }
}

class SearchArtistCellViewModel: SearchArtistCellViewModelType,
                                SearchArtistCellViewModelInput,
                                SearchArtistCellViewModelOutput {

    // MARK: Input & Output
    var input: SearchArtistCellViewModelInput { return self }
    var output: SearchArtistCellViewModelOutput { return self }

    // MARK: Output
    let artist: Observable<Artist>
    let inPortfolio: Observable<Bool>

    // MARK: Init
    init(artist: Artist, inPortfolio: Bool) {
        self.artist = Observable.just(artist)
        self.inPortfolio = Observable.just(inPortfolio)
    }
    
    deinit {
        Logger.info("SearchArtistCellViewModel dellocated")
    }
}
