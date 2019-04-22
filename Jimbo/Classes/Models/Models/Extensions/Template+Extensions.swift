//
//  Template+Extensions.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/22/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import RealmSwift

extension TemplateRM {
    var isLoaded : Bool {
        return !self.templateIdentifier.isEmpty
    }
}

extension TemplateVariationRM {
    var iconColorObject : UIColor {
        return UIColor(hexString: self.iconColor)
    }
}

protocol ScreenshotsProvider {
    var screenshots: List<TemplateScreenshotRM> { get }
}

extension ScreenshotsProvider {
    func screenshot(with screenshotType: TemplateScreenshotType) -> TemplateScreenshotRM? {
        return self.screenshots.first{$0.name == screenshotType.name}
    }
}

extension TemplateRM : ScreenshotsProvider {}
extension TemplateVariationRM : ScreenshotsProvider {}
