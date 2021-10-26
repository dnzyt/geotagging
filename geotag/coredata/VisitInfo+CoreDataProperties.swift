//
//  VisitInfo+CoreDataProperties.swift
//  geotag
//
//  Created by Ningze Dai on 10/26/21.
//
//

import Foundation
import CoreData


extension VisitInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VisitInfo> {
        return NSFetchRequest<VisitInfo>(entityName: "VisitInfo")
    }

    @NSManaged public var clubKey: String?
    @NSManaged public var finished: Bool
    @NSManaged public var submitted: Bool
    @NSManaged public var visitDate: Date?
    @NSManaged public var answers: NSOrderedSet?

}

// MARK: Generated accessors for answers
extension VisitInfo {

    @objc(insertObject:inAnswersAtIndex:)
    @NSManaged public func insertIntoAnswers(_ value: AnswerInfo, at idx: Int)

    @objc(removeObjectFromAnswersAtIndex:)
    @NSManaged public func removeFromAnswers(at idx: Int)

    @objc(insertAnswers:atIndexes:)
    @NSManaged public func insertIntoAnswers(_ values: [AnswerInfo], at indexes: NSIndexSet)

    @objc(removeAnswersAtIndexes:)
    @NSManaged public func removeFromAnswers(at indexes: NSIndexSet)

    @objc(replaceObjectInAnswersAtIndex:withObject:)
    @NSManaged public func replaceAnswers(at idx: Int, with value: AnswerInfo)

    @objc(replaceAnswersAtIndexes:withAnswers:)
    @NSManaged public func replaceAnswers(at indexes: NSIndexSet, with values: [AnswerInfo])

    @objc(addAnswersObject:)
    @NSManaged public func addToAnswers(_ value: AnswerInfo)

    @objc(removeAnswersObject:)
    @NSManaged public func removeFromAnswers(_ value: AnswerInfo)

    @objc(addAnswers:)
    @NSManaged public func addToAnswers(_ values: NSOrderedSet)

    @objc(removeAnswers:)
    @NSManaged public func removeFromAnswers(_ values: NSOrderedSet)

}

extension VisitInfo : Identifiable {

}
