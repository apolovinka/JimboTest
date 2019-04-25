//  
//  DetailRouter.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/23/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import LightRoute

class DetailRouter {

    weak var transitionHandler: TransitionHandler!

    func close() {
        try? self.transitionHandler.closeCurrentModule().perform()
    }
}
