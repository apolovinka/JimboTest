//
//  UserStoryModulesProvider.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 3/13/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import Swinject

final class UserStoryAssembliesProvider {

    class func assemblies() -> [Assembly] {
        return [
            UserStoryComponentsAssembly(),
            TemplatesModuleAssemly(),
        ]
    }

}
