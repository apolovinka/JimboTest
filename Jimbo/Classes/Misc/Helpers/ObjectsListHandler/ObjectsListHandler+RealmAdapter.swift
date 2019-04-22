//
//  ObjectsListHandler+Realm.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/18/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation

class ListHandlerAdapter<T, U: RealmObservableList<T>> : ListHandler<T> {

    let observableList: U

    override var items: [T] {
        return self.observableList.items.map{$0}
    }

    override var updateHandler: ((UpdateAction) -> ())? {
        set {
            self.observableList.updateHandler = newValue
        }
        get {
            return self.observableList.updateHandler
        }
    }
    
    init(observableList: U) {
        self.observableList = observableList
    }
}
