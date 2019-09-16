//
//  Log.swift
//  happy
//
//  Created by Jackson Tubbs on 9/16/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import CloudKit

struct LogConstants {
    static let recordTypeKey = "Log"
    fileprivate static let dateKey = "date"
    fileprivate static let ratingKey = "rating"
    fileprivate static let activitiesKey = "activities"
    
}

class Log {
    let date: Date
    let rating: Int
    let activities: [Activity]
    let recordID: CKRecord.ID
    var activityReferences: [CKRecord.Reference] {
        var references: [CKRecord.Reference] = []
        for activity in activities {
            references.append(CKRecord.Reference(recordID: activity.recordID, action: .none))
        }
        return references
    }
    
    init(date: Date, rating: Int, activities: [Activity], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.date = date
        self.rating = rating
        self.activities = activities
        self.recordID = recordID
    }
}

extension Log {
    convenience init?(record: CKRecord) {
        guard let date = record[LogConstants.dateKey] as? Date,
        let rating = record[LogConstants.ratingKey] as? Int,
        let activities = record[LogConstants.activitiesKey] as? [Activity]
            else {return nil}
        
        self.init(date: date, rating: rating, activities: activities, recordID: record.recordID)
    }
}

extension CKRecord {
    convenience init(log: Log) {
        self.init(recordType: LogConstants.recordTypeKey, recordID: log.recordID)
        self.setValue(log.date, forKey: LogConstants.dateKey)
        self.setValue(log.rating, forKey: LogConstants.ratingKey)
        self.setValue(log.activities, forKey: LogConstants.activitiesKey)
    }
}

extension Log: Equatable {
    static func ==(lhs: Log, rhs: Log) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}
