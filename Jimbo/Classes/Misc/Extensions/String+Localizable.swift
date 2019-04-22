//
//  String+Localizable.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 3/13/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation

extension String {

    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }

}
