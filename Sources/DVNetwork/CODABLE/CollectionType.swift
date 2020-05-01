//
//  File.swift
//  
//
//  Created by David Vallas on 4/21/20.
//

import Foundation

enum CollectionType {
    case array
    case set
    case single
    
    init(value: Any) {
        let t = String(describing: type(of: value))
        let c = t.hasPrefix("Optional<") ? String(t.dropFirst(9)) : t
        if c.hasPrefix("Array") { self = .array }
        else if c.hasPrefix("Set") { self = .set }
        else { self = .single }
    }
}
