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
func decodeObject<T: DVCodable>(json: JSON) -> DVResult<T> {
    let object: T = T.decode(object: json)
    return DVResult(object)
}

/// decodes an array of objects
func decodeObject<T: DVCodable>(json: JSON) -> DVResult<[T]> {
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

