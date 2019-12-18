//
//  Album.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/18/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

struct Album: Codable, Equatable {
    let albumName: String
    let albumId: String
    let href: String
    let releaseDate: Date
    let externalURL: URL
}
