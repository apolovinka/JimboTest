//
//  LoggingHelper.swift
//  RoomBooking
//
//  Created by Alexander Polovinka on 2/12/19.
//  Copyright © 2019 Alexplv. All rights reserved.
//

import Foundation

func Log(_ message: Any) {
    #if DEBUG
        print(message)
    #endif
}
