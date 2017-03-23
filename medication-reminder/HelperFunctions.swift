//
//  HelperFunctions.swift
//  medication-reminder
//
//  Created by Marc Santos on 2017-03-22.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import Foundation

extension Date {
    func isWithinFiveMinutes(otherDate: Date) -> Bool {
        let fiveMins:Double = 60*5
        
        if self.addingTimeInterval(fiveMins) >= otherDate && self.addingTimeInterval(-1.00*fiveMins) <= otherDate {
            return true
        }
        
        return false
    }
        
    var iso8601String: String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        return df.string(from: self)
    }
    
}

extension String {

    var iso8601Date: Date? {
        let df = DateFormatter()
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

