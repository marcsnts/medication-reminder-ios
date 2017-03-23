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
        let calendar = Calendar.current
        self.year = calendar.component(.year, from: fromDate)
        self.month = calendar.component(.month, from: fromDate)
        self.day = calendar.component(.day, from: fromDate)
    }

    func toString() -> String {
        return "\(self.year)/\(self.month)/\(self.day)"
    }
}
