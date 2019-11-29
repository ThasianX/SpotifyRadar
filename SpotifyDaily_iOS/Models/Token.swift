//
//  Token.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

struct Token: Codable, Equatable {
    let accessToken: String
    let refreshToken: String
    let expirationDate: Date
    
    func isValid() -> Bool {
        return Date().compare(expirationDate) == .orderedAscending
    }
}
