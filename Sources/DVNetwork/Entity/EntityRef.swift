//
//  File.swift
//  
//
//  Created by David Vallas on 4/22/20.
//

import Foundation

public struct EntityRef {
    let name: String
    let collectionType: CollectionType
    let optional: Bool
    
    init(value: Any) {
        let t = String(describing: type(of: value))
        self.name = t.innerBracket
        self.collectionType = CollectionType(value: value)
        self.optional = t.hasPrefix("Optional<")
    }
    
    var details: String {
        return "name: |\(name)| collection: |\(collectionType)| optional: |\(optional)|"
    }
}


//init(identifier: String, value: Any) throws {
//        let t = String(describing: type(of: value))
//        self.cType = CollectionType(value: value)
//        self.name = identifier
//        self.optional = t.hasPrefix("Optional<")
//        self.keyType = CodableKeyType(value: value)
//        self.value = value
//    }
//
//    func encode(value: Any) throws -> JSON {
//        if let v = value as? JSONArray { return try v.map { try keyType.encode($0, key: name) } }
//        if let v = value as? JSONSet { return try v.map { try keyType.encode($0, key: name) } }
//        return try keyType.encode(value, key: name)
//    }
//
//    func decode(json: JSON) throws -> Any {
//        if !optional && isNil(json) { throw ErrorCoding.deReqIsNil(name) }
//        switch cType {
//        case .single: return try decodeSingle(json: json)
//        case .array: return try decodeArray(json: json)
//        case .set: return try decodeSet(json: json)
//        }
//    }
//
//    var description: String {
//        let o = optional == true ? "optional " : ""
//        return "|CodableKey| |\(o)\(cType)| name: |\(name)| keyType: |\(keyType)|"
//    }
//
//    func validate(entity: Entity) throws {
//
//    }
//
////    func validator(value: Any, type: ValidationType) -> (Any) -> Bool {
////
////    }
//
//    func jsonEncoder() -> (Any) -> JSON {
//        switch keyType {
//            case .float: return { v in Double(v as! Float) }
//            case .int16: return { v in Int(v as! Int16) }
//            case .int32: return { v in Int(v as! Int32) }
//            case .int64: return { v in Int(v as! Int64) }
//            case .url: return { v in URL.encode(v as! URL) }
//            case .uuid: return { v in UUID.encode(v as! UUID) }
//            case .date: return { v in Date.encode(v as! Date) }
//            case .entity: return {
//                v in
//                let c = v as! Entity
//                return try! c.encode()
//            }
//            default: return { v in v }
//        }
//    }
//
//    private func decodeSingle(json: JSON) throws -> Any {
//        return try keyType.decode(json, key: name)
//    }
//
//    private func decodeArray(json: JSON) throws -> JSONArray {
//        guard let jsonArray = json as? JSONArray else { throw ErrorCoding.deArray(name) }
//        var array: JSONArray = []
//        for json in jsonArray {
//            let decoded = try decode(json: json)
//            array.append(decoded)
//        }
//        return array
//    }
//
//    private func decodeSet(json: JSON) throws -> JSONSet {
//        guard let jsonArray = json as? JSONArray else { throw ErrorCoding.deSet(name) }
//        var set: JSONSet = []
//        for json in jsonArray {
//            let decoded = try decode(json: json)
//            guard let hashable = decoded as? AnyHashable else { throw ErrorCoding.deNotHash(name) }
//            let inserted = set.insert(hashable).inserted
//            if !inserted { throw ErrorCoding.deSet(name) }
//        }
//        return set
//    }
