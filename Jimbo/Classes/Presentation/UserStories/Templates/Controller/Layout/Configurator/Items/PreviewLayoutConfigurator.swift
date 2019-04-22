//
//  LayoutConfiguratorPreview.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/22/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation

class PreviewListCollectionConfiguration : ListCollectionCalculationItem {

    let itemAspectRatio: CGFloat = 1.775
    let outterSidePaddingRatio: CGFloat = 0.1
    let innerSidePaddingRatio: CGFloat = 0.05
    let lineSpaceRatio: CGFloat = 20.0
    let topEdgePadding: CGFloat = 30.0

    var itemSize: CGSize = CGSize.zero
    var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero
    var lineSpacing: CGFloat = 0
    var interitemSpacing: CGFloat = 0

    func calculate(with screenSize: CGSize) {

        let width = screenSize.width / 2

        let outterSidePadding = width * self.outterSidePaddingRatio
        let innerSidePadding = width * self.innerSidePaddingRatio
        let itemWidth = width - outterSidePadding - innerSidePadding
        let itemHeight = itemWidth * self.itemAspectRatio

        self.itemSize = CGSize(width: itemWidth, height: itemHeight)
        self.lineSpacing = screenSize.height / self.lineSpaceRatio
        self.edgeInsets = UIEdgeInsets(top: self.topEdgePadding, left: outterSidePadding,
                                       bottom: self.topEdgePadding, right: outterSidePadding)
        self.interitemSpacing = innerSidePadding
    }
}
