//
//  LoadDataController.swift
//  happy
//
//  Created by Jackson Tubbs on 9/20/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation

class LoadDataController {
    
    // Completes true when all data has been loaded to device
    static func loadAllData(completion: @escaping (Bool) -> Void) {
        var loadedOne = false
        var loadedTwo = false
        var errorOccured = false
        
        LogController.shared.fetchAllLogs { (success) in
            DispatchQueue.main.async {
                if errorOccured == false && success == true {
                    if loadedOne == true && loadedTwo == true {
                        LogController.shared.pairLogsAndActivities(completion: { () in
                            completion(true)
                        })
                    } else if loadedOne == true {
                        loadedTwo = true
                    } else {
                        loadedOne = true
                    }
                } else {
                    errorOccured = true
                    completion(false)
                }
            }
        }
        
        ActivityController.shared.fetchAllActivities { (success) in
            DispatchQueue.main.async {
                if errorOccured == false && success == true {
                    if loadedOne == true && loadedTwo == true {
                        LogController.shared.pairLogsAndActivities(completion: { () in
                            completion(true)
                        })
                    } else if loadedOne == true {
                        loadedTwo = true
                    } else {
                        loadedOne = true
                    }
                } else {
                    errorOccured = true
                    completion(false)
                }
            }
        }
        
        SettingsController.shared.fetchSettings { (success) in
            DispatchQueue.main.async {
                if errorOccured == false && success == true {
                    if loadedOne == true && loadedTwo == true {
                        LogController.shared.pairLogsAndActivities(completion: { () in
                            completion(true)
                        })
                    } else if loadedOne == true {
                        loadedTwo = true
                    } else {
                        loadedOne = true
                    }
                } else {
                    errorOccured = true
                    completion(false)
                }
            }
        }
    }
}
