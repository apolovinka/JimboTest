//
//  FullLayoutConfigurator.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/22/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation

class FullListCollectionConfiguration : ListCollectionCalculationItem {

    let lines: CGFloat = 1
    let itemAspectRatio: CGFloat = 1.775
    let outterSidePaddingRatio: CGFloat = 0.10
    let lineSpaceRatio: CGFloat = 15.0
    let topEdgePadding: CGFloat = 0
    let bottomEdgePadding: CGFloat = 20.0

    let bottomPadding: CGFloat = 60.0
    let topPadding: CGFloat = 60.0

    var itemSize: CGSize = CGSize.zero
    var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero
    var lineSpacing: CGFloat = 0
    var interitemSpacing: CGFloat = 0

    func calculate(with screenSize: CGSize) {

        let width = screenSize.width

        let maxHeight = screenSize.height - self.topPadding - self.bottomPadding

        let outterSidePadding = width * self.outterSidePaddingRatio
        let itemWidth = width - outterSidePadding
        let itemHeight = min(itemWidth * self.itemAspectRatio, maxHeight)

        self.itemSize = CGSize(width: itemWidth, height: itemHeight)
        self.lineSpacing = (width - itemWidth)/2
        self.edgeInsets = UIEdgeInsets(top: self.topEdgePadding, left: self.lineSpacing,
                                       bottom: self.bottomEdgePadding, right: self.lineSpacing)

    }
}
