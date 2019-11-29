//
//  UIImage+Additions.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/27/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
}
