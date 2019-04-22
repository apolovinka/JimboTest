//
//  String+Utils.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 2/13/19.
//  Copyright © 2019 Alexplv. All rights reserved.
//

import Foundation

extension String {

    var numerals: String {
        let pattern = UnicodeScalar("0")..."9"
        return String(unicodeScalars
            .compactMap { pattern ~= $0 ? Character($0) : nil })
    }

    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }

}
