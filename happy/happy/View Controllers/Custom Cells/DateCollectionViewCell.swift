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
    
    // MARK: - Properties
    
    // MARK: - Custom Functions
    
    override var isSelected: Bool {
        didSet {
            dateView.layer.borderWidth = self.isSelected ? 1.5 : 0
            
        }
    }
    
    func configure(indexPath: IndexPath, calendar: UICollectionView, selectedIndexPath: IndexPath?) {
        
        dateView.layer.cornerRadius = (calendar.frame.width / 14) - 6
        dateView.layer.borderColor = UIColor.black.cgColor
        
        let startingColumn = columnNumberForDate(date: CalendarHelper.shared.months[indexPath.section].days[0])
        if indexPath.row - startingColumn < CalendarHelper.shared.months[indexPath.section].days.count && indexPath.row - startingColumn >= 0{
            let date = CalendarHelper.shared.months[indexPath.section].days[indexPath.row - startingColumn]
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
        
//        if let selectedIndexPath = selectedIndexPath {
//            if selectedIndexPath == indexPath {
//                dateView.layer.borderColor = UIColor.black.cgColor
//                dateView.layer.borderWidth = 2
//            } else {
//                dateView.layer.borderWidth = 0
//            }
//        }
    }
    
    // MARK: - Helper Functions
    
    func isDateInCorrectColumn(indexPath: IndexPath) -> Bool{
        let columnNumber = indexPath.row % 7
        
        if columnNumber == columnNumberForDate(date: CalendarHelper.shared.months[indexPath.section].days[indexPath.row]){
            return true
        } else {
            return false
        }
    }
    
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
}
