//
//  Store.swift
//  Marvel-App
//
//  Created by YILDIRIM on 23.02.2023.
//


import CoreData
final class Store {
    
    enum StoreError: Error {
        case load(Error)
        case save(Error)
        case delete(Error)
    }
    
    private let container: NSPersistentContainer
    private var storeErrors: [StoreError]?
    
    init(name:String? = "MarvelDB") {
        container = NSPersistentContainer(name: name!)
        container.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError("Unable to load store error : \(StoreError.load(error!))")
            }
        }
    }
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
        context.undoManager = nil
        return context
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        let context = container.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
        context.undoManager = nil
        return context
    }()
    
    func deleteCharacter(character:Characters) {
        let context = backgroundContext
        
        context.perform {
            do {
                try
            }catch {
                
            }
        }
    }
}
