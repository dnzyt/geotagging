//
//  PrevVisitInfo+CoreDataProperties.swift
//  geotag
//
//  Created by Ningze Dai on 1/12/22.
//
//

import Foundation
import CoreData


extension PrevVisitInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PrevVisitInfo> {
        return NSFetchRequest<PrevVisitInfo>(entityName: "PrevVisitInfo")
    }

    @NSManaged public var visitNumber: String?
    @NSManaged public var answers: NSSet?
    @NSManaged public var clubInfo: ClubInfo?

}

// MARK: Generated accessors for answers
extension PrevVisitInfo {

    @objc(addAnswersObject:)
    @NSManaged public func addToAnswers(_ value: AnswerInfo)

    @objc(removeAnswersObject:)
    @NSManaged public func removeFromAnswers(_ value: AnswerInfo)

    @objc(addAnswers:)
    @NSManaged public func addToAnswers(_ values: NSSet)

    @objc(removeAnswers:)
    @NSManaged public func removeFromAnswers(_ values: NSSet)

}

extension PrevVisitInfo : Identifiable {

}
