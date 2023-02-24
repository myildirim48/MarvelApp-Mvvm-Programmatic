//
//  SearchResultVM.swift
//  Marvel-App
//
//  Created by YILDIRIM on 21.02.2023.
//

import Foundation

protocol SearchResultVMErrorHandler: AnyObject {
    func viewModelDidReceiveError(error: UserFriendlyError)
}
protocol SearchResultVMInformatinHandler: NSObject {
    func presentSearchActivitty()
    func presentSearchResult(with count:Int)
}

class SearchResultVM : NSObject {
    private enum State { case ready, loading }
    
    private let environment: Environment!
    private var state: State = .ready
    
    private let request : CharacterRequest<Characters>!
    private var requestLoader: RequestLoader<CharacterRequest<Characters>>!
    private let debouncer : Debouncer = Debouncer(minimumDelay: 0.5)
    
    private var currentSearchResult: SearchResult?
    private var searchDataSource: HeroDataSource?
    
    weak var errorHandler: SearchResultVMErrorHandler?
    weak var infoHandler: SearchResultVMInformatinHandler?
    
    //MARK: - init
    init(environment: Environment) {
        self.environment = environment
        self.request = try? environment.server.characterRequest()
        super.init()
        
        requestLoader = RequestLoader(request: request)
    }
    
    func configureDataSource(with dataSource: HeroDataSource){
        searchDataSource = dataSource
        configureDataSource()
    }
    //MARK: - Pagination
    private let defaultPageSize = 20
    private let defaultPrefetchBuffer = 1
    
    func requestOffsetForInput(_ text: String) -> Int{
        guard let cs = currentSearchResult, text == cs.query.input.value else {
            return 0
        }
        
        let currentOffset = Int(cs.query.offset.value)!
        let newOffset = currentOffset + defaultPageSize
        return newOffset >= cs.total ? currentOffset : newOffset
    }
    
    func composeNextPageSearchQuery() -> SearchQuery? {
        guard let csi = currentSearchResult?.query.input.value else { return nil }
        
        let searchQuery = SearchQuery(offset: .offset(requestOffsetForInput(csi).toString()), input: .nameStartsWith(csi))
        guard searchQuery != currentSearchResult?.query else { return nil }
        return searchQuery
    }
    
    func composeSearchQuery(with text: String) -> SearchQuery? {
        guard text != currentSearchResult?.query.input.value else { return nil }
        
        let searchQuery = SearchQuery(offset: .offset(requestOffsetForInput(text).toString()), input: .nameStartsWith(text))
        guard searchQuery != currentSearchResult?.query else { return nil}
        return searchQuery
    }

    //MARK: - Data Fetch
    
    func performSearch(with text: String){
        debouncer.debounce { [unowned self] in
            guard let newSearchQuery = self.composeSearchQuery(with: text) else { return }
            
            self.infoHandler?.presentSearchActivitty()
            self.requestWithQuery(searchQuery: newSearchQuery)
        }
    }
    
    func requestWithQuery(searchQuery: SearchQuery) {
        state = .loading
        
        self.requestLoader.load(data: [searchQuery.offset,searchQuery.input]) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.updateSearchResult(with: SearchResult(total: response.data.total, query: searchQuery), data: response.data.results)
            case .failure(let error):
                self.state = .ready
                self.errorHandler?.viewModelDidReceiveError(error: .userFriendlyError(error))
            }
        }
    }
    
    func shouldFetchData(index:Int){
        guard let dataSource = searchDataSource else { return }
        let currentSnapshot = dataSource.snapshot()
        
        guard currentSnapshot.numberOfItems == (index + defaultPrefetchBuffer)
                && state == .ready,
                let searchQuery = composeNextPageSearchQuery() else { return }
        requestWithQuery(searchQuery: searchQuery)
    }
    
    //MARK: - Data Source
    func item(for indexPath: IndexPath) -> Characters? {
        searchDataSource?.itemIdentifier(for: indexPath)
    }
    
    func updateSearchResult(with result: SearchResult, data: [Characters]){
        guard let dataSource = searchDataSource else { return  }
        state = .ready
        
        var currentSnapshot = dataSource.snapshot()
        if result.query.input == currentSearchResult?.query.input{
            currentSnapshot.appendItems(data,toSection: .main)
        }else if !data.isEmpty {
            currentSnapshot = HeroSnapShot()
            currentSnapshot.appendSections([.main])
            currentSnapshot.appendItems(data)
        }
        
        currentSearchResult = result
        updateSearchResultLabel(result.total)
        apply(currentSnapshot)
        
    }
    
    private func reloadDataSource(with character: Characters){
        guard let dataSource = searchDataSource else { return }
        
        defer { state = .ready }
        
        var snapshot = dataSource.snapshot()
        if snapshot.itemIdentifiers.contains(character){
            snapshot.reloadItems([character])
            apply(snapshot)
        }
    }
    
    
    private func apply(_ changes: HeroSnapShot,animating:Bool = true){
        DispatchQueue.main.async {
            self.searchDataSource?.apply(changes,animatingDifferences: animating)
        }
    }
    private func configureDataSource(){
        var initialSnapShot = HeroSnapShot()
        initialSnapShot.appendSections([.main])
        initialSnapShot.appendItems([],toSection: .main)
        apply(initialSnapShot,animating: false)
    }
    
    //MARK: - UI
    func updateSearchResultLabel(_ count: Int? = nil){
        self.infoHandler?.presentSearchResult(with: count ?? 0)
    }
    //MARK: - Reset state
    func resetSearchResult() {
        currentSearchResult = nil
    }
}


//MARK: - Helper Structures

extension SearchResultVM {
    struct SearchQuery:Equatable {
        let offset: Query
        let input: Query
    }
    
    struct SearchResult{
        let total:Int
        let query:SearchQuery
    }
}

//MARK: - NSFetchedResultControllerDelegate
import CoreData
import UIKit

extension SearchResultVM: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith diff: CollectionDifference<NSManagedObjectID>) {
        for change in diff {
            switch change {
            case .insert(_, let elementId, _):
                if let characterObject = environment.store.viewContext.registeredObject(for: elementId) as? CharacterObject {
                    let character = Characters(managedObject: characterObject)
                    reloadDataSource(with: character)
                }
            case .remove(_, let elementId, _):
                if let characterObject = environment.store.viewContext.registeredObject(for: elementId) as? CharacterObject {
                    let character = Characters(managedObject: characterObject)
                    reloadDataSource(with: character)
                }
            }
        }
    }
}
