//
//  ConfigurableCell.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/16/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import UIKit

protocol ConfigurableCell {
    associatedtype Item
    func configure(with _: Item)
}

class Configurator<CellType: ConfigurableCell> {

    let item: CellType.Item

    init(_ item: CellType.Item) {
        self.item = item
    }

    func configure(_ cell: UITableViewCell) {
        (cell as? CellType)?.configure(with: self.item)
    }

    func configureCollectionView(_ cell: UICollectionViewCell) {
        (cell as? CellType)?.configure(with: self.item)
    }
}
