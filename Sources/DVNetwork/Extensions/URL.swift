//
//  File.swift
//  
//
//  Created by David Vallas on 4/20/20.
//

import Foundation

extension URL {
    static func decodeJSON(_ any: Any) -> URL? {
        guard let s = any as? String else { return nil }
        return URL(string: s)
    }
    
    static func encodeJSON(_ url: URL) -> String {
        return url.absoluteString
    }
}
