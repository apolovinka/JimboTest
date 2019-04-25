//  
//  MainViewModel.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/23/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MainModuleInput : class {
    func configure()
}

class MainViewModel : TemplatesViewModel, MainModuleInput {

    var router: MainRouter!

    let disposeBag = DisposeBag()
    let indexUpdate = BehaviorRelay(value: 0)

    // Module Input

    func configure () { }

    // View Input

    override func setup() {
        super.setup()
        
        self.isActive.accept(true)
        self.templatesService.templatesList() {
            result in
            if result.isFailure {
                self.canReload.accept(true)
                if let error = result.error {
                    self.error.accept(error)
                }
            }
            self.isActive.accept(false)
        }
    }

    override func didSelectItemAction(index: Int) {
        super.didSelectItemAction(index: index)
        let item = self.listHandler.items[index]
        self.router.openDetail(with: item.identifier, output: self)
    }

}

extension MainViewModel : DetailModuleOutput {

    func willDismissModule(with identifier: String) {
        guard let index = self.listHandler.items.firstIndex(where: {$0.identifier == identifier}) else {
            return
        }
        self.indexUpdate.accept(index)
        self.selectedIndex.accept(index)
    }

}
