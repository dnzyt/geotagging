//
//  VisitInfo+CoreDataProperties.swift
//  geotag
//
//  Created by Ningze Dai on 10/19/21.
//
//

import Foundation
import CoreData


extension VisitInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VisitInfo> {
        return NSFetchRequest<VisitInfo>(entityName: "VisitInfo")
    }

    @NSManaged public var clubKey: String?
    @NSManaged public var visitDate: Date?
    @NSManaged public var submitted: Bool
    @NSManaged public var finished: Bool
    @NSManaged public var answers: NSSet?

}

// MARK: Generated accessors for answers
extension VisitInfo {

    @objc(addAnswersObject:)
    @NSManaged public func addToAnswers(_ value: AnswerInfo)

    @objc(removeAnswersObject:)
    @NSManaged public func removeFromAnswers(_ value: AnswerInfo)

    @objc(addAnswers:)
    @NSManaged public func addToAnswers(_ values: NSSet)

    @objc(removeAnswers:)
    @NSManaged public func removeFromAnswers(_ values: NSSet)

}

extension VisitInfo : Identifiable {

}
