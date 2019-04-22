//
//  Drawings.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/22/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation


class Drawings {

    struct CircleImageConfiguration {
        let size: CGSize
        let inset: CGFloat
        let outterCircleWidth: CGFloat
        let outterCirclePaddingWidth: CGFloat
        let color: UIColor
    }

    class func circleImage(with configuration: CircleImageConfiguration) -> UIImage? {

        let inset = configuration.inset
        let origin = CGPoint(x: inset, y: inset)
        let size = CGSize(width: configuration.size.width, height: configuration.size.height)
        let color = configuration.color

        let layoutSize = CGSize(width: configuration.size.width + inset * 2, height: configuration.size.height + inset * 2)

        UIGraphicsBeginImageContextWithOptions(layoutSize, false, UIScreen.main.scale)

        if configuration.outterCircleWidth > 0 && configuration.outterCirclePaddingWidth > 0 {

            let rect = CGRect(origin: origin, size: size)
            let path = UIBezierPath(ovalIn: rect)
            path.lineWidth = configuration.outterCircleWidth
            path.addClip()
            color.setStroke()
            path.stroke()

        }

        let outterPadding = configuration.outterCirclePaddingWidth + (configuration.outterCircleWidth / 2)
        let rect = CGRect(origin: origin, size: size).insetBy(dx: outterPadding, dy: outterPadding)
        let path = UIBezierPath(ovalIn: rect)
        color.setFill()
        path.fill()


        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

}
