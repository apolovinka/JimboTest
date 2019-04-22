//
//  RealmListObserver.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/17/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import RealmSwift

protocol ObservableList {
    associatedtype T
}

class RealmObservableList<T: Object>: NSObject {

    typealias ListConfigurationHandler = () -> (Results<T>)

    var configurationHandler: ListConfigurationHandler = {
        return DataStackRM.realm.objects(T.self)
    }

    var updateHandler: ((UpdateAction) -> ())?
    var errorHandler: ((Error) -> ())?

    var items: Results<T>

    var observerToken: NotificationToken? = nil

    override init() {
        self.items = self.configurationHandler()
        super.init()
        self.setupList()
    }

    init(configurationHandler: @escaping ListConfigurationHandler) {
        self.configurationHandler = configurationHandler
        self.items = self.configurationHandler()
        super.init()
        self.setupList()
    }

    private func setupList() {

        if let observerToken = self.observerToken {
            observerToken.invalidate()
        }

        self.observerToken = self.items.observe {
            [unowned self] changes in

            switch changes {
            case .initial:
                self.updateHandler?(.initial)
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                if !deletions.isEmpty {
                    self.updateHandler?(.deletions(deletions))
                }
                if !insertions.isEmpty {
                    self.updateHandler?(.insertions(insertions))
                }
                if !modifications.isEmpty {
                    self.updateHandler?(.modifications(modifications))
                }
            case .error(let error):
                self.errorHandler?(error)
            }

        }
    }

    deinit {
        self.observerToken?.invalidate()
    }
}
