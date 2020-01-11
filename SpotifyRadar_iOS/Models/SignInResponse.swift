//
//  SignInResponse.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

struct SignInResponse: Codable {
    let accessToken: String?
    var refreshToken: String?
    let expirationDate: Date?
}
