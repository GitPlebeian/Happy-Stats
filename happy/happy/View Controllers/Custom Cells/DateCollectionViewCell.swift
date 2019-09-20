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
    
    // MARK: - Custom Functions
    
    func configure(indexPath: IndexPath, calendar: UICollectionView, selectedDate: Date?) {
        
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
                dateView.backgroundColor = ColorHelper.getColorFoInt(number: Int(log.rating))
            } else {
                dateView.backgroundColor = .clear
            }

            if let selectedDate = selectedDate, date == selectedDate {
                dateView.layer.borderWidth = 1.5
            } else {
                dateView.layer.borderWidth = 0
            }
            self.isHidden = false
        } else {
            self.isHidden = true
            dateNumberLabel.text = ""
        }
    }
}
