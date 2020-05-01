//
//  File.swift
//  
//
//  Created by David Vallas on 4/18/20.
//

import Foundation

public extension UserDefaults {
    /// switches key names for object in standard user defaults
    func switchKeys(old: String, new: String) {
        let value = self.value(forKey: old)
        self.setValue(value, forKey: new)
        self.removeObject(forKey: old)
    }
}

