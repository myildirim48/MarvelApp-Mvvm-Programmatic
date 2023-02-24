//
//  FavoritesVM.swift
//  Marvel-App
//
//  Created by YILDIRIM on 23.02.2023.
//

import CoreData
import UIKit

class FavoritesViewModel: NSObject {
    
    enum ChangeType { case insert, remove }
    
    private let environment: Environment
    private var dataSource: HeroDataSource?
    private var favoritesCharacters : [Characters]?
    private var favoriteHeroesController: FavoritesHeroesFetchController!
    
    init(environment: Environment) {
        self.environment = environment
        super.init()
        
        favoriteHeroesController = FavoritesHeroesFetchController(context: environment.store.viewContext, delegate: self)
        favoriteHeroesController.updateFetchController()
        favoritesCharacters = favoriteHeroesController.fetchedResultsController.fetchedObjects?.toCharacters()
        
    }
    //MARK: - DataSource
    func configureDataSource(with dataSource: HeroDataSource) {
        self.dataSource = dataSource
        configureDataSource()
    }
    
    func item(for indexPath: IndexPath) -> Characters? {
        let cha =  dataSource?.itemIdentifier(for: indexPath)
        return cha
    }
    
    private func configureDataSource() {
        var initialSnapshot = HeroSnapShot()
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems(favoritesCharacters ?? [], toSection: .main)
        apply(initialSnapshot, animating: false)
    }
    private func updateDataSource(with type: ChangeType, character: Characters) {
        guard let dataSource = dataSource else { return }
        
        var updateSnapshot = dataSource.snapshot()
        switch type {
        case .insert:
            guard !updateSnapshot.itemIdentifiers.contains(character) else { return }
            updateSnapshot.appendItems([character], toSection: .main)
        case .remove:
            guard updateSnapshot.itemIdentifiers.contains(character) else { return }
            updateSnapshot.deleteItems([character])
        }
        apply(updateSnapshot)
    }
    
    private func apply(_ changes: HeroSnapShot, animating: Bool = true) {
        DispatchQueue.global().async {
            self.dataSource?.apply(changes, animatingDifferences: animating)
        }
    }
    
}

//MARK: - NSFetchedResultsControllerDelegate
extension FavoritesViewModel: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith diff: CollectionDifference<NSManagedObjectID>) {
        for change in diff {
            switch change {
            case .insert(_, let elementId, _):
                if let characterObject = environment.store.viewContext.registeredObject(for: elementId) as? CharacterObject {
                    let character = Characters(managedObject: characterObject)
                    updateDataSource(with: .insert, character: character)
                }
            case .remove(_, let elementId, _):
                
                if let characterObject = environment.store.viewContext.registeredObject(for: elementId) as? CharacterObject {
                    let character = Characters(managedObject: characterObject)
                    updateDataSource(with: .remove, character: character)
                }
            }
        }
    }
}
