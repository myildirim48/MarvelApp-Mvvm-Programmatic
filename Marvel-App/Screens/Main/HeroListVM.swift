//
//  MainViewModel.swift
//  Marvel-App
//
//  Created by YILDIRIM on 20.02.2023.
//

import Foundation

protocol HeroListViewModelErrorHandler: NSObject {
    func viewModelDidReceiveError(error: UserFriendlyError)
}

class HeroListVM : NSObject{

    enum State { case ready, loading }

    private let environment: Environment
    private var state: State = .ready

    private var request : CharacterRequest<Characters>!
    private var requestLoader : RequestLoader<CharacterRequest<Characters>>!
    private var dataContainer : DataContainer<Characters>?
    
    private var dataSource : HeroDataSource?
    
    weak var errorHandler: HeroListViewModelErrorHandler?
    
    init(environment: Environment) {
        self.environment = environment
        super.init()
        
        request = try? environment.server.characterRequest()
        requestLoader = RequestLoader(request: request)
    }
    
    func configureDataSource(with dataSource: HeroDataSource){
        self.dataSource = dataSource
        configureDataSource()
    }
    
    // MARK: - Pagination
    
    private let defaultPageSize = 20
    private let defaultPrefetchBuffer = 1
    
    private var requestOffset: Int {
        guard let co = dataContainer else {
            return 0
        }
        let newOffset = co.offset + defaultPageSize
        return newOffset >= co.total ? co.offset : newOffset
    }
    
    private var hasNextPage: Bool {
        guard let co = dataContainer else {
            return true
        }
        let newOffset = co.offset + defaultPageSize
        return newOffset >= co.total ? false : true
    }
    
    //MARK: - Data Source
    
    func item(for indexPath: IndexPath) -> Characters? {
        dataSource?.itemIdentifier(for: indexPath)
    }
    
    private func appendDataSource(with characters: [Characters]) {
        guard let dataSource = dataSource else { return }
        defer { state = .ready }

        var currentSnapshot = dataSource.snapshot()
        currentSnapshot.appendItems(characters, toSection: .main)
        apply(currentSnapshot)
    }
    
    private func reloadDataSource(with character: Characters){
        guard let dataSource = dataSource else { return }
        defer { state = .ready }
        
        var snapShot = dataSource.snapshot()
        if snapShot.itemIdentifiers.contains(character) {
            snapShot.reloadItems([character])
            apply(snapShot)
        }
    }
    
    
    private func configureDataSource(){
        var initialSnapshot = HeroSnapShot()
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems([],toSection: .main)
        apply(initialSnapshot, animating: false)
    }
    
    private func apply(_ changes: HeroSnapShot, animating: Bool = true){
        DispatchQueue.main.async {
            self.dataSource?.apply(changes, animatingDifferences: animating)
        }
    }
    
    //MARK: - Data Fetch
    
    func shouldFetchData(index: Int){
        guard let dataSource = dataSource else { return }
        let currentSnapshot = dataSource.snapshot()
        
        guard currentSnapshot.numberOfItems == (index + defaultPrefetchBuffer) && hasNextPage && state == .ready else { return }
        requestData()
    }
    
    func requestData() {
        guard state == .ready else { return }
        state = .loading
        
        let offsetQuery: [Query] = [.offset(String(requestOffset))]
        
        requestLoader.load(data: offsetQuery) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let container):
                self.dataContainer = container.data
                self.appendDataSource(with: container.data.results)
            case .failure(let error):
                guard let handler = self.errorHandler else { return }
                handler.viewModelDidReceiveError(error: .userFriendlyError(error))
            }
        }
    }
}


