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
    
    func configure(indexPath: IndexPath) {
        dateView.backgroundColor = .red
        if indexPath.row < CalendarHelper.shared.months[indexPath.section].days.count {
            print("\(indexPath.section): \(indexPath.row)")
            dateNumberLabel.text = CalendarHelper.shared.stringForDateCell(date: CalendarHelper.shared.months[indexPath.section].days[indexPath.row])
        } else {
            dateNumberLabel.text = ""
        }
    }
    
}
