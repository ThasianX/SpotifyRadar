//
//  DashboardViewControllerState.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/2/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

struct ArtistsCollectionViewControllerState: Codable, Equatable {
    let artistsTimeRange: String
    let artistsLimit: Int
}
