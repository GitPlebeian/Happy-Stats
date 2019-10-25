//
//  Activity.swift
//  happy
//
//  Created by Jackson Tubbs on 9/16/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import CoreData

extension Activity {
    
    @discardableResult
    convenience init( title: String,
                      averageRating: Double = -1,
                      timesSelected: Int = 0,
                      totalRating: Int = 0,
                      context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        self.title = title
        self.averageRating = averageRating
        self.timesSelected = Int32(timesSelected)
        self.totalRating = Int32(totalRating)
    }
}
