//
//  AnswerInfo+CoreDataProperties.swift
//  geotag
//
//  Created by Ningze Dai on 10/16/21.
//
//

import Foundation
import CoreData


extension AnswerInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AnswerInfo> {
        return NSFetchRequest<AnswerInfo>(entityName: "AnswerInfo")
    }

    @NSManaged public var ans: [Int]?
    @NSManaged public var categoryId: String?
    @NSManaged public var countryCode: String?
    @NSManaged public var label: String?
    @NSManaged public var needComment: String?
    @NSManaged public var questionKey: String?
    @NSManaged public var questionType: String?
    @NSManaged public var comment: String?
    @NSManaged public var items: NSOrderedSet?

}

// MARK: Generated accessors for items
extension AnswerInfo {

    @objc(insertObject:inItemsAtIndex:)
    @NSManaged public func insertIntoItems(_ value: DropDownItem, at idx: Int)

    @objc(removeObjectFromItemsAtIndex:)
    @NSManaged public func removeFromItems(at idx: Int)

    @objc(insertItems:atIndexes:)
    @NSManaged public func insertIntoItems(_ values: [DropDownItem], at indexes: NSIndexSet)

    @objc(removeItemsAtIndexes:)
    @NSManaged public func removeFromItems(at indexes: NSIndexSet)

    @objc(replaceObjectInItemsAtIndex:withObject:)
    @NSManaged public func replaceItems(at idx: Int, with value: DropDownItem)

    @objc(replaceItemsAtIndexes:withItems:)
    @NSManaged public func replaceItems(at indexes: NSIndexSet, with values: [DropDownItem])

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: DropDownItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: DropDownItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSOrderedSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSOrderedSet)

}

extension AnswerInfo : Identifiable {

}
