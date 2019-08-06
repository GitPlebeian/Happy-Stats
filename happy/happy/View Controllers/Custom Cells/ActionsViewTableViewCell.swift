//
//  ThingsViewTableViewCell.swift
//  happy
//
//  Created by Jackson Tubbs on 8/5/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class ActionsViewTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var actionNameLabel: UILabel!
    @IBOutlet weak var actionRatingLabel: UILabel!
    @IBOutlet weak var numDaysAppliedLabel: UILabel!
    
    // MARK: - Reveivers
    var action: Action? {
        didSet {
            updateView()
        }
    }
    // MARK: - Updating View
    
    func updateView() {
        guard let action = action else {return}
        actionNameLabel.text = action.name
        if action.averageRating == -1 {
            actionRatingLabel.text = ""
        } else {
            actionRatingLabel.text = String(action.averageRating)            
        }
    }
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//    }

}
