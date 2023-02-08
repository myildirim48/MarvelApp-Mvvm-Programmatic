//
//  NetworkManager.swift
//  Marvel-App
//
//  Created by YILDIRIM on 8.02.2023.
//

import Foundation
class NetworkManager {
    static let shared = NetworkManager()
    
    let decoder = JSONDecoder()
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func getDataGeneric<T:Codable>(for request:EndPoints, data:T.Type) async throws -> T {
        let url = request.url
        
        guard let url = url else {
            throw marvelError.invalidUsername
        }
        let  (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw marvelError.invalidResponse
        }
        do{
            return try decoder.decode(T.self, from: data)
        }catch {
            throw marvelError.invalidData
        }
    }
}
