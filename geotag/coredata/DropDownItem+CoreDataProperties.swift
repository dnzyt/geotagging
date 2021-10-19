//
//  DropDownItem+CoreDataProperties.swift
//  geotag
//
//  Created by Ningze Dai on 10/19/21.
//
//

import Foundation
import CoreData


extension DropDownItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DropDownItem> {
        return NSFetchRequest<DropDownItem>(entityName: "DropDownItem")
    }

    @NSManaged public var labelKey: String?
    @NSManaged public var labelValue: String?
    @NSManaged public var answerInfo: AnswerInfo?

}

extension DropDownItem : Identifiable {

}
