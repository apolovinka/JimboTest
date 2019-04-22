//
//  UIImage+Utils.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 2/18/19.
//  Copyright © 2019 Alexplv. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

extension UIImage {

    struct ImageFromPathConfiguration {
        let fillColor: UIColor?
        let strokeColor: UIColor?
        let lineWidth: CGFloat?
    }

    class func image(for path: UIBezierPath, config: ImageFromPathConfiguration) -> UIImage? {

        UIGraphicsBeginImageContextWithOptions(path.bounds.size, false, 0);

        if let fillColor = config.fillColor {
            fillColor.setFill()
            path.fill()
        }

        if let strokeColor = config.strokeColor {
            strokeColor.setStroke()
            path.addClip()
            path.lineWidth = (config.lineWidth ?? 1.0)
            path.stroke()
        }

        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return image
    }

}
