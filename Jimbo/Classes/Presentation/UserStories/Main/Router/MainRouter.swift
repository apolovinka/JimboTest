//  
//  MainRouter.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/23/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import LightRoute

class MainRouter {

    weak var transitionHandler: TransitionHandler!

    let detailSegueIdentifier = "Detail"

    func openDetail(with identifier: String, output: DetailModuleOutput) {
       try? self.transitionHandler.forSegue(identifier: self.detailSegueIdentifier, to: DetailModuleInput.self)
        .then{ input in
            input.configure(identifier: identifier, output: output)
        }
    }
}
