//
//  LabelInfo+CoreDataProperties.swift
//  geotag
//
//  Created by Ningze Dai on 10/15/21.
//
//

import Foundation
import CoreData


extension LabelInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LabelInfo> {
        return NSFetchRequest<LabelInfo>(entityName: "LabelInfo")
    }

    @NSManaged public var labelKey: String?
    @NSManaged public var labelValue: String?
    @NSManaged public var question: QuestionInfo?

}

extension LabelInfo : Identifiable {

}
