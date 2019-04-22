//
//  Date+Utils.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 2/13/19.
//  Copyright © 2019 Alexplv. All rights reserved.
//

import Foundation

extension Date {

    static func timeInterval(from hours: String) -> TimeInterval? {
        let components = hours.components(separatedBy: ":")
        guard components.count >= 2 else {
            return nil
        }
        var result: TimeInterval = 0;
        if let hrs = Int(components[0]) {
            result += Double(hrs*60*60)
        }
        if let mins = Int(components[1]) {
            result += Double(mins*60)
        }
        return result
    }

}
