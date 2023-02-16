//
//  Characters.swift
//  Marvel-App
//
//  Created by YILDIRIM on 8.02.2023.
//

import Foundation

struct CharacterResponse: Codable{
    let data: CharacterData
}

// MARK: - DataClass
struct CharacterData: Codable{
    let total, count: Int
    let results: [CharacterModel]
}

// MARK: - Result
struct CharacterModel: Codable,Hashable {
    let id: Int
    let name, description: String
    let thumbnail: Thumbnail
    
    static func == (lhs: CharacterModel, rhs: CharacterModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.thumbnail == rhs.thumbnail &&
               lhs.description == rhs.description
    }
    
}

