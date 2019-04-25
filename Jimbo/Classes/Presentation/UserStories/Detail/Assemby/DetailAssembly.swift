//  
//  DetailAssembly.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/23/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

class DetailModuleAssemly: Assembly {

    func assemble(container: Container) {

        container.register(DetailRouter.self) { (r, viewController: DetailViewController) in
            let router = DetailRouter()
            router.transitionHandler = viewController
            return router
        }

        container.register(DetailViewModel.self) { (r, viewController: DetailViewController) in
            let viewModel = DetailViewModel()
            viewModel.router = r.resolve(DetailRouter.self, argument: viewController)
            viewModel.templatesService = r.resolve(TemplatesService.self)
            return viewModel
        }

        container.storyboardInitCompleted(DetailViewController.self) {
            r, viewController in
            viewController.viewModel = r.resolve(DetailViewModel.self, argument: viewController)
            viewController.displayDataManager = r.resolve(TemplatesDisplayDataManager.self)
            viewController.moduleOutput = viewController.viewModel
        }
    }
  
}
