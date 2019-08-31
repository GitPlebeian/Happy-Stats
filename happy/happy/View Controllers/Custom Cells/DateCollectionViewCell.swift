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
