//
//  DataManager.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

protocol DataManager {
    
    func get<T>(key: String, type: T.Type) -> T? where T : Codable
    
    func get(key: String) -> String?
    
    func set<T>(key: String, value: T?) where T : Codable
    
    func remove(key: String)
    
    func clear()
}
