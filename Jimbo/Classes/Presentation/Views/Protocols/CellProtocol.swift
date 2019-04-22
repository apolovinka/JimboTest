//
//  BaseCollectionViewCell.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/19/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation

protocol ReusableCell {
    static var cellIdentifier: String { get }
}

extension ReusableCell {
    static var cellIdentifier : String {
        return String(describing: self)
    }
}
