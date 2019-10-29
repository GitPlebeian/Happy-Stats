//
//  ActivityController.swift
//  happy
//
//  Created by Jackson Tubbs on 9/16/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import CoreData

class ActivityController {
    
//    let privateDB = CKContainer.default().privateCloudDatabase
    
    static let shared = ActivityController()
    
    var activities: [Activity] {
        let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
        let results = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
        return results
    }
    
    func getActivitiesNotInLog(log: Log) -> [Activity] {
        var activitiesNotInLog: [Activity] = []
        for activity in activities {
            if !log.activities.contains(activity) {
                activitiesNotInLog.append(activity)
            }
        }
        return activitiesNotInLog
    }
//
//    func sortActivitesByNumTimes() {
//        var unsortedNumbers = activities.count
//        while unsortedNumbers > 0 {
//            for index in 1..<unsortedNumbers {
//                if activities[index - 1].timesSelected < activities[index].timesSelected {
//                    let tempActivity = activities[index]
//                    activities[index] = activities[index - 1]
//                    activities[index - 1] = tempActivity
//                }
//            }
//            unsortedNumbers -= 1
//        }
//    }
//
//    // MARK: - Updating Average Rating
//
//    func removeLogData(rating: Int, activities: [Activity]) {
//        for activity in activities {
//            activity.totalRating -= rating
//            activity.timesSelected -= 1
//            calculateAverageRating(activity: activity)
//        }
//    }
//
//    func addLogData(rating: Int, activities: [Activity]) {
//        for activity in activities {
//            activity.totalRating += rating
//            activity.timesSelected += 1
//            calculateAverageRating(activity: activity)
//        }
//    }
//
//    func calculateAverageRating(activity: Activity) {
//        if activity.timesSelected == 0 {
//            activity.averageRating = -1
//        } else {
//            let averageRating = floor((Double(activity.totalRating) / Double(activity.timesSelected) * 100)) / 100
//            activity.averageRating = averageRating
//        }
//    }
//
//    // MARK: - CRUD
//
//    func copyActivity(activity: Activity) -> Activity {
//        return Activity(title: activity.title, totalRating: activity.totalRating, timesSelected: activity.timesSelected, averageRating: activity.averageRating, recordID: activity.recordID)
//    }
//
//    func createActivity(title: String, completion: @escaping (Bool) -> Void) {
//        let activity = Activity(title: title)
//        let record = CKRecord(activity: activity)
//        privateDB.save(record) { (record, error) in
//            if let error = error {
//                print("Error in \(#function)\nError: \(error)\nSmall Error: \(error.localizedDescription)")
//                completion(false)
//                return
//            }
//            guard let record = record, let activity = Activity(record: record) else {
//                completion(false)
//                return
//            }
//            self.activities.append(activity)
//            completion(true)
//        }
//    }
//
//    func fetchAllActivities(completion: @escaping (Bool) -> Void) {
//        let predicate = NSPredicate(value: true)
//        let query = CKQuery(recordType: ActivityConstants.recordTypeKey, predicate: predicate)
//        privateDB.perform(query, inZoneWith: nil) { (records, error) in
//            if let error = error {
//                print("Error in \(#function)\nError: \(error)\nSmall Error: \(error.localizedDescription)")
//                completion(false)
//                return
//            }
//            guard let records = records else {
//                completion(false)
//                return
//            }
//
//            let activities: [Activity] = records.compactMap({Activity(record: $0)})
//            self.activities = activities
//            completion(true)
//            DispatchQueue.main.async {
//                self.sortActivitesByNumTimes()
//            }
//        }
//    }
//
//    func updateActivities(activities: [Activity], completion: @escaping (Bool) -> Void) {
//        let modificationOP = CKModifyRecordsOperation(recordsToSave: activities.compactMap({CKRecord(activity: $0)}), recordIDsToDelete: nil)
//        modificationOP.savePolicy = .changedKeys
//        modificationOP.queuePriority = .veryHigh
//        modificationOP.qualityOfService = .userInitiated
//
//        modificationOP.modifyRecordsCompletionBlock = {(_, _, error) in
//            if let error = error {
//                print("Error in \(#function)\nError: \(error)\nSmall Error: \(error.localizedDescription)")
//                completion(false)
//                return
//            }
//            completion(true)
//        }
//        privateDB.add(modificationOP)
//    }
//
//    func deleteActivity(activity: Activity, completion: @escaping (Bool) -> Void) {
//        guard let index = activities.firstIndex(of: activity) else {
//            completion(false)
//            return
//        }
//
//        privateDB.delete(withRecordID: activity.recordID) { (_, error) in
//            if let error = error {
//                print("Error in \(#function)\nError: \(error)\nSmall Error: \(error.localizedDescription)")
//                completion(false)
//                return
//            } else {
//                LogController.shared.deleteActivityFromLogs(activity: self.activities[index], completion: { (success) in
//                    if success {
//                        self.activities.remove(at: index)
//                        self.sortActivitesByNumTimes()
//                        completion(true)
//                    } else {
//                        completion(false)
//                        return
//                    }
//                })
//            }
//        }
//    }
    
    func createActivity(title: String) {
        Activity(title: title)
        saveToPersistentStore()
    }
    
    func deleteActivity(activity: Activity) {
        CoreDataStack.context.delete(activity)
        saveToPersistentStore()
    }
    
    func renameActivity(title: String, activity: Activity) {
        activity.title = title
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        if CoreDataStack.context.hasChanges{
            try? CoreDataStack.context.save()
        }
    }
}
