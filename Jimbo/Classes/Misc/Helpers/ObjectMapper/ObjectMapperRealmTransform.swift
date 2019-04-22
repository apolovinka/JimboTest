//
//  RealmObjectMapper.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/17/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift


public struct ListTransform<T: RealmSwift.Object>: TransformType where T: BaseMappable {

    public init() { }

    public typealias Object = List<T>
    public typealias JSON = Array<Any>

    public func transformFromJSON(_ value: Any?) -> List<T>? {
        if let objects = Mapper<T>().mapArray(JSONObject: value) {
            let list = List<T>()
            list.append(objectsIn: objects)
            return list
        }
        return nil
    }

    public func transformToJSON(_ value: Object?) -> JSON? {
        return value?.compactMap{ $0.toJSON() }
    }

}

public struct KeyedListTransform<T: RealmSwift.Object>: TransformType where T: BaseMappable {

    public typealias MappingKeys = (keyName: String, valueName: String)

    let mappingKeys: MappingKeys

    public init(_ mappingKeys: MappingKeys) {
        self.mappingKeys = mappingKeys
    }

    public typealias Object = List<T>
    public typealias JSON = Array<Any>

    public func transformFromJSON(_ value: Any?) -> List<T>? {

        var mappedValues = value

        if let value = value as? [String : Any] {
            mappedValues = value.map{
                return [self.mappingKeys.keyName : $0.key, self.mappingKeys.valueName: $0.value]
            }
        }

        if let objects = Mapper<T>().mapArray(JSONObject: mappedValues) {
            let list = List<T>()
            list.append(objectsIn: objects)
            return list
        }
        
        return nil
    }

    public func transformToJSON(_ value: Object?) -> JSON? {
        return value?.compactMap{ $0.toJSON() }
    }

}
