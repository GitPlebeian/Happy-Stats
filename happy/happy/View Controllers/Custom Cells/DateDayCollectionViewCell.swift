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
    @IBOutlet weak var selectedView: UIView!
    
    
    func setupCellBeforeDisplay(cellState: CellState) {
        dateLabel.text = cellState.text
        
        if cellState.isSelected {
            dateLabel.textColor = .white
            selectedView.backgroundColor = UIColor(red:1.00, green:0.34, blue:0.34, alpha:1.0)
            selectedView.layer.cornerRadius = selectedView.frame.size.width / 2.05
            selectedView.isHidden = false
            print("\(selectedView.frame.size.width)")
            print("\(selectedView.frame.size.height)")
        } else {
            selectedView.isHidden = true
        }
    }
    
}
