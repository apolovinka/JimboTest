//  
//  TemplatesAssembly.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 3/13/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard
import SwinjectAutoregistration

class TemplatesModuleAssemly: Assembly {

    func assemble(container: Container) {
        container.autoregister(TemplateCellViewModel.self, initializer: TemplateCellViewModel.init)
        container.autoregister(TemplatesDisplayDataManager.self, initializer: TemplatesDisplayDataManager.init)
    }
  
}
