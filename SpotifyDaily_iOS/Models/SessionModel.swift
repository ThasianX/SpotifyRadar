//
//  Session.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

struct SessionModel: Codable, Equatable {
    private(set) var token: Token
    private(set) var user: UserModel
    
    mutating func updateDetails(_ user: UserModel) {
        self.user = user
    }
}
