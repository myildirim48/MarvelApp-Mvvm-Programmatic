//
//  NetworkResponse.swift
//  Marvel-App
//
//  Created by YILDIRIM on 17.02.2023.
//

import Foundation
struct NetworkResponse<Wrapped: Codable> : Codable{
    
    let data: ResponseData
    
    struct ResponseData: Codable{
        let total,offset, count: Int
        let results: [Wrapped]
    }
}


