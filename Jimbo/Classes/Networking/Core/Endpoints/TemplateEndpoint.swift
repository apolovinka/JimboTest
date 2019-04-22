//
//  TemplateEndpoint.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/17/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation

enum TemplateEndpoint: EndpointProtocol {

    case template(identifier: String, urlPath: String)

    var path: String {
        switch self {
        case .template(identifier: _, urlPath: let path):
            return path
        }
    }

    var method: NetworkingRequestMethod {
        return NetworkingRequestMethod.get
    }

    var parameters: [String : Any]?  {
        return nil
    }

    var headers: [String : String]? {
        return ["Accept" : "application/json"]
    }

    var parser: ParserProtocol? {
        switch self {
        case .template(identifier: let identifier, urlPath: _):
            return TemplateParser(identifier: identifier)
        }
    }
}
