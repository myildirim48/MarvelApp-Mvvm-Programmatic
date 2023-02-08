//
//  Responses.swift
//  Marvel-App
//
//  Created by YILDIRIM on 8.02.2023.
//

import Foundation
class Responses {
    static let shared = Responses()
    
    //CharactersDataFetching
    func fetchCharacters(page:Int){
        Task {
            let data = try await NetworkManager.shared.getDataGeneric(for: EndPoints.charactersUrl(page: page), data: GameDetail.self)
        }
    }
}
