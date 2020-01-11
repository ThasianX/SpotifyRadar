//
//  ArtistPortfolioState.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/15/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

struct UserPortfolioState: Codable, Equatable {
    let artists: [Artist]
    let dates: [Date]
}
