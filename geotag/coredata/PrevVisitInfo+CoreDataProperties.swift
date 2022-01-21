//
//  PrevVisitInfo+CoreDataProperties.swift
//  geotag
//
//  Created by Ningze Dai on 1/20/22.
//
//

import Foundation
import CoreData


extension PrevVisitInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PrevVisitInfo> {
        return NSFetchRequest<PrevVisitInfo>(entityName: "PrevVisitInfo")
    }

    @NSManaged public var visitNumber: String?
    @NSManaged public var clubInfo: ClubInfo?
    @NSManaged public var prevAnswers: NSOrderedSet?

}

// MARK: Generated accessors for prevAnswers
extension PrevVisitInfo {

    @objc(insertObject:inPrevAnswersAtIndex:)
    @NSManaged public func insertIntoPrevAnswers(_ value: PrevAnswer, at idx: Int)

    @objc(removeObjectFromPrevAnswersAtIndex:)
    @NSManaged public func removeFromPrevAnswers(at idx: Int)

    @objc(insertPrevAnswers:atIndexes:)
    @NSManaged public func insertIntoPrevAnswers(_ values: [PrevAnswer], at indexes: NSIndexSet)

    @objc(removePrevAnswersAtIndexes:)
    @NSManaged public func removeFromPrevAnswers(at indexes: NSIndexSet)

    @objc(replaceObjectInPrevAnswersAtIndex:withObject:)
    @NSManaged public func replacePrevAnswers(at idx: Int, with value: PrevAnswer)

    @objc(replacePrevAnswersAtIndexes:withPrevAnswers:)
    @NSManaged public func replacePrevAnswers(at indexes: NSIndexSet, with values: [PrevAnswer])

    @objc(addPrevAnswersObject:)
    @NSManaged public func addToPrevAnswers(_ value: PrevAnswer)

    @objc(removePrevAnswersObject:)
    @NSManaged public func removeFromPrevAnswers(_ value: PrevAnswer)

    @objc(addPrevAnswers:)
    @NSManaged public func addToPrevAnswers(_ values: NSOrderedSet)

    @objc(removePrevAnswers:)
    @NSManaged public func removeFromPrevAnswers(_ values: NSOrderedSet)

}

extension PrevVisitInfo : Identifiable {

}
