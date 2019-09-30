//
//  StatisticsFunctions.swift
//  happy
//
//  Created by Jackson Tubbs on 9/23/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation

class StatisticFunctions {
    
    static func getAverageHappinessForDays(numDays: Int) -> Double {
        let logRatings = LogController.shared.getRatingsForTimePeriod(days: numDays)
        if logRatings.count == 0 {
            return -1
        }
        return getAverageInts(array: logRatings)
    }
    
    static func getAverageHappinessForMonth(month: String, year: String) -> Double {
        let logRatings = LogController.shared.getRatingsForMonth(month: month, year: year)
        if logRatings.count == 0 {
            return -1
        }
        return getAverageInts(array: logRatings)
    }

    private static func getAverageInts(array: [Int]) -> Double {
        var totalNumber: Int = 0
        for number in array {
            totalNumber += number
        }
        return ((Double(totalNumber) / Double(array.count) * 100).rounded()) / 100
    }
}
