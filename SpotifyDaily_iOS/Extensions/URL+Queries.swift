//
//  URL+Queries.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/2/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

extension URL {
    /// Returns a new URL by adding the query items. Requires that the calling URL be valid.
    private func appending(_ queryItems: [URLQueryItem]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
        return urlComponents.url!
    }
    
    mutating func appending(_ queryItems: [URLQueryItem]) {
        self = appending(queryItems)
    }
}
