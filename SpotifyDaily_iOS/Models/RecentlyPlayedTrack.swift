//
//  RecentlyPlayedTrack.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/8/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

struct RecentlyPlayedTrack: Codable, Equatable {
    let name: String
    let duration: String
    let context: String
    let externalURL: URL
}
