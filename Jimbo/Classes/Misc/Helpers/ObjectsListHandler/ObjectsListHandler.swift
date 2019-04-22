//
//  ObjectsListHandler.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/18/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation

class ListHandler<T> : NSObject {
    var items: [T] {
        return []
    }
    var updateHandler: ((UpdateAction) -> ())?
}
