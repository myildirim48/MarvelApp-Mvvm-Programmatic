//
//  Server.swift
//  Marvel-App
//
//  Created by YILDIRIM on 19.02.2023.
//

import Foundation
class Server {
    
    enum ServerError: Error, Equatable {
        case Unauthenticated(String)
    }
    
    typealias Keys = (public: String, private: String)?
    
    public var baseURL: URL
    
    private var _auth: Auth? = nil
    
    init(baseURL: URL = URL(string: "https://gateway.marvel.com")!) {
        self.baseURL = baseURL
        self._auth = Auth()
    }
    
    private func authQueryItems() throws -> [Query] {
        guard let parameters = _auth?.parameters else {
            throw ServerError.Unauthenticated("Attempting to authenticate request without a valid Auth instance.")
        }
        return parameters
    }
    
    // MARK: - Character Requests
    
    /// CharacterRequest for Characters
    /// - Parameter : Public Characters
    /// - Returns: Authenticated request with matching Character type
    func characterRequest() throws -> CharacterRequest<Characters>{
        return CharacterRequest(baseURL, path: .base, auth: try authQueryItems())
    }
    
    /// CharacterRequest for Characters
    /// - Parameter id: String identifier of character
    /// - Returns: Authenticated request with matching Character type
    func characterDetailRequest(id: Int) throws -> CharacterRequest<Characters> {
        return CharacterRequest(baseURL, path: .detail(id.toString()), auth: try authQueryItems())
    }
    /// CharacterRequest for Comics
    /// - Parameter id: String identifier of character
    /// - Returns: Authenticated request with matching Comic model type
    func characterComicsRequest(id: String) throws -> CharacterRequest<Comics> {
        return CharacterRequest(baseURL, path: .comics(id), auth: try authQueryItems())
    }
    /// CharacterRequest for Events
    /// - Parameter id: String identifier of character
    /// - Returns: Authenticated request with matching Event model type
    func characterEventRequest(id: String) throws -> CharacterRequest<Event> {
        return CharacterRequest(baseURL, path: .events(id), auth: try authQueryItems())
    }
    
    /// CharacterRequest for Serie
    /// - Parameter id: String identifier of character
    /// - Returns: Authenticated request with matching Serie model type
    func characterSerieRequest(id: String) throws -> CharacterRequest<Serie> {
        return CharacterRequest(baseURL, path: .series(id), auth: try authQueryItems())
    }
    
    /// CharacterRequest for Storie
    /// - Parameter id: String identifier of character
    /// - Returns: Authenticated request with matching Storie model type
    func characterStorieRequest(id: String) throws -> CharacterRequest<Storie> {
        return CharacterRequest(baseURL, path: .stories(id), auth: try authQueryItems())
    }
}

extension Server {
    struct Auth {
        private var hash = md5Creator()
        var parameters: [Query]?
        
        init(hash: String = md5Creator(), parameters: [Query]? = nil) {
            self.hash = hash
            self.parameters = [.ts("\(timeStamp)"),.apikey(publicKey),.hash(hash)]
        }
    }

}
