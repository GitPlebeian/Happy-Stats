//
//  SettingsController.swift
//  happy
//
//  Created by Jackson Tubbs on 9/20/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import CloudKit

class SettingsController {
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
    static let shared = SettingsController()
    
    var settings: Settings?
    
    // MARK: - CRUD
    
    func saveDefaultSettings(completion: @escaping (Bool) -> Void) {
        let settings = Settings(rollingRatingAveragePeriod: SettingsConstants.defaultRollingRatingAveragePeriod, rollingRatingAverageComparisonPeriod: SettingsConstants.defaultRollingRatingAverageComparisonPeriod)
        let record = CKRecord(settings: settings)
        privateDB.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function)\nError: \(error)\nSmall Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let record = record, let settings = Settings(record: record) else {
                completion(false)
                return
            }
            self.settings = settings
            completion(true)
        }
    }
    
    func fetchSettings(completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: SettingsConstants.recordTypeKey, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function)\nError: \(error)\nSmall Error: \(error.localizedDescription)")
                self.saveDefaultSettings(completion: { (success) in
                    if success {
                        completion(true)
                        return
                    } else {
                        completion(false)
                        return
                    }
                })
                return
            }
            guard let records = records, records.isEmpty == false else {
                completion(false)
                return
            }
            
            self.settings = Settings(record: records[0])
            completion(true)
        }
    }
    
    func updateSettings(settings: Settings, completion: @escaping (Bool) -> Void) {
        let modificationOP = CKModifyRecordsOperation(recordsToSave: [CKRecord(settings: settings)], recordIDsToDelete: nil)
        modificationOP.savePolicy = .changedKeys
        modificationOP.queuePriority = .veryHigh
        modificationOP.qualityOfService = .userInitiated
        
        modificationOP.modifyRecordsCompletionBlock = {(_, _, error) in
            if let error = error {
                print("Error in \(#function)\nError: \(error)\nSmall Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
    }
}
