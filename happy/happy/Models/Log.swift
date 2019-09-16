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
    fileprivate static let activityReferencesKey = "activityReferences"
}

class Log {
    let date: Date
    var rating: Int
    var activities: [Activity]
    let recordID: CKRecord.ID
    var activityReferences: [CKRecord.Reference]
    
    init(date: Date, rating: Int, activityReferences: [CKRecord.Reference], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.date = date
        self.rating = rating
        self.recordID = recordID
        self.activities = []
        self.activityReferences = activityReferences
    }
}

extension Log {
    convenience init?(record: CKRecord) {
        guard let date = record[LogConstants.dateKey] as? Date,
        let rating = record[LogConstants.ratingKey] as? Int,
        let activityReferences = record[LogConstants.activityReferencesKey] as? [CKRecord.Reference]
            else {return nil}
        self.init(date: date, rating: rating, activityReferences: activityReferences, recordID: record.recordID)
    }
}

extension CKRecord {
    convenience init(log: Log) {
        self.init(recordType: LogConstants.recordTypeKey, recordID: log.recordID)
        self.setValue(log.date, forKey: LogConstants.dateKey)
        self.setValue(log.rating, forKey: LogConstants.ratingKey)
        self.setValue(log.activityReferences, forKey: LogConstants.activityReferencesKey)
    }
}

extension Log: Equatable {
    static func ==(lhs: Log, rhs: Log) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}
