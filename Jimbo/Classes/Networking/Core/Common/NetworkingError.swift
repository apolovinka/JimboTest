//
//  NetworkingError.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 2/13/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkingError: LocalizedError {
    
    case invalidReponseDataType
    case invalidData
    case emptyResponse
    case failureCode(code: String, message: String)
    case failure(message: String)

    var title: String? {
        return "API Request Failure"
    }

    var errorDescription: String? {
        switch self {
        case .invalidReponseDataType:
            return "Could not parse response data"
        case .invalidData:
            return "Invalid response data"
        case .emptyResponse:
            return "Response data is empty"
        case .failureCode(code: let code, message: let message):
            return "Code: \(code), message: \(message)"
        case .failure(message: let message):
            return message
        }
    }
}
