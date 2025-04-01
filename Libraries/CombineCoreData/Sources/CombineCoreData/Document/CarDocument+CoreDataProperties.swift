//
//  CarDocument+CoreDataProperties.swift
//  
//
//  Created by Astemir Shibzuhov on 14.03.2025.
//
//

import Foundation
import CoreData


extension CarDocument {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CarDocument> {
        return NSFetchRequest<CarDocument>(entityName: "CarDocument")
    }

    @NSManaged public var attributes: Data?
    @NSManaged public var expiredDate: Date?
    @NSManaged public var id: UUID
    @NSManaged public var type: String
    @NSManaged public var imagePath: String?
    @NSManaged public var name: String?

}
