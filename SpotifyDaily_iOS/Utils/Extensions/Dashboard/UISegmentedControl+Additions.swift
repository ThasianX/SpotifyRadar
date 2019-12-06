//
//  UISegmentedControl+Additions.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/6/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit

private struct Metric {
    static let radius = CGFloat(9)
    static let tintColor = UIColor.black
}

extension UISegmentedControl {
    static var timeRangeControl: UISegmentedControl {
        let items = ["short_term", "medium_term", "long_term"]
        let control = UISegmentedControl(items: items)
        control.layer.cornerRadius = Metric.radius
        control.tintColor = Metric.tintColor
        control.layer.masksToBounds = true
        
        control.translatesAutoresizingMaskIntoConstraints = false
        
        return control
    }
}
