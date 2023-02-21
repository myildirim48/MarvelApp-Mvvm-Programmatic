//
//  CharacterRequest.swift
//  Marvel-App
//
//  Created by YILDIRIM on 19.02.2023.
//

import Foundation

protocol Request {
    associatedtype RequestDataType
    associatedtype ResponseDataType
    func composeRequest(with data: RequestDataType) throws -> URLRequest
    func parse(data:Data?) throws -> ResponseDataType
}

struct CharacterRequest<A:Codable>: Request{
    
    typealias ResponseDataType = Response<DataContainer<A>>
    
    enum Path {
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
    
    let baseURL: URL
    let path: Path
    let auth: [Query]?
    
    init(_ baseURL: URL, path: Path, auth: [Query]?) {
        self.baseURL = baseURL
        self.path = path
        self.auth = auth
    }
    
    func composeRequest(with paramaters: [Query] = []) throws -> URLRequest {
        let queryItems = auth == nil ? paramaters : paramaters + auth!
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        components.path = path.string
        components.queryItems = queryItems.toItems()
        return URLRequest(url: components.url!)
    }
    
    func parse(data: Data?) throws -> ResponseDataType {
        return try JSONDecoder().decode(ResponseDataType.self, from: data!)
    }
}

