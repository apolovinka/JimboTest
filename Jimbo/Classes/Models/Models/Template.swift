//
//  Template.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/17/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import RealmSwift

class TemplateScreenshotRM : Object {
    @objc dynamic var name: String = ""
    @objc dynamic var url: String = ""
}

class TemplateVariationRM: Object {
    @objc dynamic var identifier: String = ""
    @objc dynamic var iconColor: String = ""
    @objc dynamic var orderIndex: Int = 0
    let screenshots = List<TemplateScreenshotRM>()
}

class TemplateRM : Object {

    @objc dynamic var url: String = ""
    @objc dynamic var orderIndex: Int = 0
    @objc dynamic var identifier: String = ""

    @objc dynamic var templateIdentifier: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var updatedAt = Date(timeIntervalSince1970: 1)
    @objc dynamic var selectedVariation: TemplateVariationRM?
    @objc dynamic var shouldReload: Bool = false

    let screenshots = List<TemplateScreenshotRM>()
    let variations =  List<TemplateVariationRM>()


    override static func primaryKey() -> String? {
        return "identifier"
    }
}

enum TemplateScreenshotType : String {
    case iphone
    var name: String {
        return self.rawValue
    }
}

