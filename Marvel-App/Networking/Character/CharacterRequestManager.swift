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
    weak var delegate :CharacterRequestManagerDelegate?
    
    var comicRequest : CharacterRequest<Comics>!
    var storiesRequest: CharacterRequest<Storie>!
    var eventRequest: CharacterRequest<Event>!
    var serieRequest: CharacterRequest<Serie>!
    
    var comicRequestLoader : RequestLoader<CharacterRequest<Comics>>!
    var storieRequestLoader : RequestLoader<CharacterRequest<Storie>>!
    var eventRequestLoader : RequestLoader<CharacterRequest<Event>>!
    var serieRequestLoader : RequestLoader<CharacterRequest<Serie>>!
    
    init(server: Server,delegate: CharacterRequestManagerDelegate) {
        self.server = server
        self.delegate = delegate
    }
    
    func configureResourceRequest(with characterId: Int) {
        
        comicRequest = try? server.characterComicsRequest(id: characterId.toString())
        storiesRequest = try? server.characterStorieRequest(id: characterId.toString())
        eventRequest = try? server.characterEventRequest(id: characterId.toString())
        serieRequest = try? server.characterSerieRequest(id: characterId.toString())
        
        comicRequestLoader = RequestLoader(request: comicRequest)
        storieRequestLoader = RequestLoader(request: storiesRequest)
        eventRequestLoader = RequestLoader(request: eventRequest)
        serieRequestLoader = RequestLoader(request: serieRequest)
        
    }
    
    func requestCharacterData(){
        requestComicsData()
        requestStorieData()
        requestEventsData()
        requestSerieData()
    }
    
    private func requestComicsData(){
        comicRequestLoader.load(data: []) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                self.delegate?.requestManagerDidRecieveData(for: .comics, data: response.data.results.toDisplayable())
                return
            case let .failure(error):
                self.delegate?.requestManagerDidReceiveError(userFriendlyError: .userFriendlyError(error))
                return
            }
        }
    }
    
    private func requestStorieData(){
        storieRequestLoader.load(data: []) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                self.delegate?.requestManagerDidRecieveData(for: .stories, data: response.data.results.toDisplayable())
                return
            case let .failure(error):
                self.delegate?.requestManagerDidReceiveError(userFriendlyError: .userFriendlyError(error))
                print("hello")
                return
            }
        }
        
    }
    
    private func requestEventsData() {
        eventRequestLoader.load(data: []) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                self.delegate?.requestManagerDidRecieveData(for: .events, data: response.data.results.toDisplayable())
                return
            case let .failure(error):
                self.delegate?.requestManagerDidReceiveError(userFriendlyError: .userFriendlyError(error))
                return
            }
        }
    }
    private func requestSerieData() {
        serieRequestLoader.load(data: []) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                self.delegate?.requestManagerDidRecieveData(for: .series, data: response.data.results.toDisplayable())
                return
            case let .failure(error):
                self.delegate?.requestManagerDidReceiveError(userFriendlyError: .userFriendlyError(error))
                return
            }
        }
    }
}
