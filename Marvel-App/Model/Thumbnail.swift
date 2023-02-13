//
//  Thumbnail.swift
//  Marvel-App
//
//  Created by YILDIRIM on 13.02.2023.
//

import Foundation

struct Thumbnail: Codable, Hashable {
    let path: String
    let ext: String

    static func == (lhs: Thumbnail, rhs: Thumbnail) -> Bool {
        return lhs.path == rhs.path && lhs.ext == rhs.ext
    }
    
    
    enum CodingKeys: String, CodingKey {
        case path
        case ext = "extension"
    }
    
    var fullUrlWithExt: String {
        get { return path + "." + ext }
    }

}
