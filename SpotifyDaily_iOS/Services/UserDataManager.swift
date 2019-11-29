//
//  UserDataManager.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

class UserDataManager: DataManager {
    private var data: [String:String]
    
    init() {
        self.data = UserDefaults.standard
            .data(forKey: "data")?
            .toObject([String:String].self) ?? [:]
        
        Logger.info("Loaded user data: \(self.data.count) keys")
    }
    
    func get<T>(key: String, type: T.Type) -> T? where T : Codable {
        let result = self.data[key]?.data(using: .utf8)?.toObject(type)
        return result
    }
    
    func get(key: String) -> String? {
        return self.data[key]
    }
    
    func set<T>(key: String, value: T?) where T : Codable {
        if let json = value?.toJson() {
            self.data[key] = String(data: json, encoding: .utf8)
            self.synchronize()
        }
    }
    
    func remove(key: String) {
        self.data.removeValue(forKey: key)
        self.synchronize()
    }
    
    func clear() {
        self.data.removeAll()
        self.synchronize()
        SpotifyLogin.shared.logout()
    }
    
    private func synchronize() {
        UserDefaults.standard.set(self.data.toJson(), forKey: "data")
    }
}
