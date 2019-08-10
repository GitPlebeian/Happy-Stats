//
//  ThingController.swift
//  happy
//
//  Created by Jackson Tubbs on 8/3/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import CoreData

class ActivityController {
    
    // MARK: - Class Variables
    
    static var shared = ActivityController()
    
    // MARK: - Properties
    
    var activities: [Activity] {
        // Creates a new fetchRequest that only handles EntityName entity types
        let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
        return (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
    }

    // MARK: - CRUD
    
    // Create Activity
    func createActivity(title: String) {
        Activity(title: title)
        saveToPersistentStore()
    }
    // Delete Activity
    func deleteActivity(activity: Activity) {
        CoreDataStack.context.delete(activity)
        saveToPersistentStore()
    }

    // MARK: - Persistence
    
    // Attempts to save to the stack
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("There was an error saving the objects in \(#function): \(error.localizedDescription)")
        }
    }
} // End of class
