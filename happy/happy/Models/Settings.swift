//
//  Settings.swift
//  happy
//
//  Created by Jackson Tubbs on 9/20/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import CloudKit

struct SettingsConstants {
    static let recordTypeKey = "Settings"
    fileprivate static let rollingRatingAveragePeriodKey = "rollingRatingAveragePeriod"
    fileprivate static let rollingRatingAverageComparisonPeriodKey = "rollingRatingAverageComparisonPeriod"
    fileprivate static let darkModeKey = "darkMode"
    
    static let defaultRollingRatingAveragePeriod = 30
    static let defaultRollingRatingAverageComparisonPeriod = 30
    static let defaultDarkMode = false
}

class Settings {
    
    var rollingRatingAveragePeriod: Int
    var rollingRatingAverageComparisonPeriod: Int
    var darkMode: Bool
    var recordID: CKRecord.ID
    
    init(rollingRatingAveragePeriod: Int, rollingRatingAverageComparisonPeriod: Int,
         darkMode: Bool, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.rollingRatingAveragePeriod = rollingRatingAveragePeriod
        self.rollingRatingAverageComparisonPeriod = rollingRatingAverageComparisonPeriod
        self.darkMode = darkMode
        self.recordID = recordID
    }
}

extension Settings {
    convenience init?(record: CKRecord) {
        guard let rollingRatingAveragePeriod = record[SettingsConstants.rollingRatingAveragePeriodKey] as? Int,
            let rollingRatingAverageComparisonPeriod = record[SettingsConstants.rollingRatingAverageComparisonPeriodKey] as? Int,
            let darkMode = record[SettingsConstants.darkModeKey] as? Bool else {return nil}
        self.init(rollingRatingAveragePeriod: rollingRatingAveragePeriod, rollingRatingAverageComparisonPeriod: rollingRatingAverageComparisonPeriod, darkMode: darkMode)
    }
}

extension CKRecord {
    convenience init(settings: Settings) {
        self.init(recordType: SettingsConstants.recordTypeKey, recordID: settings.recordID)
        self.setValue(settings.rollingRatingAveragePeriod, forKey: SettingsConstants.rollingRatingAveragePeriodKey)
        self.setValue(settings.rollingRatingAverageComparisonPeriod, forKey: SettingsConstants.rollingRatingAverageComparisonPeriodKey)
        self.setValue(settings.darkMode, forKey: SettingsConstants.darkModeKey)
    }
}

extension Settings: Equatable {
    static func ==(lhs: Settings, rhs: Settings) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}
