//
//  UIFont+Helvetica.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/11/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    enum HelveticaNueStyle: String {
        case italic
        case bold
        case ultralight
        case condensedblack
        case bolditalic
        case condensedbold
        case light
        case thin
        case thinitalic
        case lightitalic
        case ultralightitalic
        case mediumitalic
        case regular

        var fontName: String {
            return "HelveticaNeue-\(self.rawValue.capitalized)"
        }
    }

    convenience init(helveticaStyle: HelveticaNueStyle, size: CGFloat) {
        self.init(name: helveticaStyle.fontName, size: size)!
    }
}
