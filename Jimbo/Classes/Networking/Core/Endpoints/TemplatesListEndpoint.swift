//
//  RoomsEndpoint.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 2/13/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation

enum TemplatesListEndpoint: EndpointProtocol {

    case templatesList

    var path: String {
        switch self {
        case .templatesList:
            return "api/published_designs"
        }
    }

    var method: NetworkingRequestMethod {
        return NetworkingRequestMethod.get
    }

    var parameters: [String : Any]? {
        return nil
    }

    var parser: ParserProtocol? {
        switch self {
        case .templatesList:
            return TemplatesListParser(baseURL: Configurations.Networking.baseURL)
        }
    }
}
