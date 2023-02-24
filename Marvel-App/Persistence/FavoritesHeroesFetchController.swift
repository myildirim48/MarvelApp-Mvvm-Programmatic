//
//  FFavoritesHeroesFetchController.swift
//  Marvel-App
//
//  Created by YILDIRIM on 24.02.2023.
//

import UIKit
import CoreData

final class FavoritesHeroesFetchController: NSObject{
    private var context: NSManagedObjectContext!
    weak var delegate: NSFetchedResultsControllerDelegate?

    init(context: NSManagedObjectContext, delegate: NSFetchedResultsControllerDelegate) {
        self.context = context
        self.delegate = delegate
        super.init()
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<CharacterObject> = {
        let request: NSFetchRequest<CharacterObject> = CharacterObject.fetchRequest()
        request.sortDescriptors = CharacterObject.defaultSortDescriptor
        request.relationshipKeyPathsForPrefetching = ["image"]
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 0

        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = delegate
        
        return controller
    }()
    
    func updateFetchController() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("\(error.localizedDescription)")
        }
    }
}
