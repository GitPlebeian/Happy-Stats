//
//  CoreDataStack.swift
//  happy
//
//  Created by Jackson Tubbs on 10/22/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static var debug: Bool = true
    
    static let container: NSPersistentContainer = {
        let container: NSPersistentContainer
        if debug == true {
            container = NSPersistentContainer(name: "debug")
        } else {
            container = NSPersistentContainer(name: "Hapistats")
        }
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error{
                fatalError("Failed to Load Persistent Store \(error)")
            }
        })
        return container
    }()
    
    static var context: NSManagedObjectContext{
        return container.viewContext
    }
}
