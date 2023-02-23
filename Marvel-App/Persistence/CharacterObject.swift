//
//  CharacterObject.swift
//  Marvel-App
//
//  Created by YILDIRIM on 23.02.2023.
//

import CoreData

public class CharacterObject: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterObject> {
        return NSFetchRequest<CharacterObject>(entityName: "Character")
    }
    
    @NSManaged public var id: Int64
    @NSManaged public var descriptionText: String
    @NSManaged public var name: String
    @NSManaged public var created: Date?
    @NSManaged public var image: ImageObject?
    
}

extension CharacterObject {
    public static var defaultSortDescriptor: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "created", ascending: true)]
    }
    static func createCharacter(with character: Characters, imageObject: ImageObject?, in context: NSManagedObjectContext) -> CharacterObject {
    
        let characterObject = CharacterObject(context: context)
        characterObject.created = Date()
        characterObject.id = Int64(character.id)
        characterObject.name = character.name
        characterObject.descriptionText = character.description
        characterObject.image = imageObject
        return characterObject
    }
    
}
