//
//  Event.swift
//  Marvel-App
//
//  Created by YILDIRIM on 22.02.2023.
//

import Foundation
struct Event: Codable {
    let id: Int
    let title: String
    let description: String?
    let modified: String?
    let start: String?
    let end: String?
    let thumbnail: Thumbnail
}
extension Event: Hashable, Equatable {
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
    }
}

extension Event: Displayable {
    func convert(type: Event) -> DisplayableResource {
        DisplayableResource(type: .comic, id: id, title: title, description: description, thumbnail: thumbnail)
    }
    
}
