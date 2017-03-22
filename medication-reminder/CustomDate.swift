//
//  CustomDate.swift
//  medication-reminder
//
//  Created by Marc Santos on 2017-03-22.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import Foundation

class CustomDate {
    
    var year: Int
    var month: Int
    var day: Int
    
    init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }
    
    func isEqualTo(_ date2: CustomDate) -> Bool {
        return date2.day == self.day && date2.month == self.month && date2.year == self.year
    }
    
}
