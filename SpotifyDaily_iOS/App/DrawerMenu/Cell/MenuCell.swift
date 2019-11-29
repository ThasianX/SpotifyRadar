//
//  MenuCell.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit

final class MenuCell: UITableViewCell {
    let titleLabel = UILabel.titleLabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(titleLabel)
        
        self.titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

private extension UILabel {
    static var titleLabel: UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
}
