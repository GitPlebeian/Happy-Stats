////
////  CoreDataStack.swift
////  happy
////
////  Created by Jackson Tubbs on 8/9/19.
////  Copyright © 2019 Jax Tubbs. All rights reserved.
////
//
//import Foundation
//import CoreData
//
//class CoreDataStack {
//    
//    static let container: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "HapiStats")
//        container.loadPersistentStores(completionHandler: { (_, error) in
//            if let error = error{
//                fatalError("Failed to Load Persistent Store \(error)")
//            }
//        })
//        return container
//    }()
//    
//    static var context: NSManagedObjectContext{
//        return container.viewContext
//    }
//}
