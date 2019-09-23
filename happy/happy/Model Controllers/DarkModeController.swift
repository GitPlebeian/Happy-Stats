//
//  DarkModeController.swift
//  happy
//
//  Created by Jackson Tubbs on 9/23/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation

class DarkModeController {
    
    static let shared = DarkModeController()
    
    var darkMode: DarkMode = DarkMode(enabled: false)
    
    // MARK: CRUD
    
    func updateDarkMode(enabled: Bool) {
        darkMode.enabled = enabled
        saveToPersistentStore()
    }
    
    // MARK: - Persistence
    
    func createFileURLForPersistence() -> URL {
        // Grab the users document directory
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        // Create the new fileURL on user's phone
        let fileURL = urls[0].appendingPathComponent("darkMode.json")
        
        return fileURL
    }
    
    func saveToPersistentStore() {
        // Create an instance of JSON Encoder
        let jsonEncoder = JSONEncoder()
        // Attempt to convert our quotes to JSON
        do {
            let jsonDarkMode = try jsonEncoder.encode(darkMode)
            // With the new json(d) quote, save it to the users device
            try jsonDarkMode.write(to: createFileURLForPersistence())
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
            let decodedDarkMode = try jsonDecoder.decode(DarkMode.self, from: jsonData)
            darkMode = decodedDarkMode
        } catch let decodingError {
            print("There was an error decoding!! \(decodingError.localizedDescription)")
            darkMode = DarkMode(enabled: false)
            saveToPersistentStore()
        }
    }
}
