//
//  ArtistPortfolioState.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/15/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

struct ArtistPortfolioState: Codable, Equatable {
    let artists: Set<Artist>
}
