//
//  Characters.swift
//  Marvel-App
//
//  Created by YILDIRIM on 8.02.2023.
//

import Foundation
import CoreData

protocol Persistable {
    associatedtype ManagedObject: NSManagedObject
    init(managedObject: ManagedObject)
}

struct Characters: Codable {
    let id: Int
    let name, description: String
    let thumbnail: Thumbnail

    
}

extension Characters: Hashable, Equatable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
    
    static func == (lhs: Characters, rhs: Characters) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
    
}


