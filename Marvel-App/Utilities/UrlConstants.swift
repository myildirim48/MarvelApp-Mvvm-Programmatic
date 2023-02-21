//
//  UrlConstants.swift
//  Marvel-App
//
//  Created by YILDIRIM on 8.02.2023.
//

import Foundation

let privateKey =  "7f7a5a99ff2e78bd0bc2c9ca93644cc2aafaf484"
let publicKey = "9d5431227aa300aefacef7b264100b0b"
let timeStamp = Date().timeIntervalSince1970

 func md5Creator() -> String{
    let md5 = "\(timeStamp)"+privateKey+publicKey
    return md5.MD5()
}

enum urlParams {
    static let apiKeyCons : String = "apikey"
    static let offset : String = "offset"
    static let timeStamp : String = "ts"
    static let hash : String = "hash"
    static let limit : String = "limit"
    static let forCharacterSearch : String = "nameStartsWith"
}


let baseScheme        : String = "https"
let baseHost          : String = "gateway.marvel.com"

enum urlPat {
    static let characters        : String = "/v1/public/characters"
}

enum UrlPath {
    case base
    case detail(String)
    case comics(String)
    case events(String)
    case series(String)
    case stories(String)
    
    var string: String {
        switch self {
        case .base: return "/v1/public/characters"
        case .detail(let id): return "/v1/public/characters/\(id)"
        case .comics(let id): return "/v1/public/characters/\(id)/comics"
        case .events(let id): return "/v1/public/characters/\(id)/events"
        case .series(let id): return "/v1/public/characters/\(id)/series"
        case .stories(let id): return "/v1/public/characters/\(id)/stories"
        }
    }
}


//let screenShotsPath   : String = "/api/games/"

