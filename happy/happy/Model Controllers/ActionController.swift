//
//  ThingController.swift
//  happy
//
//  Created by Jackson Tubbs on 8/3/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation

class ActionController {
    
    // Class Variables
    
    static var shared = ActionController()
    
    // Properties
    
    var actions: [Action] = []
    
    // MARK: - Functions
    
    // CRUD
    
    func createAction(name: String) {
        let action = Action(name: name)
        actions.append(action)
        saveToPersistentStore()
    }
    
    func deleteAction(index: Int) {
        actions.remove(at: index)
        saveToPersistentStore()
    }
    
    func updateExistingAction(action: Action, name: String) {
        guard let indexOfAction = actions.firstIndex(of: action) else {return}
        actions[indexOfAction].name = name
        saveToPersistentStore()
    }
    
    // MARK: - Thing selection
    
    // Will dislect all of the things
    func dislectAllActions() {
        for action in actions {
            action.isSelected = false
        }
    }
    
    // Will toggle selection of a thing
    func toggleSelection(index: Int) {
        let action = actions[index]
        if action.isSelected {action.isSelected = false} else {action.isSelected = true}
    }
    // Will return all selected things
    func getAllSelectedActions() -> [Action] {
        var actionsArray: [Action] = []
        for action in actions {
            if action.isSelected {actionsArray.append(action)}
        }
        return actionsArray
    }
    
    // MARK: - Happiness Calculation
    
    func calculateHappinessForActions() {
        for action in actions {
            let ratingLevels = LogController.shared.getHappinessLevelForAction(action: action)
            if ratingLevels == [] {
                action.averageRating = -1
                continue
            }
            var totalRating = 0
            for rating in ratingLevels {
                totalRating += rating
            }
            let averageRating = Double(totalRating) / Double(ratingLevels.count)
            action.averageRating = round(averageRating * 10) / 10
        }
    }
    
    // MARK: - Persistence
    
    func createFileURLForPersistence() -> URL {
        // Grab the users document directory
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        // Create the new fileURL on user's phone
        let fileURL = urls[0].appendingPathComponent("Action.json")
        
        return fileURL
    }
    
    func saveToPersistentStore() {
        // Create an instance of JSON Encoder
        let jsonEncoder = JSONEncoder()
        // Attempt to convert our quotes to JSON
        do {
            let jsonActions = try jsonEncoder.encode(actions)
            // With the new json(d) quote, save it to the users device
            try jsonActions.write(to: createFileURLForPersistence())
        } catch let encodingError {
            // Handle the error, if there is one
            print("There was an error saving!! \(encodingError)")
        }
    }
    
    func loadFromPersistentStore() {
        // The data we want will be JSON, and I want it to be a Quote.
        let jsonDecoder = JSONDecoder()
        //Decode the data
        do {
            let jsonData = try Data(contentsOf: createFileURLForPersistence())
            let decodedAction = try jsonDecoder.decode([Action].self, from: jsonData)
            actions = decodedAction
        } catch let decodingError {
            print("There was an error decoding!! \(decodingError.localizedDescription)")
        }
    }
}
