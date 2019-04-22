//
//  TemplatesLayoutCalculator.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/22/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation

protocol ListCollectionCalculationItem {

    var itemSize: CGSize { get }
    var edgeInsets: UIEdgeInsets { get }
    var lineSpacing: CGFloat { get }
    var interitemSpacing: CGFloat { get }

    func calculate(with screenSize: CGSize)
}

class CollectionViewLayoutConfigurator {

    private var item: ListCollectionCalculationItem!

    func set(item: ListCollectionCalculationItem) {
        self.item = item
    }

    func calculate(with screenSize: CGSize, layout: UICollectionViewFlowLayout) {
        self.item.calculate(with: screenSize)
        layout.sectionInset = self.item.edgeInsets
        layout.minimumLineSpacing = self.item.lineSpacing
        layout.minimumInteritemSpacing = self.item.interitemSpacing
        layout.itemSize = self.item.itemSize
    }
}
