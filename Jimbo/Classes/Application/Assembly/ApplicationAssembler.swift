//
//  ApplicationAssembly.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 2/12/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

final class ApplicationAssembler {

    static var assembler: Assembler {

        Container.loggingFunction = nil

        let assembler = Assembler()

        /// Setup assemblies of layered arhictecture
        assembler.apply(assemblies: [

            ApplicationComponentsAssembly(),
            ServicesAssembly(),
            CoreAssembly(),
            NewtorkingAssembly(),

            ])

        /// Setup assemblies of user stories
        assembler.apply(assemblies:
            UserStoryAssembliesProvider.assemblies()
        )

        return assembler
    }

    /// Initial setup of DI container
    /// Should be called directy in Application Delegate
    class func resolve(_ applicationDelegate: AppDelegate) {
        applicationDelegate.applicationScreenLauncher = self.assembler.resolver.resolve(ApplicationScreenLauncher.self)
    }
}
