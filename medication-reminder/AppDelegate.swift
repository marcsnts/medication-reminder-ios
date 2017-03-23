//
//  AppDelegate.swift
//  medication-reminder
//
//  Created by Vikas Gandhi on 2017-03-17.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import UIKit
import SwiftyJSON
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            
        }
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let takeAction = UNNotificationAction(identifier: "Take", title: "Take", options: [.foreground])
        let category = UNNotificationCategory(identifier: "MedicationReminderCategory",
                                              actions: [snoozeAction, takeAction],
                                              intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
        
        return true
    }
}

