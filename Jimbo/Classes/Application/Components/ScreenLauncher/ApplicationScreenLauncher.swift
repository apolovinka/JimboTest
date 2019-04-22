//
//  ApplicationScreensLauncher.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 2/13/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import UIKit

class ApplicationScreenLauncher {

    let storyboard: UIStoryboard!
    var window: UIWindow?

    init(storyboard: UIStoryboard) {
        self.storyboard = storyboard
    }

    func launch(completion:(UIWindow?)->()) {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window

        window.rootViewController = self.storyboard.instantiateInitialViewController()

        completion(window)
    }

}
