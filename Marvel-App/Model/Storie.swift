//
//  Storie.swift
//  Marvel-App
//
//  Created by YILDIRIM on 22.02.2023.
//

import Foundation
struct Storie:Codable {
    let id: Int
    let title: String
    let description: String?
    let type: String?
    let modified: String?
    let thumbnail: Thumbnail?
}

extension Storie: Hashable, Equatable {
    
    static func == (lhs: Storie, rhs: Storie) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
    }
}
extension Storie: Displayable {
    func convert(type: Storie) -> DisplayableResource {
        DisplayableResource(type: .story, id: id, title: title, description: description, thumbnail: thumbnail)
    }
    
}
