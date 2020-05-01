//
//  File.swift
//  
//
//  Created by David Vallas on 4/21/20.
//

import Foundation

public enum ValidationType {
    case json
//    case entityKeys
//    case coredata
//    case defaults
//    case network
    
    func validate(any: Any, entityData: EntityData) throws {
        do {
            switch self {
            case .json: try validateJSON(json: any, entityData: entityData)
            }
        } catch {
            if let e = error as? CDError {
                let newHeader = ErrorHeader.validation(entityName: entityData.name)
                throw e.update(newHeader: newHeader)
            }
        }
        
    }
    
    private func validateJSON(json: JSON, entityData: EntityData) throws {
        guard let dict = json as? JSONDict else { throw CDError.notAny(key: entityData.name, not: JSONDict()) }
            let pd = entityData.dict
            for key in pd.keys {
                let j = dict[key]
                let data = pd[key]!
                if !data.optional {
                    if j == nil { throw CDError.requiredIsNil(key: key) }
                    try validateJSON(value: j!, primitiveData: data, key: key)
                }
            }
    }
    
    private func validateJSON(value: JSON, primitiveData: PrimitiveData, key: String) throws {
        let ct = primitiveData.collectionType
        let prim = primitiveData.primitive
        
        // iterate once
        if ct == .single {
            return try validateJSON(value: value, primitive: prim, key: key)
        }
        
        // iterate an array
        if ct == .array || ct == .set {
            guard let array = value as? JSONArray else {
                throw CDError.notAny(key: key, not: JSONArray.self)
            }
            for value in array {
                try validateJSON(value: value, primitive: prim, key: key)
            }
        }
    }
    
    /// returns true if JSON is valid, false if JSON is not valid
    private func validateJSON(value: JSON, primitive: Primitive, key: String) throws {
        var success = false;
        switch primitive {
        case .bool: success = value is Bool
        case .date: success = Date.decodeJSON(value) != nil
        case .double, .float: success = value is Double
        case .int, .int16, .int32, .int64, .Enum:
            guard let i = value as? Int else { throw CDError.notAny(key: key, not: primitive) }
            switch primitive {
            case .int16, .Enum: success = (i >= Int16.min && i <= Int16.max)
            case .int32:        success = (i >= Int32.min && i <= Int32.max)
            case .int64:        success = (i >= Int64.min && i <= Int64.max)
            default: success = true
            }
        case .string: success = value is String
        case .url: success = URL.decodeJSON(value) != nil
        case .uuid: success = UUID.decodeJSON(value) != nil
        }
        if !success {
            throw CDError.notAny(key: key, not: primitive)
        }
    }
        
}


//private func validateNetwork(any: Any, entityData: EntityData) throws {
//    throw CDError.notImplemented
//}
//

//    private func validateCodableKeys(any: Any, entityData: EntityData) throws {
//        throw CDError(.notImplemented)
//    }
//
//    private func validateCoreData(any: Any, entityData: EntityData) throws {
//        throw CDError(.notImplemented)
//    }
//
//    private func validateDefaults(any: Any, entityData: EntityData) throws {
//        throw CDError(.notImplemented)
//    }
