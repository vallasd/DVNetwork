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
public protocol DVCodable {
    var entityName: String { get }
    var encode: JSON { get }
    static func decode(json: JSON) throws -> Self
    static func decode(json: JSON) throws -> [Self]
}

public extension DVCodable {
    
    /// Attempts to decode an object into an array of objects of Type DVCodable.  Returns empty array an reports Error if unable to make an array.
    static func decode(json: JSON) throws -> [Self] {
        
        do {
            guard let array = json as? ARRAY else {
                DVReport.shared.decodeFailed(ARRAY.self, object: json)
                return []
            }
            var decodeds: [Self] = []
            for json in array {
                let decoded: Self = try decode(json: json)
                decodeds.append(decoded)
            }
            return decodeds
        } catch {
            throw error
        }
    }
    
    // MARK: - User Defaults
    
    /// Encodes and saves an object to standard user defaults given a key
    func saveDefaults(_ key: String) {
        let encoded = self.encode
        UserDefaults.standard.setValue(encoded, forKey: key)
    }
    
    /// Removes object with key from standard user defaults
    static func removeDefaults(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    /// Switches key names for object in standard user defaults
    static func switchDefaults(oldkey: String, newkey: String) {
        let def = UserDefaults.standard.value(forKey: oldkey)
        UserDefaults.standard.setValue(def, forKey: newkey)
        UserDefaults.standard.removeObject(forKey: oldkey)
    }
    
    /// Opens and decodes object from standard user defaults given a key
    static func openDefaults(_ key: String) throws -> Self? {
        let defaults = UserDefaults.standard
        guard let object = defaults.object(forKey: key) else { return nil }
        let decoded: Self? = try? Self.decode(json: object)
        return decoded
    }
}

public extension DVCodable where Self: Hashable {
    
    /// Decodes an array of objects into an set of [DVCodable]
    static func decode(object: Any) throws -> Set<Self> {
        
        do {
            guard let a = object as? ARRAY else {
                DVReport.shared.decodeFailed(ARRAY.self, object: object)
                return []
            }
            
            var set: Set<Self> = []
            for object in a {
                let decodedObject: Self = try decode(json: object)
                let inserted = set.insert(decodedObject).inserted
                if !inserted {
                    DVReport.shared.setDecodeFailed(Self.self, object: decodedObject)
                }
            }
            return set
        } catch {
            throw error
        }
    }
}

public extension Set where Iterator.Element: DVCodable {
    
    /// Encodes a Set of DVCodable
    var encode: [Any] {
        return self.map { $0.encode }
    }
}

public extension Array where Iterator.Element: DVCodable {
    
    /// Encodes an Array of DVCodable
    var encode: [Any] {
        return self.map { $0.encode }
    }
    
}
