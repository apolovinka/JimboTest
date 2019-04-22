//
//  TemplateCellViewModel.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/18/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import RxCocoa
import RealmSwift

class TemplateCellViewModel : CellViewModel {

    // MARK: - Protocol Requirements

    typealias Item = TemplateRM
    var output: CellViewModelOutput!

    // MARK: - Internal

    let templateService: TemplatesService
    private var model: TemplateRM!
    var token: NotificationToken?

    // MARK: - Output

    var name: String {
        return self.model.name
    }

    var imageURLString: String? {
        if let variation = self.model.selectedVariation {
            return variation.screenshot(with: .iphone)?.url
        }
        return self.model.screenshot(with: .iphone)?.url
    }

    var shouldReload: Bool {
        return self.model.shouldReload
    }

    private (set) var isLoading: Bool = false

    // MARK: - Init

    init(templateService: TemplatesService) {
        self.templateService = templateService
    }

    // MARK: - Protocol Input

    func prepareForReuse() {
        self.isLoading = false
        self.token?.invalidate()
    }

    func configure(with model: TemplateRM) {
        self.model = model
        self.token = model.observe{
            change in
            switch change {
            case .change:
                self.output.refresh()
            default: break
            }
        }
        if !model.isLoaded && !model.shouldReload {
            self.isLoading = true
            self.templateService.templateDetails(identifier: model.identifier) {
                _ in
                self.isLoading = false
            }
        }
        self.output.refresh()
    }
}
