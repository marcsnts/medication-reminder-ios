//
//  HelperFunctions.swift
//  medication-reminder
//
//  Created by Marc Santos on 2017-03-22.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import Foundation

extension Date {
    var iso8601String: String {
        let df = DateFormatter()
        df.timeZone = TimeZone(identifier: "UTC")
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        return df.string(from: self)
    }
}

extension String {
    var iso8601Date: Date? {
        let df = DateFormatter()
        df.timeZone = TimeZone(identifier: "UTC")
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        return df.date(from: self)
    }
}

extension Calendar {
    //Helper function that'll be used for making the HTTP queries
    func toString(date: Date) -> String {
        let day = self.component(.day, from: date)
        let month = self.component(.month, from: date)
        let year = self.component(.year, from: date)
        return "\(month)/\(day)/\(year)"
    }
}
