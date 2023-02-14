//
//  EndPoints.swift
//  Marvel-App
//
//  Created by YILDIRIM on 8.02.2023.
//

import UIKit

struct EndPoints {
    let path: String
    var queryItems: [URLQueryItem]
}
extension EndPoints {
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = baseScheme
        components.host = baseHost
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
    
    //Base with ts,api,hash,page
    static func urlQueryBase(with offset: Int) -> [URLQueryItem]{
        return [URLQueryItem(name: urlParams.timeStamp, value: String(ts)),
                URLQueryItem(name: urlParams.apiKeyCons, value: apiKey),
                URLQueryItem(name: urlParams.hash, value: md5Creator()),
                URLQueryItem(name: urlParams.offset, value:String(offset))]
    }
    
    static func charactersUrl(offset: Int) -> EndPoints {
        return EndPoints(path: urlPaths.characters, queryItems: EndPoints.urlQueryBase(with: offset))
    }
    
    //Comics Url
    static func comicsUrl(offset:Int) -> EndPoints {
        return EndPoints(path: urlPaths.comics, queryItems: EndPoints.urlQueryBase(with: offset))
    }
}

