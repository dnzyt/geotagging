//
//  QuestionInfo+CoreDataProperties.swift
//  geotag
//
//  Created by Ningze Dai on 10/19/21.
//
//

import Foundation
import CoreData


extension QuestionInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuestionInfo> {
        return NSFetchRequest<QuestionInfo>(entityName: "QuestionInfo")
    }

    @NSManaged public var categoryId: String?
    @NSManaged public var countryCode: String?
    @NSManaged public var label: String?
    @NSManaged public var needComment: String?
    @NSManaged public var questionKey: String?
    @NSManaged public var questionType: String?
    @NSManaged public var items: NSOrderedSet?

}

// MARK: Generated accessors for items
extension QuestionInfo {

    @objc(insertObject:inItemsAtIndex:)
    @NSManaged public func insertIntoItems(_ value: LabelInfo, at idx: Int)

    @objc(removeObjectFromItemsAtIndex:)
    @NSManaged public func removeFromItems(at idx: Int)

    @objc(insertItems:atIndexes:)
    @NSManaged public func insertIntoItems(_ values: [LabelInfo], at indexes: NSIndexSet)

    @objc(removeItemsAtIndexes:)
    @NSManaged public func removeFromItems(at indexes: NSIndexSet)

    @objc(replaceObjectInItemsAtIndex:withObject:)
    @NSManaged public func replaceItems(at idx: Int, with value: LabelInfo)

    @objc(replaceItemsAtIndexes:withItems:)
    @NSManaged public func replaceItems(at indexes: NSIndexSet, with values: [LabelInfo])

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: LabelInfo)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: LabelInfo)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSOrderedSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSOrderedSet)

}

extension QuestionInfo : Identifiable {

}
