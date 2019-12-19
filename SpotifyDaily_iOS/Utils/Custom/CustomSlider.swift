//
//  CustomSlider.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/19/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit

class CustomSlider: UISlider {

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 5.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }

}
