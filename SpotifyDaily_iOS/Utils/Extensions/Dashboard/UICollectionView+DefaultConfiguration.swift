//
//  UICollectionView+DefaultConfiguration.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/11/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    static var defaultCollectionView: UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout

        let spacing = (1 / UIScreen.main.scale) + 16
        let cellWidth = (UIScreen.main.bounds.width / 2) - spacing

        flowLayout!.itemSize = CGSize(width: cellWidth, height: cellWidth)
        flowLayout!.sectionInset = UIEdgeInsets(top: 16.0, left: 8.0, bottom: 0, right: 8.0)
        flowLayout!.minimumLineSpacing = spacing

        return collectionView
    }
}
