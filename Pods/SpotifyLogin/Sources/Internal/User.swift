//
//  User.swift
//  SpotifyLogin
//
//  Created by Kevin Li on 11/26/19.
//

import Foundation

internal struct User: Codable {
    let country: String
    let displayName: String
    let email: String
    let filterEnabled: Bool
    let profileUrl: String
    let numberOfFollowers: Int
    let endpointUrl: String
    let id: String
    let avatarUrl: String
    let subscriptionLevel: String
    let uriUrl: String
}
