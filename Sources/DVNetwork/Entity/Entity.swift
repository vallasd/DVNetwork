//    The MIT License (MIT)
//
//    Copyright (c) 2018 David C. Vallas (david_vallas@yahoo.com) (dcvallas@twitter)
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE

import Foundation

/// Protocol for Coding and Decoding objects.

public protocol Entity {
    var id: UUID { get }
    init()
    init(with keys: EntityKeys)
}

public protocol Enum {
    var rawValue: Int16 { get }
    init?(rawValue: Int16)
}

// MARK: -
extension Entity {
    
    /// encodes the entity into JSON, does not validate, slower
    func encodeJSON() throws -> JSON {
        let data = try EntityData(entity: self)
        return data.encodeJSON(entity: self)
    }
    
    /// encodes the entity into JSON using the data file provided, does not validate, faster
    func encodeJSON(data: EntityData) -> JSON {
        return data.encodeJSON(entity: self)
    }
    
    /// validates if the json is correct formatted in order to be decoded, throws error if not, slower
    static func validate(json: JSON) throws {
        let data = try EntityData(entity: self.init())
        return try validate(json: json, data: data)
    }
    
    /// validates if the json is correct formatted in order to be decoded, throws error if not, faster
    static func validate(json: JSON, data: EntityData) throws {
        let vt = ValidationType.json
        return try vt.validate(any: json, entityData: data)
    }
    
    /// provides the entity name
    var entityName: String {
        return String(describing: type(of: self))
    }
    
//    static var entityName: String {
//        return String(describing: type(of: self))
//    }
    
    /// encodes and saves an object to standard user defaults given a key
    func saveDefaults() throws {
        let encoded = try self.encodeJSON()
        let key = self.entityName
        UserDefaults.standard.setValue(encoded, forKey: key)
    }
    
    /// provides a nicely formatted string descibing the entity
    var details: String {
        var string = "|\(type(of: self))|\(end)"
        for child in Mirror(reflecting: self).children {
            string = string + "\(child.label ?? "???"): \(child.value)\(end)"
        }
        return string
    }
}

public extension Array where Iterator.Element: Entity {
    func encodeJSON() throws -> [JSON] {
        if self.count == 0 { return [] }
        return try self.map { try $0.encodeJSON() }
    }
    
    func saveDefaults() throws {
        let encoded = try self.encodeJSON()
        if let first = self.first {
            let key = first.entityName + "Array"
            UserDefaults.standard.setValue(encoded, forKey: key)
        }
    }
}

public extension Set where Iterator.Element: Entity {
    func encodeJSON() throws -> [JSON] {
        if self.count == 0 { return [] }
        return try self.map { try $0.encodeJSON() }
    }
    
    func saveDefaults() throws {
        let encoded = try self.encodeJSON()
        if let first = self.first {
            let key = first.entityName + "Set"
            UserDefaults.standard.setValue(encoded, forKey: key)
        }
    }
}

func decode<T: Entity>(json: JSON) throws -> T {
    let data = try EntityData(entity: T.init())
    return decode(json: json, data: data)
}

func decode<T: Entity>(json: JSON, data: EntityData) -> T {
    let decoded: T = data.decodeJSON(json: json)
    return decoded
}

func decode<T: Entity>(json: JSON) throws -> [T] {
    let new = T.init()
    let data = try EntityData(entity: new)
    guard let array = json as? JSONArray else { throw DVError.notArray(key: new.entityName) }
    return array.map({ decode(json: $0, data: data) })
}

func decode<T: Entity>(json: JSON) throws -> Set<T> {
    let new = T.init()
    let data = try EntityData(entity: new)
    guard let array = json as? JSONArray else { throw DVError.notArray(key: new.entityName) }
    return array.mapToSet{ decode(json: $0, data: data) }
}

func openDefaults<T: Entity>() throws -> T {
    let entity = String(describing: T.self)
    let key = entity
    guard let json = UserDefaults.standard.object(forKey: key) else {
        throw DVError.open(key: key).update(header: .defaults(entity))
    }
    let decoded: T = try decode(json: json)
    return decoded
}

func openDefaults<T: Entity>() throws -> [T] {
    let entity = String(describing: T.self)
    let key = entity + "Array"
    guard let json = UserDefaults.standard.object(forKey: key) else {
        throw DVError.open(key: key).update(header: .defaults(entity))
    }
    let decoded: [T] = try decode(json: json)
    return decoded
}

func openDefaults<T: Entity>() throws -> Set<T> {
    let entity = String(describing: T.self)
    let key = entity + "Set"
    guard let json = UserDefaults.standard.object(forKey: key) else {
        throw DVError.open(key: key).update(header: .defaults(entity))
    }
    let decoded: Set<T> = try decode(json: json)
    return decoded
}
