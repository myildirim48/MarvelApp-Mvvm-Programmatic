//
//  CharacterRequestManager.swift
//  Marvel-App
//
//  Created by YILDIRIM on 19.02.2023.
//

import Foundation

protocol CharacterRequestManagerDelegate: NSObject {
    func requestManagerDidRecieveData(for section: ResourceDataSource.Section, data: [DisplayableResource])
    func requestManagerDidReceiveError(userFriendlyError:UserFriendlyError)
}

class CharacterRequestManager {
    
    let server: Server!
    
    var comicRequest : CharacterRequest<Comics>!
    
    var comicRequestLoader : RequestLoader<CharacterRequest<Comics>>!
    
    init(server: Server) {
        self.server = server
    }
    
    func configureResourceRequest(with characterId: Int) {
        
        comicRequest = try? server.characterComicsRequest(id: characterId.toString())
        
        comicRequestLoader = RequestLoader(request: comicRequest)
        
    }
    
    private func requestComicsData(){
        comicRequestLoader.load(data: []) { [weak self] result in
            switch result {
            case let .success(result):
                
                return
            case let .failure(error):
                
                return
            }
        }
    }
}
