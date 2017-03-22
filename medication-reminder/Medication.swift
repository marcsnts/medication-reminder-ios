//
//  Medication.swift
//  medication-reminder
//
//  Created by Marc Santos on 2017-03-21.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import Foundation
import SwiftyJSON

class Medication {
    
    var id: String?
    var name: String?
    var dosage: String?
    var time: Date?
    var completed: Bool?
    
    init(id: String?, name: String?, dosage: String?, time: Date?, completed: Bool?) {
        self.id = id
        self.name = name
        self.dosage = dosage
        self.time = time
        self.completed = completed
    }
    
    //Assumes schema
    init(fromJSON: JSON) {
        self.id = fromJSON["_id"].string
        self.name = fromJSON["name"].string
        self.dosage = fromJSON["dosage"].string
        if let timeString = fromJSON["time"].string {
            self.time = timeString.iso8601Date
        }
        self.completed = fromJSON["completed"].bool
    }
    
}
