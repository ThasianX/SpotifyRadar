//
//  String+Localization.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return LocalizationUtils.localize(key: self)
    }
    
    var localizedUpper: String {
        return LocalizationUtils.localize(key: self).uppercased()
    }
}
