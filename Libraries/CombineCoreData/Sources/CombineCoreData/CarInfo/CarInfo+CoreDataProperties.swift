//
//  CarInfo+CoreDataProperties.swift
//  
//
//  Created by Astemir Shibzuhov on 26.10.2024.
//
//

import Foundation
import CoreData


public extension CarInfo {

    @nonobjc class func fetchRequest() -> NSFetchRequest<CarInfo> {
        return NSFetchRequest<CarInfo>(entityName: "CarInfo")
    }

    @NSManaged var color: String?
    @NSManaged var mark: String?
    @NSManaged var mileage: NSNumber?
    @NSManaged var model: String?
    @NSManaged var power: NSNumber?
    @NSManaged var volumeEngine: NSNumber?
    @NSManaged var year: NSNumber?
    @NSManaged var number: String?

}
