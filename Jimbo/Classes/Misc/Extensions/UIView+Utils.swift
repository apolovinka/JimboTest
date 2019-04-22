//
//  UIView+Utils.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 2/15/19.
//  Copyright © 2019 Alexplv. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    class func view<T: UIView>() -> T? {
        return Bundle.main.loadNibNamed(String(describing: self), owner: self, options: nil)?.first as? T
    }

}
