//
//  NetworkingRequest.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 2/12/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingRequest: URLRequestConvertible {

    let endpoint: EndpointProtocol
    let baseURL: URL

    init(endpoint: EndpointProtocol, baseURL: URL) {
        self.endpoint = endpoint
        self.baseURL = baseURL
    }

    func buildPath () -> String{
        if self.endpoint.basePath != "" {
            return "\(self.endpoint.basePath)/\(self.endpoint.path)"
        }
        return self.endpoint.path
    }

    func asURLRequest() throws -> URLRequest {
        let url = self.baseURL
        var urlRequest = URLRequest(url: url.appendingPathComponent(self.buildPath()))
        urlRequest.httpMethod = self.endpoint.method.rawValue
        urlRequest.allHTTPHeaderFields = self.endpoint.headers
        return try JSONEncoding.default.encode(urlRequest, with: self.endpoint.parameters)
    }

}
