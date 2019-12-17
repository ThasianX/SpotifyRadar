//
//  NewTrack.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/16/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

struct NewTrack: Codable, Equatable {
    let trackName: String
    let albumName: String
    let artistNames: [String]
    let duration: String
    let externalURL: URL
}
