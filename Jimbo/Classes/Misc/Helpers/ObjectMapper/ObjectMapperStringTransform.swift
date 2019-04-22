//
//  ObjectMapperStringTransform.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/18/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import ObjectMapper

struct StringTransform: TransformType {

    func transformFromJSON(_ value: Any?) -> String? {
        return value.flatMap(String.init(describing:))
    }

    func transformToJSON(_ value: String?) -> Any? {
        return value
    }

}
