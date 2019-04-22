//
//  NSNumber+Utils.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 2/13/19.
//  Copyright © 2019 Alexplv. All rights reserved.
//

import Foundation

extension NSNumber {
    class func from(value: Any?) -> NSNumber? {
        guard let value = value else {
            return nil
        }
        if let value = value as? Int {
            return NSNumber(value: value)
        }
        if let value = value as? Double {
            return NSNumber(value: value)
        }
        if let value = value as? Bool {
            return NSNumber(value: value)
        }
        if let value = value as? String, let doubleValue = Double(value) {
            return NSNumber(value: doubleValue)
        }
        return nil
    }
}
