//
//  Configuration.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/1/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

struct Configuration {
    let clientID: String
    let clientSecret: String
    let redirectURL: URL
    
    init(){
        self.clientID = ""
        self.clientSecret = ""
        self.redirectURL = URL(string: "spotify-radar-login://")!
    }
}
