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
    
    // MARK: - Functions
    
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
    
    // Adds activities to logs bases on the log references
    func pairLogsAndActivities() {
        for log in logs {
            for activityReference in log.activityReferences {
                for activity in ActivityController.shared.activities {
                    if activityReference.recordID == activity.recordID {
                        log.activities.append(activity)
                    }
                }
            }
        }
    }
    
    // Will update a log with activities
    func pairLogAndActivities(log: Log) {
        for activityReference in log.activityReferences {
            for activity in ActivityController.shared.activities {
                if activityReference.recordID == activity.recordID {
                    log.activities.append(activity)
                }
            }
        }
    }
    
    // MARK: - CRUD
    
    // Creates a new log with a the information coppied
    func copyLog(log: Log) -> Log{
        return Log(date: log.date, rating: log.rating, activityReferences: log.activityReferences, activities: log.activities, recordID: log.recordID)
    }
    
    
    // Creates a log and will update the activities average happiness based on the log
    func createLog(date: Date, rating: Int, activities: [Activity] = [], completion: @escaping (Log?) -> Void) {
        var readyToComplete = false
        var activityReferences: [CKRecord.Reference] = []
        for activity in activities {
            activityReferences.append(CKRecord.Reference(recordID: activity.recordID, action: .none))
        }
        let log = Log(date: date, rating: rating, activityReferences: activityReferences)
        let record = CKRecord(log: log)
        privateDB.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function)\nError: \(error)\nSmall Error: \(error.localizedDescription)")
                ActivityController.shared.removeLogData(rating: log.rating, activities: activities)
                completion(nil)
                return
            }
            guard let record = record, let savedLog = Log(record: record) else {
                ActivityController.shared.removeLogData(rating: log.rating, activities: activities)
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                if readyToComplete == true {
                    self.pairLogAndActivities(log: savedLog)
                    self.logs.append(savedLog)
                    completion(savedLog)
                } else {
                    readyToComplete = true
                }
            }
        }
        ActivityController.shared.addLogData(rating: log.rating, activities: activities)
        ActivityController.shared.updateActivities(activities: activities, completion: { (success) in
            if success {
                DispatchQueue.main.async {
                    if readyToComplete == true {
                        self.pairLogAndActivities(log: log)
                        self.logs.append(log)
                        completion(log)
                    } else {
                        readyToComplete = true
                    }
                }
            } else {
                ActivityController.shared.removeLogData(rating: log.rating, activities: activities)
                completion(nil)
                return
            }
        })
    }
    
    // Will Fetch all of the logs from the users Cloud Storage
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
    
    // Will update the log and will update the activities' values based on the logs rating
    func updateLog(log: Log, newRating: Int, newActivities: [Activity], completion: @escaping (Log?) -> Void) {
        let oldLogCopy = copyLog(log: log)
        log.rating = newRating
        log.activities = newActivities
        ActivityController.shared.removeLogData(rating: oldLogCopy.rating, activities: oldLogCopy.activities)
        ActivityController.shared.addLogData(rating: log.rating, activities: log.activities)

        var activitiesToUpdate: [Activity] = log.activities
        for activity in oldLogCopy.activities {
            if !activitiesToUpdate.contains(activity) {
                activitiesToUpdate.append(activity)
            }
        }
        let modificationOP = CKModifyRecordsOperation(recordsToSave: activitiesToUpdate.compactMap({CKRecord(activity: $0)}) + [CKRecord(log: log)], recordIDsToDelete: nil)
        modificationOP.savePolicy = .changedKeys
        modificationOP.queuePriority = .veryHigh
        modificationOP.qualityOfService = .userInitiated
        modificationOP.modifyRecordsCompletionBlock = {(records, _, error) in
            if let error = error {
                print("Error in \(#function)\nError: \(error)\nSmall Error: \(error.localizedDescription)")
                self.revertLogChanges(log: log, oldLogCopy: oldLogCopy)
                completion(nil)
                return
            } else {
                completion(log)
            }
        }
        privateDB.add(modificationOP)
    }
    
    // Used by the updateLog function to revert back to the old status
    func revertLogChanges(log: Log, oldLogCopy: Log) {
        ActivityController.shared.removeLogData(rating: log.rating, activities: log.activities)
        ActivityController.shared.addLogData(rating: oldLogCopy.rating, activities: oldLogCopy.activities)
        log.rating = oldLogCopy.rating
        log.activities = oldLogCopy.activities
        log.activityReferences = oldLogCopy.activityReferences
    }
    
    // Update activityReferences
    private func updateActivityReferences(log: Log) {
        var activityReferences: [CKRecord.Reference] = []
        for activity in log.activities {
            activityReferences.append(CKRecord.Reference(recordID: activity.recordID, action: .none))
        }
        log.activityReferences = activityReferences
    }
    
    func deleteLog(log: Log, completion: @escaping (Bool) -> Void) {
        var readyToComplete = false
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
                if readyToComplete == true {
                    
                } else {
                    readyToComplete = true
                }
                completion(true)
                ActivityController.shared.removeLogData(rating: log.rating, activities: log.activities)
                self.logs.remove(at: index)
            }
        }
    }
    
    func deleteActivityFromLogs(activity: Activity, completion: @escaping (Bool) -> Void) {
        var changedLogs: [Log] = []
        var changedLogsIndexes: [Int] = []
        for log in logs {
            if let index = log.activities.firstIndex(of: activity) {
                changedLogsIndexes.append(index)
                changedLogs.append(log)
            }
        }
        
        let modificationOP = CKModifyRecordsOperation(recordsToSave: changedLogs.compactMap({CKRecord(log: $0)}), recordIDsToDelete: nil)
        modificationOP.savePolicy = .changedKeys
        modificationOP.queuePriority = .veryHigh
        modificationOP.qualityOfService = .userInitiated
        modificationOP.modifyRecordsCompletionBlock = {(records, _, error) in
            if let error = error {
                print("Error in \(#function)\nError: \(error)\nSmall Error: \(error.localizedDescription)")
                completion(false)
                return
            } else {
                var index = 0
                for log in changedLogs {
                    log.activities.remove(at: changedLogsIndexes[index])
                    index += 1
                }
                completion(true)
            }
        }
        privateDB.add(modificationOP)
    }
}
