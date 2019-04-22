//
//  UIEdgeInsets+Utils.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 2/19/19.
//  Copyright © 2019 Alexplv. All rights reserved.
//

import UIKit

extension UIEdgeInsets {

    static func insets(with value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: value, left: value, bottom: value, right: value)
    }

}
