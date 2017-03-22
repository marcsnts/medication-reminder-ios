//
//  HelperFunctions.swift
//  medication-reminder
//
//  Created by Marc Santos on 2017-03-22.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import Foundation

//Schema uses iso8601 for dates
extension Date {
    static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    var iso8601: String {
        return Date.iso8601Formatter.string(from: self)
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Date.iso8601Formatter.date(from: self)
    }
}


//Helper function that'll be used for making the HTTP queries
extension Calendar {
    func toString(date: Date) -> String {
        let day = self.component(.day, from: date)
        let month = self.component(.month, from: date)
        let year = self.component(.year, from: date)
        
        return "\(month)/\(day)/\(year)"
    }
}

