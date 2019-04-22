//
//  NetworkingProtocols.swift
//  RoomBooking
//
//  Created by Alexander Polovinka on 2/12/19.
//  Copyright © 2019 Alexplv. All rights reserved.
//

import Foundation

protocol NetworkingClient {

    func request<T>(_ endpoint: EndpointProtocol, resultType:T.Type, completion: @escaping (_ result: Result<T>) -> Void)
}
