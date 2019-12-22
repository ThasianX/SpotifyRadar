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
}

extension UISegmentedControl {
    static var timeRangeControl: UISegmentedControl {
        let items = ["short_term", "medium_term", "long_term"]
        let control = UISegmentedControl(items: items)
        control.layer.cornerRadius = Metric.radius
        control.tintColor = ColorPreference.mainColor
        control.layer.masksToBounds = true
        
        var titleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorPreference.tertiaryColor]
        control.setTitleTextAttributes(titleTextAttributes, for: .normal)
        titleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorPreference.mainColor]
        control.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        control.translatesAutoresizingMaskIntoConstraints = false
        
        return control
    }
}
