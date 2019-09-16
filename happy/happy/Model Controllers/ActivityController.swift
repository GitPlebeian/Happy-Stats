//
//  ActivityController.swift
//  happy
//
//  Created by Jackson Tubbs on 9/16/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import CloudKit

class ActivityController {
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
    static let shared = ActivityController()
    
    var activities: [Activity] = []
    
    // MARK: - CRUD
    
    func createActivity(title: String, completion: @escaping (Bool) -> Void) {
        let activity = Activity(title: title)
        let record = CKRecord(activity: activity)
        privateDB.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function)\nError: \(error)\nSmall Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let record = record, let activity = Activity(record: record) else {
                completion(false)
                return
            }
            self.activities.append(activity)
            completion(true)
        }
    }
    
    func fetchAllActivities(completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: ActivityConstants.recordTypeKey, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function)\nError: \(error)\nSmall Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let records = records else {
                completion(false)
                return
            }
            
            let activities: [Activity] = records.compactMap({Activity(record: $0)})
            self.activities = activities
            completion(true)
        }
    }
    
    func updateActivity(activity: Activity, completion: @escaping (Bool) -> Void) {
        let modificationOP = CKModifyRecordsOperation(recordsToSave: [CKRecord(activity: activity)], recordIDsToDelete: nil)
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
        privateDB.add(modificationOP)
    }
    
    func deleteActivity(activity: Activity, completion: @escaping (Bool) -> Void) {
        guard let index = activities.firstIndex(of: activity) else {
            completion(false)
            return
        }
        
        privateDB.delete(withRecordID: activity.recordID) { (_, error) in
            if let error = error {
                print("Error in \(#function)\nError: \(error)\nSmall Error: \(error.localizedDescription)")
                completion(false)
                return
            } else {
                completion(true)
                self.activities.remove(at: index)
            }
        }
    }
}
