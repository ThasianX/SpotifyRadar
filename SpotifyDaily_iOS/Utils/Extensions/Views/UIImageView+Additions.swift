//
//  UIImageView+Additions.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/27/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

extension UIImageView {
    func load(url: URL, targetSize: CGSize) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image.resize(targetSize: targetSize)
                    }
                }
            }
        }
    }
    
    func dim(withAlpha alpha: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            let coverLayer = CALayer()
            coverLayer.frame = self.bounds
            coverLayer.backgroundColor = UIColor.black.cgColor
            coverLayer.opacity = Float(alpha)
            self.layer.addSublayer(coverLayer)
        }
    }
}
