//
//  EndPoints.swift
//  Marvel-App
//
//  Created by YILDIRIM on 8.02.2023.
//

import UIKit

struct EndPointsStruct {
    let path: String
    var queryItems: [URLQueryItem]
}
extension EndPointsStruct {
    
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
    
    static func charactersUrl(offset: Int) -> EndPointsStruct {
        return EndPointsStruct(path: urlPaths.characters, queryItems: EndPointsStruct.urlQueryBase(with: offset))
    }
    
    //Comics Url
    static func comicsUrl(offset:Int) -> EndPointsStruct {
        return EndPointsStruct(path: urlPaths.comics, queryItems: EndPointsStruct.urlQueryBase(with: offset))
    }
}

enum EndpointEnum {
    //Character Url
//    static func charactersUrl(offset: Int) -> EndPointsStruct {
//        return EndPointsStruct(path: urlPaths.characters, queryItems: EndPointsStruct.urlQueryBase(with: offset))
//    }
//    
//    //Comics Url
//    static func comicsUrl(offset:Int) -> EndPointsStruct {
//        return EndPointsStruct(path: urlPaths.comics, queryItems: EndPointsStruct.urlQueryBase(with: offset))
//    }
}

