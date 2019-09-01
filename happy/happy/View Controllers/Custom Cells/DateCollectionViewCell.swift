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
    
    func configure(indexPath: IndexPath, calendar: UICollectionView) {
        
//        dateView.frame = CGRect(x: 0, y: 0, width: calendar.frame.width / 7, height: calendar.frame.height / 6)
//        dateView.layer.frame
//        dateView.layer.frame = dateView.layer.bounds
//        dateView.layer.cornerRadius = dateView.layer.frame.width / 2
        dateView.layer.cornerRadius = (calendar.frame.width / 14) - 3
//        print("\(calendar.frame.width)")
//        print("\(dateView.bounds.width)")
//        print("\(dateView.frame.width)")
//        print("\(dateView.layer.bounds.width)")
        if indexPath.row < CalendarHelper.shared.months[indexPath.section].days.count {
            dateNumberLabel.text = CalendarHelper.shared.stringForDateCell(date: CalendarHelper.shared.months[indexPath.section].days[indexPath.row])
            self.isHidden = false
            dateView.backgroundColor = .blue
        } else {
            dateNumberLabel.text = ""
            self.isHidden = true
        }
    }
    
}
