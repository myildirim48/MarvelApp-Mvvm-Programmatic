//
//  DetailVm.swift
//  Marvel-App
//
//  Created by YILDIRIM on 22.02.2023.
//

import Foundation

protocol HeroDetailViewModelDelegate: NSObject{
    func viewModelDidReceiveError(error: UserFriendlyError)
    func viewModelDidTogglePersistence(with status: Bool)
}

class DetaiLVM: NSObject {
    
    enum State { case memory, persisted }
    
    var character: Characters!  {
        didSet {
            state = character.thumbnail?.data == nil ? .memory : .persisted
            configure()
        }
    }
    
    private(set) var state: State = .memory
    
    let environment: Environment!
    var datasource: ResourceDataSource! = nil
    var detailViewRequestManager: CharacterRequestManager?
    
    weak var delegate : HeroDetailViewModelDelegate?
    
    init(environment: Environment,state: State = .memory) {
        self.state = state
        self.environment = environment
        super.init()
    }
    
    private func configure(){
        detailViewRequestManager = CharacterRequestManager(server: environment.server, delegate : self)
        detailViewRequestManager!.configureResourceRequest(with: character.id)
        detailViewRequestManager!.requestCharacterData()
    }
    
    func applyDatasourceChange(section: ResourceDataSource.Section, resources: [DisplayableResource]){
        guard !resources.isEmpty else { return }
        
        var snapshot = datasource.snapshot()
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections(ResourceDataSource.Section.allCases)
        }
        snapshot.appendItems(resources,toSection: section)
        datasource.apply(snapshot,animatingDifferences: false)
    }
    
    func toggleCharacterPersistence(with message: StateChangeMessage, data: Data?) {
        environment.store.toggleStorage(for: message.character, with: data) { [weak self] status in
            guard status, let self = self, let delegate = self.delegate else { return }
            delegate.viewModelDidTogglePersistence(with: status)
        }
    }
    
    func composeStateChangeMessage() -> StateChangeMessage? {
        guard let character = character else { return nil }
        let message: StateChangeMessage!
        
        switch state {
        case .memory: message = .deleteCharacter(.memory, with:character)
        case .persisted: message = .deleteCharacter(.persisted,with: character)
        }
        
        return message
    }
}

extension DetaiLVM: CharacterRequestManagerDelegate {
    
    func requestManagerDidRecieveData(for section: ResourceDataSource.Section, data: [DisplayableResource]) {
        applyDatasourceChange(section: section, resources: data)
    }
    
    func requestManagerDidReceiveError(userFriendlyError: UserFriendlyError) {
        delegate?.viewModelDidReceiveError(error: userFriendlyError)
    }
}
