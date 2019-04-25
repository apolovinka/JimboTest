//  
//  MainAssembly.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/23/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

class MainModuleAssemly: TemplatesModuleAssemly {

    override func assemble(container: Container) {

        container.register(MainRouter.self) { (r, viewController: MainViewController) in
            let router = MainRouter()
            router.transitionHandler = viewController
            return router
        }

        container.register(MainViewModel.self) { (r, viewController: MainViewController) in
            let viewModel = MainViewModel()
            viewModel.router = r.resolve(MainRouter.self, argument: viewController)
            viewModel.templatesService = r.resolve(TemplatesService.self)
            return viewModel
        }

        container.storyboardInitCompleted(MainViewController.self) {
            r, viewController in
            viewController.viewModel = r.resolve(MainViewModel.self, argument: viewController)
            viewController.displayDataManager = r.resolve(TemplatesDisplayDataManager.self)
            viewController.moduleOutput = viewController.viewModel
        }
    }
  
}
