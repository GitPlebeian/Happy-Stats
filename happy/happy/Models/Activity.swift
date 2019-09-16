//
//  Activity.swift
//  happy
//
//  Created by Jackson Tubbs on 9/16/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import CloudKit

struct ActivityConstants {
    static let recordTypeKey = "Activity"
    fileprivate static let titleKey = "title"
    fileprivate static let totalRatingKey = "totalRating"
    fileprivate static let timesSelectedKey = "timesSelected"
    fileprivate static let averageRatingKey = "averageRating"
}

class Activity {
    
    let title: String
    let totalRating: Int
    let timesSelected: Int
    let averageRating: Double
    let recordID: CKRecord.ID
    
    init(title: String, totalRating: Int = 0, timesSelected: Int = 0, averageRating: Double = 0, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.totalRating = totalRating
        self.timesSelected = timesSelected
        self.averageRating = averageRating
        self.recordID = recordID
    }
}

extension Activity {
    convenience init? (record: CKRecord) {
        guard let title = record[ActivityConstants.titleKey] as? String,
        let totalRating = record[ActivityConstants.totalRatingKey] as? Int,
        let timesSelected = record[ActivityConstants.timesSelectedKey] as? Int,
        let averageRating = record[ActivityConstants.averageRatingKey] as? Double
            else {return nil}
        
        self.init(title: title, totalRating: totalRating, timesSelected: timesSelected, averageRating: averageRating, recordID: record.recordID)
    }
}

extension CKRecord {
    convenience init(activity: Activity) {
        self.init(recordType: ActivityConstants.recordTypeKey, recordID: activity.recordID)
        self.setValue(activity.title, forKey: ActivityConstants.titleKey)
        self.setValue(activity.totalRating, forKey: ActivityConstants.totalRatingKey)
        self.setValue(activity.timesSelected, forKey: ActivityConstants.timesSelectedKey)
        self.setValue(activity.averageRating, forKey: ActivityConstants.averageRatingKey)
    }
}

extension Activity: Equatable {
    static func ==(lhs: Activity, rhs: Activity) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}
