//
//  SwinjectContainer.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/18/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import Swinject

protocol CellViewModelOutput {
    func refresh()
}

protocol CellViewModel {
    associatedtype Item
    var output: CellViewModelOutput! { get set }
    func prepareForReuse()
    func configure(with _: Item)
}

protocol CellViewModelContainer: class, CellViewModelOutput {
    associatedtype ViewModelType: CellViewModel
    var viewModel: ViewModelType? { get set }
}

class CellViewModelConfigurator {

    let container: Container

    init(container: Container) {
        self.container = container
    }

    func resolveViewModel<CellType: CellViewModelContainer>(for cell: CellType, item: CellType.ViewModelType.Item) {

        // Retreive or create a new viewModel
        var viewModel:CellType.ViewModelType! = cell.viewModel ?? self.container.resolve(CellType.ViewModelType.self)

        // Check if a cell has a viewModel and apply it
        if cell.viewModel == nil {
            viewModel.output = cell
            cell.viewModel = viewModel
        }

        // Perform a viewModel cofiguration for an item model
        viewModel.prepareForReuse()
        viewModel.configure(with: item)
    }

}
