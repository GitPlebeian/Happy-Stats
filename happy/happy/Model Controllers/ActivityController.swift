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
    
    // MARK: - Selection Methods
    
    // Will toggle selection of activity
    func toggleSelection(indexOfActivity index: Int) {
        let activity = activities[index]
        activity.isSelected = !activity.isSelected
        saveToPersistentStore()
    }

    func dislectAllActivities() {
        for activity in activities {
            activity.isSelected = false
        }
        saveToPersistentStore()
    }
    
    func getAllSelectedActivities() -> [Activity] {
        var arrayOfActivities: [Activity] = []
        for activity in activities {
            if activity.isSelected {arrayOfActivities.append(activity)}
        }
        return arrayOfActivities
    }
    
    func addLogToActivities(log: Log, activities: [Activity]) {
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        for activity in activities {
            var array = activity.logs?.sortedArray(using: [sortDescriptor])
            array?.append(log)
            guard let nonOptionalArray = array else {return}
            activity.logs = NSOrderedSet(array: nonOptionalArray)
            activity.totalRating += log.rating
            activity.timesSelected += 1
            activity.averageRating = round((Double(activity.totalRating) / Double(activity.timesSelected)) * 100) / 100
        }
//        saveToPersistentStore()
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
