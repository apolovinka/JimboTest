//
//  ApplicationComponentsAssembly.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 3/13/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard
import SwinjectAutoregistration

final class ApplicationComponentsAssembly : Assembly {

    func assemble(container: Container) {        

        // Application Screen Launcher
        container.register(ApplicationScreenLauncher.self, factory: {
            _ in
            SwinjectStoryboard.defaultContainer = container
            return ApplicationScreenLauncher(storyboard: SwinjectStoryboard.create(name: StoryboardType.main.name, bundle: nil))
        })

    }

}
