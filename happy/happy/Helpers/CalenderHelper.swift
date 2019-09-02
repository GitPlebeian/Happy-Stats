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
    
    func stringOfDayNumberForDate(date: Date) -> String {
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
    }
    
    func stringDayNameForDate(date: Date) -> String {
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    
    // Checks to see if date Name (sunday) would be in first column
    func isDateInCorrectColumn(indexPath: IndexPath) -> Bool{
        let columnNumber = indexPath.row % 7
        
        if columnNumber == columnNumberForDate(date: months[indexPath.section].days[indexPath.row]){
            return true
        } else {
            return false
        }
    }
    
    // Returns the column number for respective day
    func columnNumberForDate(date: Date) -> Int {
        switch CalendarHelper.shared.stringDayNameForDate(date: date) {
        case "Sunday": return 0
        case "Monday": return 1
        case "Tuesday": return 2
        case "Wednesday": return 3
        case "Thursday": return 4
        case "Friday": return 5
        case "Saturday": return 6
        default: print("MASSIVE ERROR AT \(#function) \(CalendarHelper.shared.stringDayNameForDate(date: date))" ); return -1
        }
    }
    
    func getIndexForRow(indexPath: IndexPath) -> Int {
        let startinColumn = columnNumberForDate(date: months[indexPath.section].days[0])
        return indexPath.row - startinColumn
    }
}
