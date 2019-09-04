//
//  Activity+Convenience.swift
//  happy
//
//  Created by Jackson Tubbs on 8/9/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import CoreData

extension Activity {
    
    @discardableResult
    convenience init(title: String, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.title = title
        self.isSelected = false
        self.totalRating = 0
        self.timesSelected = 0
        self.averageRating = -1
    }
}
