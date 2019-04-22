//
//  NetworkingTypes.swift
//  RoomBooking
//
//  Created by Alexander Polovinka on 2/12/19.
//  Copyright © 2019 Alexplv. All rights reserved.
//

import Foundation

enum NetworkingRequestMethod : String {
    case get = "GET"
    case post = "POST"
    case update = "UPDATE"
    case delete = "DELETE"
}

enum NetworkingNotification : String, ApplicationNotificationProtocol {
    case noInternetConnection = "NetworkingNotificationNoInternet"
}
