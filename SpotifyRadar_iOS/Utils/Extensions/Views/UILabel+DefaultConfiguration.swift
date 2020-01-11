//
//  UILabel+Additions.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/6/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit

private struct Metric {
    static let modalTitleFont = UIFont.systemFont(ofSize: 20, weight: .bold)
}

extension UILabel {
    static var modalTitle: UILabel {
        let label = UILabel()
        label.font = Metric.modalTitleFont
        label.textColor = ColorPreference.mainColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
}
