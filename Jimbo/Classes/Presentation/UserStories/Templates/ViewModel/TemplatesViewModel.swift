//  
//  MainViewModel.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 3/13/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol TemplatesViewModelProtocol {

    var templatesService: TemplatesService! { set get }

    var isActive: BehaviorRelay<Bool> { get }
    var canReload: BehaviorRelay<Bool> { get }
    var error: PublishRelay<Error> { get }

    var selectedTemplateName: BehaviorRelay<String> { get }
    var selectedTemplateVariations: BehaviorRelay<([TemplateVariationItem], Int)> { get }
    var templatedUpdatedAtIndex: PublishRelay<Int> { get }
    var listHandler: ListHandler<TemplateRM>! { get }
    var selectedIndex: BehaviorRelay<Int> { get } 

    func setup()
    func didSelectVariationAction(index: Int, in selectetItemIndex: Int)
    func didSelectItemAction(index: Int)
}

class TemplatesViewModel : TemplatesViewModelProtocol {

    var templatesService: TemplatesService!
    
    let isActive = BehaviorRelay(value: false)
    let canReload = BehaviorRelay(value: false)
    var error = PublishRelay<Error>()

    let selectedTemplateName = BehaviorRelay(value: "")
    let selectedTemplateVariations = BehaviorRelay(value: ([TemplateVariationItem](), 0))
    let selectedIndex = BehaviorRelay(value: 0)
    let templatedUpdatedAtIndex = PublishRelay<Int>()

    private var templatesList: TemplatesList!
    private (set) var listHandler: ListHandler<TemplateRM>!

    func setup() {
        self.templatesList = TemplatesList(service: self.templatesService)
        self.listHandler = ListHandlerAdapter(observableList: self.templatesList)
    }

    // MARK: - View Input

    func didSelectVariationAction(index: Int, in selectetItemIndex: Int) {
        let item = self.listHandler.items[selectetItemIndex]
        let variation = item.variations[index]
        if let token = self.templatesList.observerToken {
            self.templatesService.set(variation: variation, for: item, skip: [token])
            self.templatedUpdatedAtIndex.accept(selectetItemIndex)
        }
    }

    func didSelectItemAction(index: Int) {
        self.selectedIndex.accept(index)
        let item = self.templatesList.items[index]
        let variations = Array(item.variations.map({TemplateVariationItem(color: $0.iconColorObject)}))
        var selectedVariationIndex = 0
        if let variation = item.selectedVariation {
            selectedVariationIndex = item.variations.enumerated().filter{$1.identifier == variation.identifier}.first?.offset ?? 0
        }
        self.selectedTemplateVariations.accept((variations, selectedVariationIndex))
        self.selectedTemplateName.accept(item.name)
    }
}
