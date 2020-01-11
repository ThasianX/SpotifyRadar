//
//  UITableView+Configuration.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/14/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    static var defaultTableView: UITableView {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = ColorPreference.tertiaryColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }
}
