//  
//  DetailViewModel.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/23/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol DetailModuleInput : class {
    func configure(identifier: String, output: DetailModuleOutput)
}

protocol DetailModuleOutput {
    func willDismissModule(with identifier: String)
}

class DetailViewModel : TemplatesViewModel, DetailModuleInput {

    var router: DetailRouter!

    private var templateIdentifier: String = ""
    private var output: DetailModuleOutput?

    let disposeBag = DisposeBag()

    // Module Input

    func configure(identifier: String, output: DetailModuleOutput) {
        self.templateIdentifier = identifier
        self.output = output
    }

    // View Input

    override func setup() {
        super.setup()
        if let index = self.listHandler.items.firstIndex(where:{$0.identifier == self.templateIdentifier}) {
            self.selectedIndex.accept(index)
            self.didSelectItemAction(index: index)
        }
    }

    func closeAction() {
        self.output?.willDismissModule(with: self.listHandler.items[self.selectedIndex.value].identifier)
        self.router.close()
    }

}
