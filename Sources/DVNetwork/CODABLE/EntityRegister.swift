//
//  File.swift
//  
//
//  Created by David Vallas on 4/18/20.
//

import Foundation
import CoreData

class EntityRegister {
    private var datas: Dictionary<String, EntityData> = [:]
    
    static let shared = EntityRegister()
    
    func data(_ entityName: String) throws -> EntityData {
        if let d = datas[entityName] { return d }
        throw CDError.notRegistered(key: entityName)
    }

    func register<T: Entity>(_ entity: T.Type) throws {
        let ref = T.init()
        let data = try EntityData(entity: ref)
        datas[ref.entityName] = data
    }
}

extension EntityRegister {
    
}
