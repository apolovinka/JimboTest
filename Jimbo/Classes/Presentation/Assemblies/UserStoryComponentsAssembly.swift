//
//  ComponentsAssembly.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/19/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import Swinject

class UserStoryComponentsAssembly: Assembly {

    func assemble(container: Container) {
        container.register(CellViewModelConfigurator.self) { _ in
            return CellViewModelConfigurator(container: container)
        }.inObjectScope(.container)
    }

}
