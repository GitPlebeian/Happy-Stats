//
//  logController.swift
//  happy
//
//  Created by Jackson Tubbs on 8/3/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation

class LogController {
    
    // MARK: - Class Properties
    
    static var shared = LogController()
    
    // MARK: - Properties
    
    var logs: [Log] = []

    // MARK: - CRUD
    
    // Log Cruds
    
    // Creates a new log and appends it to the logs array
    func createNewLog(rating: Int, date: Date) {
        let actions = ActionController.shared.getAllSelectedActions()
        let log = Log(rating: rating, actions: actions, date: date)
        logs.append(log)
        saveToPersistentStore()
    }
    
    // Deletes a log
    func deleteLog(index: Int) {
        logs.remove(at: index)
        saveToPersistentStore()
    }
    
    // MARK: - Calculations
    
    func getHappinessLevelForAction(action: Action) -> [Int] {
        var happinessLevels: [Int] = []
        for log in logs {
            for logAction in log.actions {
                if logAction == action {
                    happinessLevels.append(log.rating)
                }
            }
        }
        return happinessLevels
    }
    
    // MARK: - Persistence
    
    func createFileURLForPersistence() -> URL {
        // Grab the users document directory
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        // Create the new fileURL on user's phone
        let fileURL = urls[0].appendingPathComponent("Log.json")
        
        return fileURL
    }
    
    func saveToPersistentStore() {
        // Create an instance of JSON Encoder
        let jsonEncoder = JSONEncoder()
        // Attempt to convert our quotes to JSON
        do {
            let jsonJournals = try jsonEncoder.encode(logs)
            // With the new json(d) quote, save it to the users device
            try jsonJournals.write(to: createFileURLForPersistence())
        } catch let encodingError {
            // Handle the error, if there is one
            print("There was an error saving!! \(encodingError.localizedDescription)")
        }
    }
    
    func loadFromPersistentStore() {
        // The data we want will be JSON, and I want it to be a Quote.
        let jsonDecoder = JSONDecoder()
        //Decode the data
        do {
            let jsonData = try Data(contentsOf: createFileURLForPersistence())
            let decodedAction = try jsonDecoder.decode([Log].self, from: jsonData)
            logs = decodedAction
        } catch let decodingError {
            print("There was an error decoding!! \(decodingError.localizedDescription)")
        }
    }
    
    
} // Class End
