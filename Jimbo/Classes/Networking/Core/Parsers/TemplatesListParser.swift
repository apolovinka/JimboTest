//
//  RoomsParser.swift
//  RoomBooking
//
//  Created by Alexander Polovinka on 2/13/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift


class TemplatesListParser : ParserProtocol {

    let queue = DispatchQueue(label: "TemplatesListParser")
    let baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL
    }

    func parse(_ data: Any?, completion: @escaping (Result<Any>) -> ()) {

        guard let data = data as? Array<Any> else {
            completion(Result.failure(ParserError.invalidData))
            return
        }

        self.queue.async {

            var result: [TemplateRM] = []

            let realm = try! Realm()

            do {
                try realm.write {
                    let objectsIDsSnapshot = Array(realm.objects(TemplateRM.self)).compactMap{$0.identifier}

                    for (idx, item) in data.enumerated() {
                        if let object = self.object(with: idx, data: item, realm: realm) {
                            result.append(object)
                        }
                    }

                    self.merge(objects: result, snapshot: objectsIDsSnapshot, realm: realm)
                }
                DispatchQueue.main.async {
                    DataStackRM.realm.refresh()
                    completion(Result.success(Array(DataStackRM.realm.objects(TemplateRM.self).sorted(byKeyPath: "orderIndex"))))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            }
        }

    }

    private func object(with index: Int, data: Any?, realm: Realm) -> TemplateRM? {
        guard let url = data as? String else {
            return nil
        }

        // Remove base url
        let urlString = url.replacingOccurrences(of: self.baseURL, with: "")

        var object = realm.objects(TemplateRM.self).filter(NSPredicate(format: "url = %@", urlString)).first
        if object == nil {
            object = realm.create(TemplateRM.self, value: ["identifier": NSUUID().uuidString])
            object?.url = urlString
        }
        if object?.orderIndex != index {
            object?.orderIndex = index
        }
        return object
    }

    private func merge(objects: [TemplateRM], snapshot: [String], realm: Realm) {
        let objectsToRemove = snapshot.filter{ identifier in
            return !objects.contains(where: {$0.identifier  == identifier})
        }
        if !objectsToRemove.isEmpty {
            realm.delete(realm.objects(TemplateRM.self).filter("identifier IN %@", objectsToRemove))
        }
    }
    
}

