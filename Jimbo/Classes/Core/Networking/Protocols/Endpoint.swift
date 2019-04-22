//
//  EndpointProtocol.swift
//  Location Viewing
//
//  Created by Alexander Polovinka on 11/18/16.
//  Copyright © 2017 Alexander Polovinka. All rights reserved.
//

protocol EndpointProtocol {
    var basePath : String { get }
    var method : NetworkingRequestMethod { get }
    var path : String { get }
    var parameters : [String : Any]? { get }
    var queryParameters : [String : Any]? { get }
    var parser: ParserProtocol? { get }
    var headers : [String : String]? { get }
}

extension EndpointProtocol {

    var shouldHandleAuthError: Bool {
        return true
    }

    var basePath: String {
        return ""
    }

    var queryParameters : [String : Any]? {
        return nil
    }

    var headers : [String : String]? {
        return nil
    }

}
