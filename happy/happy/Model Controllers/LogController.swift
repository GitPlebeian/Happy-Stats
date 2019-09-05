//
//  logController.swift
//  happy
//
//  Created by Jackson Tubbs on 8/3/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import CoreData

class LogController {
    
    // MARK: - Class Properties
    
    static var shared = LogController()
    
    // MARK: - Properties
    
    var logs: [Log] {
        // Creates a new fetchRequest that only handles EntityName entity types
        let fetchRequest: NSFetchRequest<Log> = Log.fetchRequest()
        return (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
    }
//    var logs: [Log] = []
//
//    init() {
//        let activity = Activity(title: "Work")
//        let activity2 = Activity(title: "Play")
//        let activity3 = Activity(title: "Tacos")
//        let activity4 = Activity(title: "Gym")
//        let log = Log(date: Date(), rating: 10, activities: [activity])
//        logs.append(log)
//        ActivityController.shared.activities.append(activity)
//        ActivityController.shared.activities.append(activity2)
//        ActivityController.shared.activities.append(activity3)
//        ActivityController.shared.activities.append(activity4)
//    }

    // MARK: - CRUD
    
    // Create
    func createLog(date: Date, rating: Int, activities: [Activity] = []) {
        let log = Log(date: date, rating: rating, activities: activities)
        log.addToActivities(NSOrderedSet(array: activities))
        ActivityController.shared.addLogDataToActivities(log: log, activities: activities)
        saveToPersistentStore()
    }
    // Delete
    func deleteLog(log: Log) {
        ActivityController.shared.deleteLogDataFromAllActivities(log: log)
        CoreDataStack.context.delete(log)
        saveToPersistentStore()
    }
    
    // Update
    func updateLog(log: Log, selectedActivities: [Activity], rating: Int) {
   
        ActivityController.shared.deleteLogDataFromAllActivities(log: log)
        
        log.rating = Int64(rating)
        log.activities = NSOrderedSet(array: selectedActivities)
        ActivityController.shared.addLogDataToActivities(log: log, activities: selectedActivities)
        
        saveToPersistentStore()
    }
    
    // MARK: - Custom Functions
    
    func getLogForDate(date: Date) -> Log? {
        
        for log in logs {
            guard let logDate = log.date else {continue}
            let calendar = Calendar.current
            
            let year1 = calendar.component(.year, from: date)
            let year2 = calendar.component(.year, from: logDate)
            let month1 = calendar.component(.month, from: date)
            let month2 = calendar.component(.month, from: logDate)
            let day1 = calendar.component(.day, from: date)
            let day2 = calendar.component(.day, from: logDate)
            
            if year1 == year2 &&
                month1 == month2 &&
                day1 == day2 {
                return log
            }
        }
        return nil
    }
    
    // MARK: - Persistence
    
    // Attempts to save to the stack
    func saveToPersistentStore() {
        if CoreDataStack.context.hasChanges {
            do {
                try CoreDataStack.context.save()
            } catch {
                print("There was an error saving the objects in \(#function): \(error.localizedDescription)")
            }
        }
    }
} // Class End
