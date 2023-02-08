//
//  UrlConstants.swift
//  Marvel-App
//
//  Created by YILDIRIM on 8.02.2023.
//

import Foundation

let privateKey =  "7f7a5a99ff2e78bd0bc2c9ca93644cc2aafaf484"
let apiKey = "9d5431227aa300aefacef7b264100b0b"
let ts = Date().timeIntervalSince1970

 func md5Creator() -> String{
    let md5 = "\(ts)"+privateKey+apiKey
    return md5.MD5()
}

enum urlParams {
    static let apiKeyCons : String = "apikey"
    static let page : String = "page"
    static let timeStamp : String = "ts"
    static let hash : String = "hash"
}


let baseScheme        : String = "https"
let baseHost          : String = "gateway.marvel.com"

enum urlPaths {
   static let characters        : String = "/v1/public/characters"
}


//let screenShotsPath   : String = "/api/games/"

