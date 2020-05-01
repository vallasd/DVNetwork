//
//  File.swift
//  
//
//  Created by David Vallas on 4/20/20.
//

import Foundation

extension UUID {
    static func decodeJSON(_ any: Any) -> UUID? {
        guard let s = any as? String else { return nil }
        return UUID(uuidString: s)
    }
    
    static func encodeJSON(_ uuid: UUID) -> String {
        return uuid.uuidString
    }
}
