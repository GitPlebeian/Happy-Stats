//
//  Activity+CoreDataProperties.swift
//  happy
//
//  Created by Jackson Tubbs on 10/22/19.
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
    @NSManaged public var title: String?
    @NSManaged public var totalRating: Int32
    @NSManaged public var logs: Log?

}
