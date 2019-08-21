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
    
    // MARK: - Properties
    
    func setupCellBeforeDisplay(cellState: CellState, rating: Int? = nil) {
        dateLabel.text = cellState.text
        
        if let rating = rating {
            dateColorView.backgroundColor = happinessColors.getColorFoInt(number: rating)
        } else {
            dateColorView.backgroundColor = .clear
        }
        dateColorView.layer.cornerRadius = dateColorView.frame.size.width / 2.0
        if cellState.isSelected {
            dateColorView.layer.borderWidth = 1.5
            dateColorView.layer.borderColor = UIColor.black.cgColor
            dateLabel.textColor = .black
        } else {
            dateColorView.layer.borderWidth = 0
            dateColorView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func changeBackgroundColor(rating: Int) {
         dateColorView.backgroundColor = happinessColors.getColorFoInt(number: rating)
    }
}
