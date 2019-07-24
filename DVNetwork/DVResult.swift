//
//  File.swift
//  HuckleberryNetwork
//
//  Created by David Vallas on 5/4/18.
//  Copyright © 2018 David Vallas. All rights reserved.
//

import Foundation
import HGCodable

/// A result that can either be a generic Value or an Error
public enum DVResult<A> {
    case error(Error)
    case value(A)
    
    init(_ value: A) {
        self = .value(value)
    }
    
    init(_ error: Error?, _ value: A) {
        if let e = error {
            self = .error(e)
        } else {
            self = .value(value)
        }
    }
}

/// A result that can either be a generic Value with an optional PagingData or an Error
public enum DVResultWithPagingData<A> {
    case error(Error)
    case value(ValueWithPagingData<A>)
    
    init(_ error: Error) {
        self = .error(error)
    }
    
    init(_ result: DVResult<A>, pagingData: PagingData?) {
        switch result {
        case let .value(x):     self = .value(ValueWithPagingData(value: x, pagingData: pagingData))
        case let .error(error): self = .error(error)
        }
    }
    
    init(_ result: DVResultWithPagingData<A>, pagingData: PagingData?) {
        switch result {
        case let .value(x):
            let object = ValueWithPagingData(value: x.value, pagingData: pagingData)
            self = .value(object)
        case let .error(error):
            self = .error(error)
        }
    }
}

/// A generic Value that also contains an optional PagingData
public struct ValueWithPagingData<A> {
    public let value: A
    public let pagingData: PagingData?
    
    init(value v: A, pagingData pd: PagingData?) {
        value = v
        pagingData = pd
    }
}

/// Returns a Result with an Error if optional is nil
func resultFromOptional<A>(optional: A?, error: Error) -> DVResult<A> {
    if let a = optional {
        return .value(a)
    } else {
        return .error(error)
    }
}

/// decodes JSON for a specific object
func decodeJSON(data: Data) -> DVResult<JSON> {
    do {
        let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
        return .value(json)
    } catch {
        let error = NSError.decodeData
        return .error(error)
    }
}

/// decodes a single object
func decodeObject<T: HGCodable>(json: JSON) -> DVResult<T> {
    let object: T = T.decode(object: json)
    return DVResult(object)
}

/// decodes an array of objects
func decodeObject<T: HGCodable>(json: JSON) -> DVResult<[T]> {
    let objects: [T] = T.decode(object: json)
    return DVResult(objects)
}

/// Direct chaining with Result
func >>><A, B>(a: DVResult<A>, f: (A) -> DVResult<B>) -> DVResult<B> {
    switch a {
    case let .value(x):     return f(x)
    case let .error(error): return .error(error)
    }
}

