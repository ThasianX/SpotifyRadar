//
//  UIImageView+Additions.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/27/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image.resize(targetSize: CGSize(width: 200, height: 200))
                    }
                }
            }
        }
    }
}
