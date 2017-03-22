//
//  CustomDate.swift
//  medication-reminder
//
//  Created by Marc Santos on 2017-03-22.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import Foundation

//Equatable protocol
func ==(lhs: CustomDate, rhs: CustomDate) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

class CustomDate: Hashable {
    
    var year: Int
    var month: Int
    var day: Int
    
    var hashValue: Int {
        get {
            return "\(self.year)/\(self.month)/\(self.day)".hashValue
        }
    }
    
    init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }
    
    init(fromDate: Date) {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        self.year = calendar.component(.year, from: fromDate)
        self.month = calendar.component(.month, from: fromDate)
        self.day = calendar.component(.day, from: fromDate)
    }
    
}

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
