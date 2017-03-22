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
        let swag = ["lol", "lol"]
        let daySeconds = 60*60*24
        
        let startDate = Date(timeIntervalSinceNow: Double(-1 * daySeconds * 18))
        let endDate = Date()
        NetworkRequest.getMedications(startDate: startDate, endDate: endDate, successHandler: { (json) -> Void in
            print(json)
            print("howdy partner")
        })
        return true
    }
}

