//
//  Date+Formatter+Additions.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/9/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}

extension DateFormatter {
    convenience init(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) {
        self.init()
        self.dateStyle = dateStyle
        self.timeStyle = timeStyle
    }
}

extension Formatter {
    static let iso8601 = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
    
    static let mediumDateShortTime = DateFormatter(dateStyle: .medium, timeStyle: .short)
    
    static let mediumDateNoTime = DateFormatter(dateStyle: .medium, timeStyle: .none)
}

extension Date {
    var mediumDateShortTime: String {
        return Formatter.mediumDateShortTime.string(from: self)
    }
    
    var mediumDateNoTime: String {
        return Formatter.mediumDateNoTime.string(from: self)
    }
}

extension String {
    var iso8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
}
