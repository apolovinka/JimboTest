//
//  ApplicationNotificationProtocol.swift
//  RoomBooking
//
//  Created by Alexander Polovinka on 2/12/19.
//  Copyright © 2019 Alexplv. All rights reserved.
//

import Foundation

protocol ApplicationNotificationProtocol {
    var name : Notification.Name { get }
    var rawValue: String { get }
}

extension ApplicationNotificationProtocol {
    var name : Notification.Name {
        return Notification.Name(rawValue: self.rawValue)
    }
}
