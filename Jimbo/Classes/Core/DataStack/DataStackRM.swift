//
//  DataStackRM.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/17/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import RealmSwift

class DataStackRM {

    typealias Token = NotificationToken

    static let realm = try! Realm()

    /// Perform a write closure in a new realm instance
    class func write(_ handler: ()->(), withoutNotifying: [NotificationToken] = []) throws {
        let realm = try Realm()
        realm.beginWrite()
        handler()
        try realm.commitWrite(withoutNotifying: withoutNotifying)
    }

}
