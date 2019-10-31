//
//  Log+CoreDataProperties.swift
//  happy
//
//  Created by Jackson Tubbs on 10/31/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//
//

import Foundation
import CoreData


extension Log {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Log> {
        return NSFetchRequest<Log>(entityName: "Log")
    }

    @NSManaged public var date: Date
    @NSManaged public var rating: Int16
    @NSManaged public var activities: NSOrderedSet
}

// MARK: Generated accessors for activities
extension Log {

    @objc(insertObject:inActivitiesAtIndex:)
    @NSManaged public func insertIntoActivities(_ value: Activity, at idx: Int)

    @objc(removeObjectFromActivitiesAtIndex:)
    @NSManaged public func removeFromActivities(at idx: Int)

    @objc(insertActivities:atIndexes:)
    @NSManaged public func insertIntoActivities(_ values: [Activity], at indexes: NSIndexSet)

    @objc(removeActivitiesAtIndexes:)
    @NSManaged public func removeFromActivities(at indexes: NSIndexSet)

    @objc(replaceObjectInActivitiesAtIndex:withObject:)
    @NSManaged public func replaceActivities(at idx: Int, with value: Activity)

    @objc(replaceActivitiesAtIndexes:withActivities:)
    @NSManaged public func replaceActivities(at indexes: NSIndexSet, with values: [Activity])

    @objc(addActivitiesObject:)
    @NSManaged public func addToActivities(_ value: Activity)

    @objc(removeActivitiesObject:)
    @NSManaged public func removeFromActivities(_ value: Activity)

    @objc(addActivities:)
    @NSManaged public func addToActivities(_ values: NSOrderedSet)

    @objc(removeActivities:)
    @NSManaged public func removeFromActivities(_ values: NSOrderedSet)

}
