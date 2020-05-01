//
//  File.swift
//  
//
//  Created by David Vallas on 4/21/20.
//

import Foundation

struct ErrorHeaderData {
    let string1: String?
    let string2: String?
    
    init(_ string1: String) {
        self.string1 = string1
        self.string2 = nil
    }
}

enum ErrorHeader {
    case generic
    case saving(ErrorHeaderData)
    case validation(ErrorHeaderData)
    
    static func validation(entityName: String) -> ErrorHeader { return .validation(ErrorHeaderData(entityName))}
    
    var details: String {
        switch self {
        case .generic: return "|Error|"
        case .saving(let vd): return "|Error Saving| entity: |\(vd.string1!)|"
        case .validation(let vd): return "|Error Validation| entity: |\(vd.string1!)|"
        }
    }
}

enum ErrorType {
    case generic
    case notImplemented
    case notRegistered
    case notSingle
    case notArray
    case notSet
    case requiredIsNil
    case notAny
    case failedInsert
    case failedValid
    case failedSave
    case failedOpen
    
    func details(data: ErrorData) -> String {
        let k = data.key ?? "NotGiven"
        let f = data.failed == nil ? "NotGiven" : findType(data.failed!)
        let n = data.not == nil ? "NotGiven" : data.not!
        switch self {
        case .generic: return "not details provided"
        case .notImplemented: return "not yet implemented"
        case .notRegistered: return "key: |\(k)| not registered"
        case .notSingle: return "key: |\(k)| not Single"
        case .notArray: return "key: |\(k)| not Array"
        case .notSet: return "key: |\(k)| not Set"
        case .requiredIsNil: return "key: |\(k)| required object is nil"
        case .notAny: return "key: |\(k)| not: |\(n)|"
        case .failedInsert: return "key: |\(k)| failed insert: |\(f)| in set: |\(n)|"
        case .failedValid: return "key: |\(k)| failed validation - object: |\(f)| not: |\(n)|"
        case .failedSave: return "key: |\(k)| failed save"
        case .failedOpen: return "key: |\(k)| failed open"
        }
    }
    
    func findType(_ any: Any) -> String { return String(describing: type(of: any)) }
}

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

struct CDError: Error {
    let header: ErrorHeader
    let errorType: ErrorType
    let data: ErrorData
    
    static var generic: CDError { return CDError(.generic) }
    static var notImplemented: CDError { return CDError(.notImplemented) }
    static func notRegistered(key: String) -> CDError { return CDError(.notRegistered, key) }
    static func notSingle(key: String) -> CDError { return CDError(.notSingle, key) }
    static func notArray(key: String) -> CDError { return CDError(.notArray, key) }
    static func notSet(key: String) -> CDError { return CDError(.notSet, key) }
    static func requiredIsNil(key: String) -> CDError { return CDError(.requiredIsNil, key) }
    static func notAny(key: String, not: Any) -> CDError { return CDError(.notAny, key, not) }
    static func failedInsert(key: String, set: Any, inserted: Any) -> CDError { return CDError(.failedInsert, key, inserted, set) }
    static func failedSave(key: String, entity: String) -> CDError { return CDError(saveError: .failedSave, key: key, entity: entity) }
    static func failedOpen(key: String, entity: String) -> CDError { return CDError(saveError: .failedOpen, key: key, entity: entity) }
    
    func update(newHeader: ErrorHeader) -> CDError {
        return CDError(header: newHeader, errorType: errorType, data: data)
    }
    
    init(header: ErrorHeader, errorType: ErrorType, data: ErrorData) {
        self.header = header
        self.errorType = errorType
        self.data = data
    }
    
    private init(saveError: ErrorType, key: String, entity: String) {
        self.header = .saving(ErrorHeaderData(entity))
        self.errorType = saveError
        self.data = ErrorData(key, nil, nil)
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

extension CDError: LocalizedError {
    public var errorDescription: String? {
        return NSLocalizedString("\(header.details) \(errorType.details(data: data))", comment: "\(header.details)")
    }
}






