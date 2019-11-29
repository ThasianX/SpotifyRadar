//
//  User.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

struct UserModel: Codable, Equatable {
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

