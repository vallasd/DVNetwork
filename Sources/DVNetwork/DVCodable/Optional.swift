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

// we are making an external var because creating a date formatter can be expensive if done a lot
fileprivate var dateFormatter1: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter
}()

// we are making an external var because creating a date formatter can be expensive if done a lot
fileprivate var dateFormatter2: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return formatter
}()

struct DecodeKey {
    var name: String
    var type: DecodeType
    var optional: Bool
    var container: DecodeContainer
    
    static func decodable(name: String, type: DecodeType) -> DecodeKey {
        return DecodeKey(name: name, type: type, optional: false, container: .single)
    }
    
    static func optional(name: String, type: DecodeType) -> DecodeKey {
        return DecodeKey(name: name, type: type, optional: true, container: .single)
    }
    
    static func array(name: String, type: DecodeType) -> DecodeKey {
        return DecodeKey(name: name, type: type, optional: false, container: .array)
    }
    
    static func set(name: String, type: DecodeType) -> DecodeKey {
        return DecodeKey(name: name, type: type, optional: false, container: .set)
    }
}

enum DecodeContainer {
    case single
    case array
    case set
}

enum DecodeType {
    case bool
    case string
    case double
    case float
    case int
    case int8
    case int16
    case int32
    case int64
    case uInt
    case uInt8
    case uInt16
    case uInt32
    case uInt64
    case dvcodable
}

// public func decodeIfPresent<T>(_ type: T.Type, forKey key: Self.Key) throws -> T? where T : Decodable

public extension Optional {
    
    var array: DVARRAY {
        if let array = self as? DVARRAY { return array }
        DVReport.shared.optionalFailed(DVARRAY.self, object: self, returning: [])
        return []
    }

    var dict: DVDICT {
        if let dict = self as? DVDICT { return dict }
        DVReport.shared.optionalFailed(DVDICT.self, object: self, returning: [:])
        return [:]
    }

    var bool: Bool {
        if let b = self.checkBool { return b }
        DVReport.shared.optionalFailed(Bool.self, object: self, returning: false)
        return false
    }

    var optionalBool: Bool? {
        if let b = self.checkBool { return b }
        DVReport.shared.optionalFailed(Bool.self, object: self, returning: nil)
        return nil
    }

    var checkBool: Bool? {
        if let bool = self as? Bool {
            return bool
        }
        if let s = self as? String {
            if s == "T" || s == "t" || s == "True" || s == "true" { return true }
            if s == "F" || s == "f" || s == "False" || s == "false" { return false }
        }
        if let i = self as? Int {
            if i == 1 { return true }
            if i == 0 { return false }
        }
        return nil
    }

    var string: String {
        if let s = self.checkString { return s }
        DVReport.shared.optionalFailed(String.self, object: self, returning: "")
        return ""
    }

    var optionalString: String? {
        if let s = self.checkString { return s}
        DVReport.shared.optionalFailed(String.self, object: self, returning: nil)
        return nil
    }

    var checkString: String? {
        if let string = self as? String { return string }
        return nil
    }

    func string(withDefault d: String) -> String {
        if let string = self as? String {
            if string == "" {
                return d
            }
            return string
        }
        return d
    }

    var int: Int {
        if let i = self.checkInt { return i }
        DVReport.shared.optionalFailed(Int.self, object: self, returning: 0)
        return 0
    }

    var optionalInt: Int? {
        if let i = self.checkInt { return i }
        DVReport.shared.optionalFailed(Int.self, object: self, returning: nil)
        return nil
    }

    var checkInt: Int? {
        if let i = self as? Int { return i }
        if let s = self as? String { return Int(s) }
        if let f = self as? Float { return Int(f) }
        if let d = self as? Double { return Int(d) }
        return nil
    }

    var float: Float {
        if let f = self.checkFloat { return f }
        DVReport.shared.optionalFailed(Float.self, object: self, returning: 0)
        return 0
    }

    var optionalFloat: Float? {
        if let f = self.checkFloat { return f }
        DVReport.shared.optionalFailed(Float.self, object: self, returning: nil)
        return nil
    }

    var checkFloat: Float? {
        if let f = self as? Float { return f }
        if let d = self as? Double { return Float(d) }
        if let i = self as? Int { return Float(i) }
        if let s = self as? String { return Float(s) }
        return nil
    }

    var double: Double {
        if let d = self.checkDouble { return d }
        DVReport.shared.optionalFailed(Double.self, object: self, returning: 0)
        return 0
    }

    var optionalDouble: Double? {
        if let d = self.checkDouble { return d }
        DVReport.shared.optionalFailed(Double.self, object: self, returning: nil)
        return nil
    }

    var checkDouble: Double? {
        if let d = self as? Double { return d }
        if let f = self as? Float { return Double(f) }
        if let i = self as? Int { return Double(i) }
        if let s = self as? String { return Double(s) }
        return nil
    }

    var date: Date {
        if let d = self.checkDate { return d }
        DVReport.shared.optionalFailed(Date.self, object: self, returning: Date())
        return Date()
    }

    var optionalDate: Date? {
        if let d = self.checkDate { return d }
        DVReport.shared.optionalFailed(Date.self, object: self, returning: nil)
        return nil
    }

    var checkDate: Date? {
        if let date = self as? Date { return date }
        if let string = self as? String {
            if let date = dateFormatter1.date(from: string) { return date }
            if let date = dateFormatter2.date(from: string) { return date }
        }
        return nil
    }
}
