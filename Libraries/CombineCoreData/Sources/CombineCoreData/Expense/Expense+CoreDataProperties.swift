//
//  Expense+CoreDataProperties.swift
//  
//
//  Created by Astemir Shibzuhov on 31.03.2025.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var expenseType: String
    @NSManaged public var expenseInfo: Data?
    @NSManaged public var sum: Double
    @NSManaged public var expenseDescription: String?

}
