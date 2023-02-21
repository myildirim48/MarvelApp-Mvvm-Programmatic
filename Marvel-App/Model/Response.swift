//
//  NetworkResponse.swift
//  Marvel-App
//
//  Created by YILDIRIM on 17.02.2023.
//

import Foundation
struct Response<A: Codable> : Codable{
    let code: Int
    let status: String?
    let message: String?
    let data: A

}
struct DataContainer<A: Codable>: Codable{
    let total,offset, count: Int
    let results: [A]
}


