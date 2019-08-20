//
//  DateDayCollectionViewCell.swift
//  happy
//
//  Created by Jackson Tubbs on 8/19/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DateDayCollectionViewCell: JTACDayCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateColorView: UIView!
    
    
    
    func setupCellBeforeDisplay(cellState: CellState) {
        dateLabel.text = cellState.text
        
        if cellState.isSelected {


        } else {
            let log = LogController.shared.getLogForDate(date: cellState.date)
            if let log = log {
                dateColorView.backgroundColor = happinessColors.getColorFoInt(number: Int(log.rating))
            } else {
                dateColorView.backgroundColor = .clear
            }
        }
        dateColorView.layer.cornerRadius = dateColorView.frame.size.width / 2.0
    }
}
