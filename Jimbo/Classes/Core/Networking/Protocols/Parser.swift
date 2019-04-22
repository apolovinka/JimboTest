//
//  ImporterProtocol.swift
//  Pr
//
//  Created by Alexander Polovinka on 11/18/16.
//  Copyright © 2017 Alexander Polovinka. All rights reserved.
//

import Foundation

protocol ParserProtocol {
    func parse(_ data: Any?, completion: @escaping (Result<Any>) -> ())
}

enum ParserError : LocalizedError {

    case invalidData

    var errorDescription: String {
        switch self {
        case .invalidData:
            return "parser-error-invalid-data".localized()
        }
    }
}
