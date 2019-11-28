//
//  Logger.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/28/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

class Logger {
    enum LogLevel: Int {
        case none
        case error
        case info
        case debug
    }
    
    static var logLevel = LogLevel.debug
    
    static func debug(_ message: String) {
        guard logLevel.rawValue >= LogLevel.debug.rawValue else { return }
        log("\(getDate()) | DEBUG | \(message)")
    }
    
    static func info(_ message: String) {
        guard logLevel.rawValue >= LogLevel.info.rawValue else { return }
        log("\(getDate()) | INFO | \(message)")
    }
    
    static func error(_ message: String) {
        guard logLevel.rawValue >= LogLevel.error.rawValue else { return }
        log("\(getDate()) | ERROR | \(message)")
    }
    
    static func error(_ message: String, error: Error?) {
        guard logLevel.rawValue >= LogLevel.error.rawValue else { return }
        if error != nil {
            log("\(getDate()) | ERROR | \(message)\n\(error!)")
        } else {
            log("\(getDate()) | ERROR | \(message)")
        }
    }
    
    private static func log(_ message: String) {
        #if DEBUG
        print(message)
        #endif
    }
    
    private static func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }
}
