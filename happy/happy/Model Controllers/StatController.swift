//
//  logController.swift
//  happy
//
//  Created by Jackson Tubbs on 8/3/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import CoreData

class StatController {
    
    // MARK: - Class Properties
    
    static var shared = StatController()
    
    // MARK: - Properties
    
    var stats: [Log] {
        // Creates a new fetchRequest that only handles EntityName entity types
        let fetchRequest: NSFetchRequest<Log> = Log.fetchRequest()
        return (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
    }

    // MARK: - CRUD
    
    // Create
    func createLog(date: Date, rating: Int) {
        // Instructions: Initialize a new Enitity
        Log(date: date, rating: rating)
        saveToPersistentStore()
    }
    // Delete
    func deleteLog(log: Log) {
        CoreDataStack.context.delete(log)
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
} // Class End
