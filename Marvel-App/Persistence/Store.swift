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
    
    init(name:String? = "Heroes") {
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
                try CharacterObject.deleteCharacter(with: character, in: context)
            self.save(context) { result in
                    switch result {
                    case .success(let status): print("Save status: \(status)")
                    case .failure(let errorStatus): self.storeErrors?.append(errorStatus)
                    }
                }
            }catch {
                let storeError = StoreError.save(error)
                self.storeErrors?.append(storeError)
            }
        }
    }
    
    func toggleStorage(for character: Characters, with data: Data? = nil, completion: @escaping (Bool) -> Void) {
        let context = viewContext
        context.perform {
            do {
                if  context.hasPersistenceId(for: character) {
                    try CharacterObject.deleteCharacter(with: character, in: context)
                }
                else {
                    if let imageData = data, let imageObject = try? ImageObject.findOrCreateImage(with: character.thumbnail!, with: imageData, in: context) {
                        _ = CharacterObject.createCharacter(with: character, imageObject: imageObject, in: context)
                    } else {
                        _ = CharacterObject.createCharacter(with: character, imageObject: nil, in: context)
                    }
                }
                
                self.save(context) { result in
                    switch result {
                    case .success(_): completion(true)
                    case .failure(let storeError):
                        completion(false)
                        self.storeErrors?.append(storeError)
                    }
                }
            }catch {
                let storeError = StoreError.save(error)
                self.storeErrors?.append(storeError)
                completion(false)
            }
        }
    }
    
    private func save(_ context: NSManagedObjectContext, completion: @escaping (Result<Bool, StoreError>) -> ()) {
        var status = false
        context.perform {
            if context.hasChanges{
                do {
                    try context.save()
                }catch{
                    let error = StoreError.save(error)
                    return completion(.failure(error))
                }
            }
            status = true
            completion(.success(status))
        }
    }
}
extension NSManagedObjectContext {
    func hasPersistenceId(for character: Characters) -> Bool{
        let request: NSFetchRequest<CharacterObject> = CharacterObject.fetchRequest()
        request.predicate = NSPredicate(format: "id = %ld", Int64(character.id))
        request.propertiesToFetch = ["id"]
        do {
            let match = try self.fetch(request)
            guard let _ = match.first else {
                return false
            }
            return true
        }catch {
            return false
        }
    }
}
