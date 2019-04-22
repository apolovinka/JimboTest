//
//  RoomsEndpoint.swift
//  RoomBooking
//
//  Created by Alexander Polovinka on 2/13/19.
//  Copyright © 2019 Alexplv. All rights reserved.
//

import Foundation

enum RoomsEndpoint: EndpointProtocol {

    case roomsList(Double)

    var path: String {
        return "getrooms"
    }

    var method: NetworkingRequestMethod {
        return NetworkingRequestMethod.post
    }

    var parameters: [String : Any]? {
        switch self {
        case .roomsList(let date):
            return [
                "date" : "\(date)"
            ]
        }
    }

    var parser: ParserProtocol? {
        switch self {
        case .roomsList(let date):
            return RoomsParser(date: date)
        }
    }
}
