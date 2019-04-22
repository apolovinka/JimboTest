//
//  TemplateParser.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/16/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

extension TemplateScreenshotRM : StaticMappable {

    static func objectForMapping(map: Map) -> BaseMappable? {
        return self.mapped(map: map)
    }

    func mapping(map: Map) {
        name <- map["name"]
        url <- map["url"]
    }
}

extension TemplateVariationRM : StaticMappable {

    static func objectForMapping(map: Map) -> BaseMappable? {
        return self.mapped(map: map)
    }

    func mapping(map: Map) {
        iconColor <- map["icon"]
        identifier <- (map["id"],StringTransform())
    }
}

extension TemplateRM : StaticMappable {

    static func objectForMapping(map: Map) -> BaseMappable? {
        return self.mapped(map: map)
    }

    func mapping(map: Map) {
        templateIdentifier <- (map["id"],StringTransform())
        name <- map["name"]
        type <- map["type"]
        updatedAt <- (map["updated_at"], DateTransform())
    }

}

class TemplateParser : ParserProtocol {

    /// An identifier of a template model for storing requested data
    let identifier: String

    let queue = DispatchQueue(label: "TemplateParser")

    required init(identifier: String) {
        self.identifier = identifier
    }

    func parse(_ data: Any?, completion: @escaping (Result<Any>) -> ()) {

        guard let data = data as? [String: Any] else {
            completion(Result.failure(ParserError.invalidData))
            return
        }

        self.queue.async {

            let realm = try! Realm()

            guard let object = realm.object(ofType: TemplateRM.self, forPrimaryKey: self.identifier) else {
                DispatchQueue.main.async {
                    completion(Result.failure(ParserError.invalidData))
                }
                return
            }

            do {
                try realm.write {
                    object.mapping(map: Map(mappingType: .fromJSON, JSON: data))
                    object.shouldReload = false

                    if let screenshots = data["screenshots"] as? [String: Any] {
                        if let array = KeyedListTransform<TemplateScreenshotRM>((keyName: "name", valueName: "url")).transformFromJSON(screenshots) {
                            object.screenshots.removeAll()
                            object.screenshots.append(objectsIn: array)
                        }
                    }

                    if let variations = data["variations"] as? [[String: Any]] {
                        let variationsIDsSnapshot = Array(object.variations.compactMap{$0.identifier})
                        for (idx, item) in variations.enumerated() {
                            guard let itemId = item["id"] as? Int else {
                                continue
                            }
                            let identifier = String(describing: itemId)
                            var variation = object.variations.first(where: {$0.identifier == identifier})
                            if variation == nil {
                                variation = realm.create(TemplateVariationRM.self)
                                if let variation = variation {
                                    object.variations.append(variation)
                                }
                            }
                            variation?.mapping(map: Map(mappingType: .fromJSON, JSON: item))
                            variation?.orderIndex = idx

                            if let screenshots = item["screenshots"] as? [String : Any] {
                                if let array = KeyedListTransform<TemplateScreenshotRM>((keyName: "name", valueName: "url")).transformFromJSON(screenshots) {
                                    variation?.screenshots.removeAll()
                                    variation?.screenshots.append(objectsIn: array)
                                }
                            }
                        }
                        self.mergeVariations(with: variationsIDsSnapshot, object: object, realm: realm)
                    } else {
                        object.variations.removeAll()
                    }

                }
                let ref = ThreadSafeReference(to: object)
                DispatchQueue.main.async {
                    DataStackRM.realm.refresh()
                    completion(Result.success(DataStackRM.realm.resolve(ref)))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            }

        }

    }

    private func mergeVariations(with snapshot: [String], object: TemplateRM, realm: Realm) {
        let variations = object.variations
        let objectsToRemove = snapshot.filter{ identifier in
            return !variations.contains(where: {$0.identifier  == identifier})
        }
        if !objectsToRemove.isEmpty {
            realm.delete(realm.objects(TemplateVariationRM.self).filter("identifier IN %@", objectsToRemove))
        }
        if let selectedVariation = object.selectedVariation {
            if objectsToRemove.contains(selectedVariation.identifier) {
                object.selectedVariation = nil
            }
        }
    }

}
