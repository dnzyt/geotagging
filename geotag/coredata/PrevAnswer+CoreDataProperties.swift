//
//  PrevAnswer+CoreDataProperties.swift
//  geotag
//
//  Created by Ningze Dai on 1/19/22.
//
//

import Foundation
import CoreData


extension PrevAnswer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PrevAnswer> {
        return NSFetchRequest<PrevAnswer>(entityName: "PrevAnswer")
    }

    @NSManaged public var labelKey: String?
    @NSManaged public var labelValue: String?
    @NSManaged public var selections: String?
    @NSManaged public var comments: String?
    @NSManaged public var usersEntry: String?
    @NSManaged public var prevVisitInfo: PrevVisitInfo?

}

extension PrevAnswer : Identifiable {

}
