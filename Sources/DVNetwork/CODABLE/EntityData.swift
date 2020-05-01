//
//  File.swift
//  
//
//  Created by David Vallas on 4/21/20.
//

import Foundation

public typealias EntityKeys = Dictionary<String, Any>
public typealias EntityDict = Dictionary<String, PrimitiveData>

public struct EntityData {
    let name: String
    let dict: EntityDict
    
    init(entity: Entity) throws {
        self.name = entity.entityName
        self.dict = try EntityData.setup(entity: entity)
    }
    
    func encodeJSON(entity: Entity) -> JSON {
        let mirror = Mirror(reflecting: entity)
        var json = JSONDict()
        for child in mirror.children {
            if
                let label = child.label,
                let primitive = dict[label] {
                if notNil(child.value) || !primitive.optional {
                    json[label] = primitive.encodeJSON(value: child.value)
                }
            }
        }
        return json
    }
    
    func decodeJSON<T: Entity>(json: JSON) -> T {
        let k = keys(jsonDict: json as! JSONDict)
        return T.init(with: k)
    }
    
    func keys(jsonDict: JSONDict) -> EntityKeys {
        var keys = EntityKeys()
        for key in dict.keys {
            let primitive = dict[key]!
            let json = jsonDict[key]
            if json != nil || !primitive.optional {
                keys[key] = primitive.decodeJSON(json: json!)
            }
        }
        return keys
    }
    
    private static func setup(entity: Entity) throws -> EntityDict {
        let mirror = Mirror(reflecting: entity)
        var dict = EntityDict()
        for child in mirror.children {
            if let keyName = child.label {
                let value = child.value
                dict[keyName] = try PrimitiveData(value: value)
            }
        }
        return dict
    }
    
    var details: String {
        var string = "|EntityData| name: \(name)"
        for key in dict.keys {
            string = string + end + dict[key]!.details + "key: \(key)"
        }
        return string
    }
}
