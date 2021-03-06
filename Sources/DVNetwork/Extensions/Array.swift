//
//  File.swift
//  
//
//  Created by David Vallas on 4/17/20.
//

import Foundation

public extension Array {
    
    /// safe way to transform an array to a set
    func mapToSet<T: Hashable>(_ transform: (Element) -> T) -> Set<T> {
        var result = Set<T>()
        for item in self {
            result.insert(transform(item))
        }
        return result
    }
    
    /// unsafe way to transform an array to a set, assumes that collection has been validated as Hashable
    func unsafeMapToSet<T>(_ transform: (Element) -> T) -> Set<T> {
        var result = Set<T>()
        for item in self {
            result.insert(transform(item))
        }
        return result
    }
    
}
