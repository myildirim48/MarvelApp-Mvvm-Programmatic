//
//  Query.swift
//  Marvel-App
//
//  Created by YILDIRIM on 19.02.2023.
//

import Foundation
struct Query:Equatable,Hashable {
    let name: String
    let value: String
}

extension Query {
    func item() -> URLQueryItem {
        URLQueryItem(name: name, value: value)
    }
    
    static func ts(_ value: String) -> Query {
        Query(name: "ts", value: value)
    }
    
    static func apikey(_ value: String) -> Query {
        Query(name: "apikey", value: value)
    }
    
    static func hash(_ value: String) -> Query {
        Query(name: "hash", value: value)
    }
    
    static func offset(_ value: String) -> Query {
        Query(name: "offset", value: value)
    }
    
    static func nameStartsWith(_ value: String) -> Query {
        Query(name: "nameStartsWith", value: value)
    }
}
