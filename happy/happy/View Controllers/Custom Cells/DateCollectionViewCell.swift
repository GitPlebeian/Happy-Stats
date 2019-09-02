//
//  DateCollectionViewCell.swift
//  happy
//
//  Created by Jackson Tubbs on 8/28/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var dateNumberLabel: UILabel!
    @IBOutlet weak var dateView: UIView!

    // MARK: - Static Functions
    
    // MARK: - Custom Functions
    
    // Shows the border to the user to indicate that the date has been selected
    override var isSelected: Bool {
        didSet {
            dateView.layer.borderWidth = self.isSelected ? 1.5 : 0
        }
    }
    
    func configure(indexPath: IndexPath, calendar: UICollectionView) {
        
        // Makes the cell a circle
        dateView.layer.cornerRadius = (calendar.frame.width / 14) - 6
        dateView.layer.borderColor = UIColor.black.cgColor
        
        // Function makes sure that the date will appear in their respective columns. Example: Sundays you always be in the first column and mondays in the second etc.
        let indexForRow = CalendarHelper.shared.getIndexForRow(indexPath: indexPath)
        if indexForRow < CalendarHelper.shared.months[indexPath.section].days.count && indexForRow >= 0{
            let date = CalendarHelper.shared.months[indexPath.section].days[indexForRow]
            // Sets date label to the date number
            dateNumberLabel.text = CalendarHelper.shared.stringOfDayNumberForDate(date: date)
            if let log = LogController.shared.getLogForDate(date: date) {
                dateView.backgroundColor = RatingColors.getColorFoInt(number: Int(log.rating))
            } else {
                dateView.backgroundColor = .clear
            }
            self.isHidden = false
        } else {
            self.isHidden = true
            dateNumberLabel.text = ""
        }
    }
    
    // MARK: - Helper Functions
//
//    // Checks to see if date Name (sunday) would be in first column
//    func isDateInCorrectColumn(indexPath: IndexPath) -> Bool{
//        let columnNumber = indexPath.row % 7
//
//        if columnNumber == columnNumberForDate(date: CalendarHelper.shared.months[indexPath.section].days[indexPath.row]){
//            return true
//        } else {
//            return false
//        }
//    }
//
//    // Returns the column number for respective day
//    func columnNumberForDate(date: Date) -> Int {
//        switch CalendarHelper.shared.stringDayNameForDate(date: date) {
//        case "Sunday": return 0
//        case "Monday": return 1
//        case "Tuesday": return 2
//        case "Wednesday": return 3
//        case "Thursday": return 4
//        case "Friday": return 5
//        case "Saturday": return 6
//        default: print("MASSIVE ERROR AT \(#function) \(CalendarHelper.shared.stringDayNameForDate(date: date))" ); return -1
//        }
//    }
}
