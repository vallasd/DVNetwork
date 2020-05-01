//
//  File.swift
//  
//
//  Created by David Vallas on 4/21/20.
//

import Foundation

public struct PrimitiveData {
    let primitive: Primitive
    let collectionType: CollectionType
    let optional: Bool
    
    init(value: Any) throws {
        self.primitive = try Primitive(value: value)
        self.collectionType = CollectionType(value: value)
        self.optional = String(describing: type(of: value)).hasPrefix("Optional<")
    }
    
    func encodeJSON(value: Any) -> JSON {
        if let a = value as? Array<Any> { return a.map { primitive.encodeJSON(value: $0) } }
        if let s = value as? Set<AnyHashable> { return s.map { primitive.encodeJSON(value: $0) } }
        return primitive.encodeJSON(value: value)
    }
    
    // handle Sets
    func decodeJSON(json: JSON) -> Any {
        if let a = json as? JSONArray {
            let array = a.map { primitive.decodeJSON(json: $0) }
            if collectionType == .array { return array }
            if collectionType == .set {
                let set: Set<AnyHashable> = array.unsafeMapToSet { $0 as! AnyHashable }
                return set
            }
        }
        return primitive.decodeJSON(json: json)
    }
    
    var details: String {
        return "collection: |\(collectionType)| optional: |\(optional)| type: |\(primitive)| "
    }
}


