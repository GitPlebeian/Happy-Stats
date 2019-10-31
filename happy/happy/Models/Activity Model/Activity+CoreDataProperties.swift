//
//  Activity+CoreDataProperties.swift
//  happy
//
//  Created by Jackson Tubbs on 10/29/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var averageRating: Double
    @NSManaged public var timesSelected: Int32
    @NSManaged public var title: String
    @NSManaged public var totalRating: Int32
    @NSManaged public var logs: NSOrderedSet

}

// MARK: Generated accessors for logs
extension Activity {

    @objc(insertObject:inLogsAtIndex:)
    @NSManaged public func insertIntoLogs(_ value: Log, at idx: Int)

    @objc(removeObjectFromLogsAtIndex:)
    @NSManaged public func removeFromLogs(at idx: Int)

    @objc(insertLogs:atIndexes:)
    @NSManaged public func insertIntoLogs(_ values: [Log], at indexes: NSIndexSet)

    @objc(removeLogsAtIndexes:)
    @NSManaged public func removeFromLogs(at indexes: NSIndexSet)

    @objc(replaceObjectInLogsAtIndex:withObject:)
    @NSManaged public func replaceLogs(at idx: Int, with value: Log)

    @objc(replaceLogsAtIndexes:withLogs:)
    @NSManaged public func replaceLogs(at indexes: NSIndexSet, with values: [Log])

    @objc(addLogsObject:)
    @NSManaged public func addToLogs(_ value: Log)

    @objc(removeLogsObject:)
    @NSManaged public func removeFromLogs(_ value: Log)

    @objc(addLogs:)
    @NSManaged public func addToLogs(_ values: NSOrderedSet)

    @objc(removeLogs:)
    @NSManaged public func removeFromLogs(_ values: NSOrderedSet)

}
