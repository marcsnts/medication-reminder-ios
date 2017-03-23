//
//  Medication.swift
//  medication-reminder
//
//  Created by Marc Santos on 2017-03-21.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import Foundation
import SwiftyJSON
import UserNotifications

class Medication {
    var id: String?
    var name: String?
    var dosage: String?
    var time: Date?
    var completed: Bool?
    var takeable: Bool
    var missed: Bool
    
    init(id: String?, name: String?, dosage: String?, time: Date?, completed: Bool?, missed: Bool) {
        self.id = id
        self.name = name
        self.dosage = dosage
        self.time = time
        self.completed = completed
        self.takeable = false
        self.missed = false
        //if current time exceeds the medication time + 5 mins, then missed
        if let time = time {
            if Date() > time.addingTimeInterval(Double(60*5.1)) {
                self.missed = true
            }
        }
    }
    //Assumes schema
    init(fromJSON: JSON) {
        self.missed = false
        self.id = fromJSON["_id"].string
        self.name = fromJSON["name"].string
        self.dosage = fromJSON["dosage"].string
        if let timeString = fromJSON["time"].string {
            self.time = timeString.iso8601Date
            //if current time exceeds the medication time + 5 mins, then missed
            if let time = self.time {
                if Date() > time.addingTimeInterval(Double(60*5.1)) {
                    self.missed = true
                }
            }
        }
        self.completed = fromJSON["completed"].bool
        self.takeable = false
    }
    func createLocalNotification() {
        guard let name = self.name, let dosage = self.dosage, let time = self.time, let id = self.id else {
            return
        }
        let content = UNMutableNotificationContent()
        content.title = "Medication time!"
        content.body = "\(dosage) \(name)"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "MedicationReminderCategory"
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
                print(error)
            }
        })
    }
}
