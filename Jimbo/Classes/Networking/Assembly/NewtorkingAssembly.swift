//
//  NewtorkingAssembly.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 3/13/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import Swinject


final class NewtorkingAssembly : Assembly {

    func assemble(container: Container) {
        container.register(NetworkingClient.self) { _ in

            let url = URL(string: Configurations.Networking.baseURL)!
            let loggingEnabled = Configurations.Networking.loggingEnabled
            return APINetworkingClient(baseURL: url, loggingEnabled: loggingEnabled)

        }.inObjectScope(.container)
    }

}
