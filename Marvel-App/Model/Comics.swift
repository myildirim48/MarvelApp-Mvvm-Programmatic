//
//  Comics.swift
//  Marvel-App
//
//  Created by YILDIRIM on 12.02.2023.
//

import Foundation

// MARK: - Result
struct Comics: Codable {
    let id: Int
    let title: String
    let description: String?
    let pageCount: Int
    let thumbnail: Thumbnail
}

extension Comics: Hashable, Equatable {
    
    static func == (lhs: Comics, rhs: Comics) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
    }
}

extension Comics: Displayable {
    func convert(type: Comics) -> DisplayableResource {
        DisplayableResource(type: .comic, id: id, title: title, description: description, thumbnail: thumbnail)
    }
    
}


