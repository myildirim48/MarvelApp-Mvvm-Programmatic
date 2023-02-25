//
//  DisplayableResource.swift
//  Marvel-App
//
//  Created by YILDIRIM on 19.02.2023.
//

import Foundation
protocol Displayable {
    func convert(type: Self) -> DisplayableResource
}

struct DisplayableResource {
    enum ResourceType {
        case comic, event, serie, story
    }
    
    let type : ResourceType
    let id : Int
    let title : String
    let description : String?
    let thumbnail : Thumbnail?
}

extension DisplayableResource : Hashable {
    static func == (lhs: DisplayableResource, rhs: DisplayableResource) -> Bool {
        lhs.type == rhs.type && lhs.id == rhs.id
    }
}
