////
////  ThingController.swift
////  happy
////
////  Created by Jackson Tubbs on 8/3/19.
////  Copyright © 2019 Jax Tubbs. All rights reserved.
////
//
//import Foundation
//import CoreData
//
//class ActivityController {
//
//    // MARK: - Class Variables
//
//    static var shared = ActivityController()
//
//    // MARK: - Properties
//
//    var activities: [Activity] {
//        // Creates a new fetchRequest that only handles EntityName entity types
//        let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
//        return (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
//    }
//
//    // MARK: - CRUD
//
//    // Create Activity
//    func createActivity(title: String) {
//        Activity(title: title)
//        saveToPersistentStore()
//    }
//
//    // Delete Activity
//    func deleteActivity(activity: Activity) {
//        CoreDataStack.context.delete(activity)
//        saveToPersistentStore()
//    }
//
//    func updateActivity(activity: Activity, title: String) {
//        activity.title = title
//        saveToPersistentStore()
//    }
//
//    // MARK: - Activity selection methods
//
//    // Will toggle selection of activity
//    func toggleSelection(indexOfActivity index: Int) {
//        let activity = activities[index]
//        activity.isSelected = !activity.isSelected
//        saveToPersistentStore()
//    }
//
//    func dislectAllActivities() {
//        for activity in activities {
//            activity.isSelected = false
//        }
//        saveToPersistentStore()
//    }
//
//    func getAllSelectedActivities() -> [Activity] {
//        var arrayOfActivities: [Activity] = []
//        for activity in activities {
//            if activity.isSelected {arrayOfActivities.append(activity)}
//        }
//        return arrayOfActivities
//    }
//
//    // MARK: - Activity Data Function
//
//    // Calculates the activity's new data based on the addition of a log
//    func addLogDataToActivities(log: Log, activities: [Activity]) {
//        for activity in activities {
//            activity.totalRating += log.rating
//            activity.timesSelected += 1
//            activity.averageRating = round((Double(activity.totalRating) / Double(activity.timesSelected)) * 100) / 100
//        }
//        saveToPersistentStore()
//    }
//
//    // Calculates the activitiy's new data based on the deletion of a log
//    func deleteLogDataFromAllActivities(log: Log) {
//        for activity in activities {
//            guard let logs = activity.logs else {return}
//            if logs.contains(log) {
//                activity.totalRating -= log.rating
//                activity.timesSelected -= 1
//                if activity.timesSelected == 0 {
//                    activity.averageRating = -1
//                } else if activity.timesSelected < 0 {
//                    // Error type handling
//                    print("-Inside of \(#function), the number of times selected was less than 0")
//                } else {
//                    activity.averageRating = round((Double(activity.totalRating) / Double(activity.timesSelected)) * 100) / 100
//                }
//            }
//        }
//        saveToPersistentStore()
//    }
//
//    // Gives back an array of activities
//    func getActivitiesNotInLog(log: Log) -> [Activity] {
//        guard let TestingActivities = log.activities?.array as? [Activity] else {return []}
//
//        var activitiesNotInLog: [Activity] = []
//
//        for activity in activities {
//            if !TestingActivities.contains(activity) {
//                activitiesNotInLog.append(activity)
//            }
//        }
//
//        return activitiesNotInLog
//    }
//
//    // MARK: - Persistence
//
//    // Attempts to save to the stack
//    func saveToPersistentStore() {
//        if CoreDataStack.context.hasChanges {
//            do {
//                try CoreDataStack.context.save()
//            } catch {
//                print("There was an error saving the objects in \(#function): \(error.localizedDescription)")
//            }
//        }
//    }
//} // End of class
