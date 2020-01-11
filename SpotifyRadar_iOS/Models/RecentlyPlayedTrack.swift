//
//  RecentlyPlayedTrack.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/8/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

struct RecentlyPlayedTrack: Codable, Equatable {
    let trackName: String
    let albumName: String
    var artistURLs: [URL]
    let duration: String
    let playedAt: String
    let externalURL: URL
}
