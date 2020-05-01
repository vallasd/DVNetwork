//
//  Date.swift
//  
//
//  Created by David Vallas on 4/16/20.
//

import Foundation

//// we are making an external var because creating a date formatter can be expensive if done a lot
//fileprivate var dateFormatter1: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "yyyy-MM-dd"
//    return formatter
//}()
//
//// we are making an external var because creating a date formatter can be expensive if done a lot
//fileprivate var dateFormatter2: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//    return formatter
//}()

// we are making an external var because creating a date formatter can be expensive if done a lot
fileprivate var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    return formatter
}()

public extension Date {
    
    static func decodeJSON(_ any: Any) -> Date? {
        guard let s = any as? String else { return nil }
        return dateFormatter.date(from: s)
    }
    
    var encodeJSON: JSON {
        return dateFormatter.string(from: self)
    }
}
