//
//  DetailVm.swift
//  Marvel-App
//
//  Created by YILDIRIM on 22.02.2023.
//

import UIKit
protocol HeroDetailViewModelDelegate: NSObject{
    func viewModelDidReceiveError(error: UserFriendlyError)
}

class DetaiLVM: NSObject {
    
    var character: Characters!  {
        didSet {
            configure()
        }
    }
    
    let environment: Environment!
    var datasource: ResourceDataSource! = nil
    var detailViewRequestManager: CharacterRequestManager?
    
    weak var delegate : HeroDetailViewModelDelegate?
    
    init(environment:Environment) {
        self.environment = environment
        super.init()
    }
    
    private func configure(){
        detailViewRequestManager = CharacterRequestManager(server: environment.server, delegate : self)
        detailViewRequestManager?.configureResourceRequest(with: character.id)
        detailViewRequestManager?.requestCharacterData()
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
}

extension DetaiLVM: CharacterRequestManagerDelegate {
    
    func requestManagerDidRecieveData(for section: ResourceDataSource.Section, data: [DisplayableResource]) {
        applyDatasourceChange(section: section, resources: data)
    }
    
    func requestManagerDidReceiveError(userFriendlyError: UserFriendlyError) {
        delegate?.viewModelDidReceiveError(error: userFriendlyError)
    }
    
    
}
