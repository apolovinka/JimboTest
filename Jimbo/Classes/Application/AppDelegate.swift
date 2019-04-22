//
//  AppDelegate.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 3/13/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var applicationScreenLauncher : ApplicationScreenLauncher!
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        ApplicationAssembler.resolve(self)

        // Create "RootViewController" and make a key window visible
        self.applicationScreenLauncher.launch { self.window = $0 }

        return true
    }


}

