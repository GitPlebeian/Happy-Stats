//
//  LogController.swift
//  happy
//
//  Created by Jackson Tubbs on 9/16/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import CloudKit

class LogController {
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
    static let shared = LogController()
    
    var logs: [Log] = []
    
    // Get log for date is complicated due to the seconds and minutes and hours that would screw things up
    func getLogForDate(date: Date) -> Log? {
        for log in logs {
            let logDate = log.date
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
    
    // MARK: - CRUD
    
    func createLog(date: Date, rating: Int, activities: [Activity] = [], completion: @escaping (Bool) -> Void) {
        var activityReferences: [CKRecord.Reference] = []
        for activity in activities {
            activityReferences.append(CKRecord.Reference(recordID: activity.recordID, action: .none))
        }
        let log = Log(date: date, rating: rating, activityReferences: activityReferences)
        let record = CKRecord(log: log)
        privateDB.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function)\nError: \(error)\nSmall Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let record = record, let log = Log(record: record) else {
                completion(false)
                return
            }
            self.logs.append(log)
            completion(true)
        }
    }
    
    func fetchAllLogs(completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: LogConstants.recordTypeKey, predicate: predicate)
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
            
            let logs: [Log] = records.compactMap({Log(record: $0)})
            self.logs = logs
            completion(true)
        }
    }
    
    func updateLog(log: Log, completion: @escaping (Bool) -> Void) {
        let modificationOP = CKModifyRecordsOperation(recordsToSave: [CKRecord(log: log)], recordIDsToDelete: nil)
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
    
    func deleteLog(log: Log, completion: @escaping (Bool) -> Void) {
        guard let index = logs.firstIndex(of: log) else {
            completion(false)
            return
        }
        
        privateDB.delete(withRecordID: log.recordID) { (_, error) in
            if let error = error {
                print("Error in \(#function)\nError: \(error)\nSmall Error: \(error.localizedDescription)")
                completion(false)
                return
            } else {
                completion(true)
                self.logs.remove(at: index)
            }
        }
    }
}
