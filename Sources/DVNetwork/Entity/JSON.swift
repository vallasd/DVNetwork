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

public typealias JSON = Any
public typealias JSONDict = Dictionary<String, JSON>
public typealias JSONArray = [JSON]
public typealias JSONSet = Set<AnyHashable>


func isSame(_ json1: JSON, _ json2: JSON) -> Bool {
    if let h1 = json1 as? AnyHashable, let h2 = json2 as? AnyHashable { return h1 == h2 }
    if let d1 = json1 as? JSONDict, let d2 = json2 as? JSONDict { return isSame(d1, d2) }
    if let a1 = json1 as? JSONArray, let a2 = json2 as? JSONArray { return isSame(a1, a2) }
    #if DEBUG
        print("|isSame Error| does not know how to compare")
    #endif
    return false
}

func isSame(_ dict1: JSONDict, _ dict2: JSONDict) -> Bool {
    let keys1 = dict1.keys, keys2 = dict2.keys
    if keys1.count != keys2.count {
        #if DEBUG
        var set1 = Set<String>()
        var set2 = Set<String>()
        set1.formUnion(keys1.map { $0 as String })
        set2.formUnion(keys2.map { $0 as String })
        if keys1.count > keys2.count {
            set1.subtract(set2)
            print("|isSame Error| key count different |\(set1.sorted())|")
            print(keys1.map {$0 as String }.sorted())
            print(keys2.map {$0 as String }.sorted())
        }
        if keys2.count > keys1.count {
            set2.subtract(set1)
            print("|isSame Error| key count different |\(set2.sorted())|")
            print(keys1.map {$0 as String }.sorted())
            print(keys2.map {$0 as String }.sorted())
        }
        #endif
        return false
    }
    for key in keys1 {
        if !keys2.contains(key) {
            #if DEBUG
                print("|isSame Error| key: |\(key)| not found")
            #endif
            return false
        }
        let value1 = dict1[key], value2 = dict2[key]
        let result = isSame(value1 as JSON, value2 as JSON)
        if result == false {
            #if DEBUG
                print("|isSame Error| key different: |\(key)| value1: |\(value1!)| value2: |\(value2!)|")
            #endif
            return result
        }
    }
    return true
}

func isSame(_ array1: JSONArray, _ array2: JSONArray) -> Bool {
    if array1.count != array2.count {
        #if DEBUG
            print("|isSame Error| array count different")
        #endif
        return false
    }
    let result = sort(array1, array2)
    return isSameArray(result.a1, result.a2)
}

func sort(_ array1: JSONArray, _ array2: JSONArray) -> (a1: JSONArray, a2: JSONArray) {
    if array1.count == 0 { return (array1, array2) }
    if let result = sorted(array1, array2, Int.self) { return result }
    if let result = sorted(array1, array2, String.self) { return result }
    if let result = sorted(array1, array2, Double.self) { return result }
    if let result = sorted(array1, array2, Date.self) { return result }
    return (array1, array2)
}

func sorted<T: Comparable>(_ array1: JSONArray, _ array2: JSONArray, _ type: T.Type) -> (a1: [T], a2: [T])? {
    if let _ = array1.first! as? T {
        var a1: [T] = []
        var a2: [T] = []
        for index in 0..<array1.count {
            guard let i1 = array1[index] as? T else { return nil }
            guard let i2 = array2[index] as? T else { return nil }
            a1.append(i1)
            a2.append(i2)
        }
        return (a1.sorted(), a2.sorted())
    }
    return nil
}

func isSameArray(_ a1: [Any], _ a2: [Any]) -> Bool {
    for index in 0..<a1.count {
        let value1 = a1[index], value2 = a2[index]
        let result = isSame(value1, value2)
        if result == false {
            #if DEBUG
                print("|isSame Error| array different at index: |\(index)|")
            #endif
            return result
        }
    }
    return true
}
