//
//  ThingTableViewCell.swift
//  happy
//
//  Created by Jackson Tubbs on 8/4/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class ActivityForRatingViewTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var activityTitleLabel: UILabel!
    

    // MARK: - Receivers

    var activity: Activity? {
        didSet {
            updateView()
        }
    }

    // MARK: - Functions

    // Will Update the thingNameLabel with the thing name
    func updateView() {
        guard let activity = activity else {return}
        activityTitleLabel.text = activity.title
    }

    // Sets the selection state for selected cells
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
}
