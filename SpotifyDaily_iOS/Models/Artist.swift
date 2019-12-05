//
//  Artist.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/2/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

struct Artist: Codable, Equatable {
    let name: String
    let image: URL
    let followers: Int
    let externalURL: URL
}
