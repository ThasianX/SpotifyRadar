//
//  Encodable+Json.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

extension Encodable {
    func toJson() -> Data? {
        return try? Json.encoder.encode(self)
    }
}
