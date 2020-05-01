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

import UIKit

var errorEntity: String = "UnknownEntity"

public enum ErrorSave: Error {
    case keyNotFound(String)
    
    var entityName: String  {
    switch self {
        case .keyNotFound(let en): return en
        }
    }
    
    var name: String  {
    switch self {
        case .keyNotFound: return "keyNotFound"
        }
    }
}

extension ErrorSave: LocalizedError {
    public var errorDescription: String? {
        return NSLocalizedString("type: |\(self.name)|", comment: "|ErrorSave| \(self.entityName)")
    }
}

public struct EData {
    var msg: String?
    var object: Any?
    var value: Any?
    
    init(object: Any) {
        self.object = object
    }
    
    init(msg: String?) {
        self.msg = msg
    }
    
    init(object: Any, value: Any) {
        self.object = object
        self.value = value
    }
    
    /// returns the type of any excluding Optional and Collection
    static func ts(_ any: Any) -> String { return String(describing: type(of: any)) }
    
    // ED creation
    static var generic: EData = EData(msg: "generic error")
    static var notImplemented: EData = EData(msg: "not yet implemented")
    static var notRegistered: EData = EData(msg: "not registered, no reference")
    static func notSingle(_ key: String ) -> EData { EData(msg: "key: |\(key)| not Single") }
    static func notArray(_ key: String ) -> EData { EData(msg: "key: |\(key)| not Array") }
    static func notSet(_ key: String ) -> EData { EData(msg: "key: |\(key)| not Set") }
    static func requiredIsNil(_ key: String) -> EData { EData(msg: "key: |\(key)| required object is nil") }
    static func notAny(_ key: String, t: Any) -> EData { EData(msg: "key: |\(key)| not: |\(ts(t))|") }
    static func failedInsert(_ key: String, obj: Any, set: Any) -> EData {EData(msg: "key: |\(key)| failed insert: |\(ts(obj))| in set: |\(ts(set))|") }
    
    var description: String {
        var string = ""
        if let m = msg { string = string + m + " " }
        if let o = object {
            let mirror = Mirror(reflecting: o)
            for child in mirror.children {
                if let property = child.label {
                    string = string + property
                    string = string + ": |\(child.value)| "
                }
            }
        }
        if let v = value {
            string = string + "value: |\(v)|"
        }
        return string
    }
}

/// TODO: Make CodingData has encoding/decodng option
public enum ErrorCoding: Error {
    case encoding(EData)
    case decoding(EData)
    
    static var empty: ErrorCoding { return .encoding(EData(msg: "no description provided")) }
    static var notImplemented: ErrorCoding { return .encoding(EData(msg: "not yet implemented")) }
    static var enNotRegistered: ErrorCoding { return .encoding(EData(msg: "not registered in EntityS")) }
    static var deNotDeentity: ErrorCoding { return .decoding(EData(msg: "does not conform to Entity")) }
    static func enArray(_ key: String ) ->  ErrorCoding { return .encoding(EData(msg: "key: |\(key)| expecting JSONArray")) }
    static func deArray(_ key: String ) ->  ErrorCoding { return .decoding(EData(msg: "key: |\(key)| expecting JSONArray")) }
    static func enSet(_ key: String ) ->  ErrorCoding { return .encoding(EData(msg: "key: |\(key)| expecting JSONSet")) }
    static func deSet(_ key: String ) ->  ErrorCoding { return .decoding(EData(msg: "key: |\(key)| expecting JSONSet")) }
    static func enDict(_ key: String ) ->  ErrorCoding { return .encoding(EData(msg: "key: |\(key)| expecting JSONDict")) }
    static func deDict(_ key: String ) ->  ErrorCoding { return .decoding(EData(msg: "key: |\(key)| expecting JSONDict")) }
    static func deNotHash(_ key: String ) -> ErrorCoding { return .encoding(EData(msg: "key: |\(key)| object in JSONSet not Identifiable")) }
    static func deReqIsNil(_ key: String ) -> ErrorCoding { return .decoding(EData(msg: "key: |\(key)| required JSON for is nil")) }
    static func enType(_ key: String, t: Any) -> ErrorCoding { return .decoding(EData(msg: "key: |\(key)| typeNotFound: |\(ts(t))|")) }
    static func deType(_ key: String, t: Any) -> ErrorCoding { return .decoding(EData(msg: "key: |\(key)| typeNotFound: |\(ts(t))|")) }
    static func vaType(_ key: String, t: Any) -> ErrorCoding { return .decoding(EData(msg: "key: |\(key)| typeNotFound: |\(ts(t))|")) }
    
    static func ts(_ any: Any) -> String { return String(describing: type(of: any)).innerBracket }
    
    var data: EData  {
        switch self {
        case .encoding(let e): return e
        case .decoding(let e): return e
        }
    }
    
    var name: String  {
        switch self {
        case .encoding: return "encoding"
        case .decoding: return "decoding"
        }
    }
}

extension ErrorCoding: LocalizedError {
    public var errorDescription: String? {
        return NSLocalizedString("|ERROR \(self.name)| \(data.description)", comment: "|Error|")
    }
}

public extension Error {
    
    /// Creates a UIAlertController from Error msg
    var alert: UIAlertController {
        let alert = UIAlertController(title: "\((self as NSError).code)", message: self.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
    
    /// Prints the Error to log in specific format
    func display() {
        print("Error: code: |\((self as NSError).code)| info: |\(self.localizedDescription)|")
    }
    
    /// Defined Error msgs
    
    static var decodeData: Error {
        let msg = "Unable to decode JSON from data"
        return NSError(domain: "", code: 501, userInfo: [NSLocalizedDescriptionKey: msg])
    }
    
    static func decodeObject<T>(_ type: T) -> Error {
        let msg = "Unable to decode |\(type)| from JSON"
        return NSError(domain: "", code: 502, userInfo: [NSLocalizedDescriptionKey: msg])
    }
    
    static func decodeObjectArray<T>(_ type: T) -> Error {
        let msg = "Unable to decode |[\(type)]| from JSON"
        return NSError(domain: "", code: 502, userInfo: [NSLocalizedDescriptionKey: msg])
    }
    
    static func createURL(_ urlString: String) -> Error {
        let msg = "Unable to create url with string \(urlString)"
        return NSError(domain: "", code: 503, userInfo: [NSLocalizedDescriptionKey: msg])
    }
    
    static var dataError: Error {
        let msg = "Did not receive data from request"
        return NSError(domain: "", code: 504, userInfo: [NSLocalizedDescriptionKey: msg])
    }
    
    static var pagingDataError: Error {
        let msg = "Unable to retrieve paging information for request"
        return NSError(domain: "", code: 505, userInfo: [NSLocalizedDescriptionKey: msg])
    }
    
    static func error(message msg: String, code: Int) -> Error {
        return NSError(domain: "", code: code, userInfo: [NSLocalizedDescriptionKey: msg])
    }
}
