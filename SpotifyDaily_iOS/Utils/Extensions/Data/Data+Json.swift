//
//  Data+Json.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

extension Data {
    func toObject<T:Codable>(_ type: T.Type) -> T? {
        return try? Json.decoder.decode(type, from: self)
    }
    
    func printJSON()
    {
        if let JSONString = String(data: self, encoding: String.Encoding.utf8)
        {
            print(JSONString)
        }
    }
}
