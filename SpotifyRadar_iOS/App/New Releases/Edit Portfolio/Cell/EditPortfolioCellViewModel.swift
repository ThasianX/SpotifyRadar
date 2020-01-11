//
//  EditPortfolioCellViewModel.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/17/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import RxSwift

protocol EditPortfolioCellViewModelInput {}
protocol EditPortfolioCellViewModelOutput {
    var artist: Observable<Artist> { get }
    var dateAdded: Observable<Date> { get }
}
protocol EditPortfolioCellViewModelType {
    var input: EditPortfolioCellViewModelInput { get }
    var output: EditPortfolioCellViewModelOutput { get }
}

class EditPortfolioCellViewModel: EditPortfolioCellViewModelType,
                                EditPortfolioCellViewModelInput,
                                EditPortfolioCellViewModelOutput {

    // MARK: Input & Output
    var input: EditPortfolioCellViewModelInput { return self }
    var output: EditPortfolioCellViewModelOutput { return self }

    // MARK: Output
    let artist: Observable<Artist>
    let dateAdded: Observable<Date>

    // MARK: Init
    init(artist: Artist, dateAdded: Date) {
        self.artist = Observable.just(artist)
        self.dateAdded = Observable.just(dateAdded)
    }
    
    deinit {
        Logger.info("EditPortfolioCellViewModel dellocated")
    }
}
