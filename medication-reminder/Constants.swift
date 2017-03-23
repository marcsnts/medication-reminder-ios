//
//  Constants.swift
//  medication-reminder
//
//  Created by Marc Santos on 2017-03-22.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import Foundation

class Constants {
    
    static let START_DATE = Date()
    //60*60*24 = 1 day
    static let END_DATE = Date(timeIntervalSinceNow: Double(60*60*24*5))
    
    static let REFRESH_ERROR_MARGIN: Double = 2.00
    
}
