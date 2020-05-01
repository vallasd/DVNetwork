//
//  File.swift
//  
//
//  Created by David Vallas on 4/21/20.
//

import Foundation

enum Primitive {
    case bool
    case date
    case double
    case float
    case int
    case int16
    case int32
    case int64
    case string
    case url
    case uuid
    case Enum(Enum)
    
    init(value: Any) throws {
        let stringType = String(describing: type(of: value)).innerBracket
        switch stringType {
        case "Bool": self = .bool
        case "Date": self = .date
        case "Double": self = .double
        case "Float": self = .float
        case "Int": self = .int
        case "Int16": self = .int16
        case "Int32": self = .int32
        case "Int64": self = .int64
        case "String": self = .string
        case "URL": self = .url
        case "UUID": self = .uuid
        default:
            if let v = value as? Enum { self = .Enum(v) }
            else {
                throw CDError.notAny(key: String(describing: type(of: value)), not: Primitive.self)
            }
        }
    }
    
    func encodeJSON(value: Any) -> JSON {
        switch self {
        case .date:
            let date = value as! Date
            return date.encodeJSON
        case .float:
            let float = value as! Float
            return Double(float)
        case .int16:
            let int16 = value as! Int16
            return Int(int16)
        case .int32:
            let int32 = value as! Int32
            return Int(int32)
        case .int64:
            let int64 = value as! Int64
            return Int(int64)
        case .url:
            let url = value as! URL
            return url.absoluteString
        case .uuid:
            let uuid = value as! UUID
            return uuid.uuidString
        case .Enum:
            let enuM = value as! Enum
            return Int(enuM.rawValue)
        default: return value
        }
    }
    
    func decodeJSON(json: JSON) -> Any {
        switch self {
        case .date:
            return Date.decodeJSON(json)!
        case .float:
            let double = json as! Double
            return Float(double)
        case .int16:
            let int = json as! Int
            return Int16(int)
        case .int32:
            let int = json as! Int
            return Int32(int)
        case .int64:
            let int = json as! Int
            return Int64(int)
        case .url:
            let string = json as! String
            return URL(string: string)!
        case .uuid:
            let string = json as! String
            return UUID(uuidString: string)!
        case .Enum(let EnuM):
            let int = json as! Int
            return type(of: EnuM).init(rawValue: Int16(int))!
        default: return json
        }
    }
}
