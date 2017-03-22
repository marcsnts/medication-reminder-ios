//
//  AppDelegate.swift
//  medication-reminder
//
//  Created by Vikas Gandhi on 2017-03-17.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import UIKit
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let date1 = CustomDate(year: 2017, month: 1, day: 1)
        let date2 = CustomDate(year: 2017, month: 1, day: 1)
        let date3 = CustomDate(year: 2017, month: 3, day: 1)

        return true
    }
}

