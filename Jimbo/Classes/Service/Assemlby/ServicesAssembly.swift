//
//  ServicesAssembly.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 3/13/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import Swinject
import SwinjectAutoregistration

final class ServicesAssembly : Assembly {

    func assemble(container: Container) {
        container.autoregister(TemplatesService.self, initializer: TemplatesService.init)
    }
}
