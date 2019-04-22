//
//  RealmObject+Mapping.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/18/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

extension Object {
    static func mapped(map: Map) -> BaseMappable? {
        guard var object = self.init() as? BaseMappable else {
            return nil
        }
        object.mapping(map: map)
        return object
    }
}
