//
//  Track.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/7/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

struct Track: Codable, Equatable {
    let name: String
    let id: String
    let duration: String
    let artists: String
    let albumImage: URL
    let externalURL: URL
}
