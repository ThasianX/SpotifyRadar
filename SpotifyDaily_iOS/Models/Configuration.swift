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
        self.clientID = "8cece41fa2cc49a48e66b70cbc7789fc"
        self.clientSecret = "89faaf509a5e49569abb3fc93ebe4740"
        self.redirectURL = URL(string: "spotify-daily-login://")!
    }
}
