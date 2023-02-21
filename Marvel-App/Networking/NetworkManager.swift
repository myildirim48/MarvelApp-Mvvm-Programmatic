//
//  NetworkManager.swift
//  Marvel-App
//
//  Created by YILDIRIM on 8.02.2023.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    let imgCache = NSCache<NSString,UIImage>()
    
    let decoder = JSONDecoder()
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func getDataGeneric<T:Codable>(for request: EndPoints, data:T.Type) async throws -> T {
        let url = request.url
        print(url!)
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
    
    //DownloadImage
    func downloadImage(from urlString:String) async -> UIImage? {
        
        //Checks cache if the image is already downloaded its return the image
        let cacheKey = NSString(string: urlString)
        if let image = imgCache.object(forKey: cacheKey){ return image }
        
        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            self.imgCache.setObject(image, forKey: cacheKey) //Addes image to cache
            return image
        }catch {
            return nil
        }
    }
}
