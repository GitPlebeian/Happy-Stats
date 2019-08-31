//
//  CalenderHelper.swift
//  happy
//
//  Created by Jackson Tubbs on 8/30/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation

struct Month {
    
    var monthName: String
    var days: [Date] = []
    var year: String
    
    init(monthName: String, year: String) {
        self.monthName = monthName
        self.year = year
    }
}

class CalendarHelper {
    
    static let shared = CalendarHelper()

    let startDateYear = 2000
    let startDateMonth = 1
    let startDateDay = 1
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    var months: [Month] = []
    
    init() {
        var dateComponents = DateComponents()
        dateComponents.year = startDateYear
        dateComponents.month = startDateMonth
        dateComponents.day = startDateDay
        guard let startDate = calendar.date(from: dateComponents) else {return}
        
        var monthIndex = -1
        var incrementDate = startDate
        while incrementDate <= Date() {
            dateFormatter.dateFormat = "d"
            if Int(dateFormatter.string(from: incrementDate)) == 1 {
                dateFormatter.dateFormat = "MMMM"
                let monthName = dateFormatter.string(from: incrementDate)
                dateFormatter.dateFormat = "yyyy"
                let year = dateFormatter.string(from: incrementDate)
                let month = Month(monthName: monthName, year: year)
                self.months.append(month)
                monthIndex += 1
            }
            months[monthIndex].days.append(incrementDate)
            guard let newIncrementDate = calendar.date(byAdding: .day, value: 1, to: incrementDate) else {return}
            incrementDate = newIncrementDate
        }
    }
    
    func stringForDateCell(date: Date) -> String{
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
    }
}
