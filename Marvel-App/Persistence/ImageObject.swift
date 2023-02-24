//
//  ImageObject.swift
//  Marvel-App
//
//  Created by YILDIRIM on 23.02.2023.
//

import CoreData

public class ImageObject: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageObject> {
        return NSFetchRequest<ImageObject>(entityName: "ImageObject")
    }
    
    @NSManaged public var path: String?
    @NSManaged public var type: String?
    @NSManaged public var imgData: Data?
    @NSManaged public var character: CharacterObject?
    
}

extension ImageObject {
    
    static func findOrCreateImage(with image: Thumbnail, with data: Data?, in context: NSManagedObjectContext) throws -> ImageObject {
        let request: NSFetchRequest<ImageObject> = ImageObject.fetchRequest()
    request.predicate = NSPredicate(format: "path = %@", image.path!)
        
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                return match.first!
            }
        } catch {
            throw error
        }
        
        let imageObject = ImageObject(context: context)
        imageObject.path = image.path
        imageObject.type = image.ext
        imageObject.imgData = data
        return imageObject
    }
}
