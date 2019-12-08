//
//  TopTracksViewControllerState.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/7/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

struct TopTracksViewControllerState: Codable, Equatable {
    let tracksTimeRange: String
    let tracksLimit: Int
}
