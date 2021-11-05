//
//  OfflineGeocode+CoreDataProperties.swift
//  geotag
//
//  Created by Ningze Dai on 10/19/21.
//
//

import Foundation
import CoreData


extension OfflineGeocode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OfflineGeocode> {
        return NSFetchRequest<OfflineGeocode>(entityName: "OfflineGeocode")
    }

    @NSManaged public var clubKey: String?
    @NSManaged public var geocode: String?
    @NSManaged public var isDone: Bool

}

extension OfflineGeocode : Identifiable {

}
