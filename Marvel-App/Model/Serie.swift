//
//  Serie.swift
//  Marvel-App
//
//  Created by YILDIRIM on 22.02.2023.
//

import Foundation
struct Serie:Codable {
    let id: Int
    let title: String
    let description: String?
    let startYear: Int?
    let endYear: Int?
    let rating: String?
    let modified: String?
    let thumbnail: Thumbnail
}

extension Serie: Hashable, Equatable {
    
    static func == (lhs: Serie, rhs: Serie) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
    }
}

extension Serie: Displayable {
    func convert(type: Serie) -> DisplayableResource {
        DisplayableResource(type: .comic, id: id, title: title, description: description, thumbnail: thumbnail)
    }
    
}
