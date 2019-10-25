//
//  Log.swift
//  happy
//
//  Created by Jackson Tubbs on 9/16/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import CoreData

extension Log {
    
    @discardableResult
    convenience init(rating: Int, date: Date, activities: [Activity] = [], context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.rating = Int16(rating)
        self.date = date
        let activitiesSet = NSOrderedSet(array: activities)
        self.activities = activitiesSet
    }
    
}

