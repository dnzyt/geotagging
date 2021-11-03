//
//  ClubInfo+CoreDataProperties.swift
//  geotag
//
//  Created by Ningze Dai on 10/19/21.
//
//

import Foundation
import CoreData


extension ClubInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ClubInfo> {
        return NSFetchRequest<ClubInfo>(entityName: "ClubInfo")
    }

    @NSManaged public var address: String?
    @NSManaged public var city: String?
    @NSManaged public var clubKey: String?
    @NSManaged public var clubName: String?
    @NSManaged public var clubStatus: String?
    @NSManaged public var clubType: String?
    @NSManaged public var geocode: String?
    @NSManaged public var geoUpdated: Bool
    @NSManaged public var openDate: String?
    @NSManaged public var phone: String?
    @NSManaged public var primaryDsId: String?
    @NSManaged public var primaryDsName: String?
    @NSManaged public var province: String?
    @NSManaged public var uplineName: String?
    @NSManaged public var zip: String?
    @NSManaged public var countryCode: String?
    @NSManaged public var hasBeenVisited: Bool

}

extension ClubInfo : Identifiable {

}
