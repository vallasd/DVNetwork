//
//  File.swift
//  
//
//  Created by David Vallas on 4/21/20.
//

import Foundation

/// Error header will be added to the beginning of the Error message
enum ErrorHeader {
    case generic            // generic errors
    case coredata(String)   // coredata errors
    case defaults(String)   // defaults errors
    case network(String)    // network errors
    case validation(String) // validation errors
    
    var details: String {
        switch self {
        case .generic:             return "|Error|"
        case .coredata(let e):     return "|Error CoreData| entity: |\(e)|"
        case .defaults(let e):     return "|Error Defaults| entity: |\(e)|"
        case .network(let e):      return "|Error Network| entity: |\(e)|"
        case .validation(let e):   return "|Error Validation| entity: |\(e)|"
        }
    }
}

/// type of error displayed, the main message of the localized error will change depending on which errorType is selected
enum ErrorType {
    case generic            // generic error, no additional info
    case insert             // failed to insert into a set
    case notAny             // was not expected type (introspection)
    case notArray           // expected an Array, was not
    case notImplemented     // code hasnt been implement yet
    case notRegistered      // not registered in the EntityRegister
    case notSet             // expected an Set, was not
    case notSingle          // expected a single item, was some type of collection
    case open               // could not open Entity from source
    case requiredIsNil      // not an optional but received a nil value
    case save               // could not save Entity to destination
    case validation         // validation failed for entity
    
    func details(data: ErrorData) -> String {
        let k = data.key ?? "NotGiven"
        let f = data.failed == nil ? "NotGiven" : findType(data.failed!)
        let n = data.not == nil ? "NotGiven" : data.not!
        switch self {
        case .generic: return "not details provided"
        case .insert: return "key: |\(k)| failed insert: |\(f)| in set: |\(n)|"
        case .notAny: return "key: |\(k)| not: |\(n)|"
        case .notArray: return "key: |\(k)| not Array"
        case .notImplemented: return "not yet implemented"
        case .notRegistered: return "key: |\(k)| not registered"
        case .notSet: return "key: |\(k)| not Set"
        case .notSingle: return "key: |\(k)| not Single"
        case .open: return "key: |\(k)| failed open"
        case .requiredIsNil: return "key: |\(k)| required object is nil"
        case .save: return "key: |\(k)| failed save"
        case .validation: return "key: |\(k)| failed validation - object: |\(f)| not: |\(n)|"
        }
    }
    
    func findType(_ any: Any) -> String { return String(describing: type(of: any)) }
}

/// data  collected to be used inside ErrorType details
public struct ErrorData {
    var key: String?
    var failed: Any?
    var not: Any?
    
    init() {}
    
    init(_ key: String?, _ failed: Any?, _ not: Any?) {
        self.key = key
        self.failed = failed
        self.not = not
    }
}

/// DVNetwork errors. Use the static definitions to create the appropriate error, use update to change the header downstream from thrown error
struct DVError: Error {
    let header: ErrorHeader
    let errorType: ErrorType
    let data: ErrorData
    
    static var generic: DVError { return DVError(.generic) }
    static func insert(key: String, set: Any, inserted: Any) -> DVError { return DVError(.insert, key, inserted, set) }
    static func notAny(key: String, not: Any) -> DVError { return DVError(.notAny, key, not) }
    static func notArray(key: String) -> DVError { return DVError(.notArray, key) }
    static var notImplemented: DVError { return DVError(.notImplemented) }
    static func notRegistered(key: String) -> DVError { return DVError(.notRegistered, key) }
    static func notSet(key: String) -> DVError { return DVError(.notSet, key) }
    static func notSingle(key: String) -> DVError { return DVError(.notSingle, key) }
    static func open(key: String) -> DVError { return DVError(.open, key) }
    static func requiredIsNil(key: String) -> DVError { return DVError(.requiredIsNil, key) }
    static func save(key: String) -> DVError { return DVError(.save, key) }
    
    func update(header: ErrorHeader) -> DVError {
        return DVError(header: header, errorType: errorType, data: data)
    }
    
    init(header: ErrorHeader, errorType: ErrorType, data: ErrorData) {
        self.header = header
        self.errorType = errorType
        self.data = data
    }
    
    private init(_ errorType: ErrorType) {
        self.header = .generic
        self.errorType = errorType
        self.data = ErrorData()
    }
    
    private init(_ errorType: ErrorType, _ key: String) {
        self.header = .generic
        self.errorType = errorType
        self.data = ErrorData(key, nil, nil)
    }
    
    private init(_ errorType: ErrorType, _ key: String, _ not: Any) {
        self.header = .generic
        self.errorType = errorType
        self.data = ErrorData(key, nil, not)
    }
        
    private init(_ errorType: ErrorType, _ key: String, _ failed: Any, _ not: Any) {
        self.header = .generic
        self.errorType = errorType
        self.data = ErrorData(key, failed, not)
    }
}

extension DVError: LocalizedError {
    public var errorDescription: String? {
        return NSLocalizedString("\(header.details) \(errorType.details(data: data))", comment: "\(header.details)")
    }
}






