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

        container.register(TemplatesRouter.self) { (r, viewController: TemplatesViewController) in
            let router = TemplatesRouter()
            router.transitionHandler = viewController
            return router
        }

        container.register(TemplatesViewModel.self) { (r, viewController: TemplatesViewController) in
            let viewModel = TemplatesViewModel()
            viewModel.router = r.resolve(TemplatesRouter.self, argument: viewController)
            viewModel.templatesService = r.resolve(TemplatesService.self)
            return viewModel
        }

        container.storyboardInitCompleted(TemplatesViewController.self) {
            r, viewController in
            viewController.viewModel = r.resolve(TemplatesViewModel.self, argument: viewController)
            viewController.displayDataManager = r.resolve(TemplatesDisplayDataManager.self)
            viewController.moduleOutput = viewController.viewModel
        }

        container.autoregister(TemplateCellViewModel.self, initializer: TemplateCellViewModel.init)
        container.autoregister(TemplatesDisplayDataManager.self, initializer: TemplatesDisplayDataManager.init)
    }
  
}
