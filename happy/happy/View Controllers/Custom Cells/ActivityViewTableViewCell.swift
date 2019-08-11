//
//  ThingsViewTableViewCell.swift
//  happy
//
//  Created by Jackson Tubbs on 8/5/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class ActivityViewTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var numDaysAppliedLabel: UILabel!
    @IBOutlet weak var averageRatingLabel: UILabel!
    
    
    // MARK: - Reveivers
    var activity: Activity? {
        didSet {
            updateView()
        }
    }
    // MARK: - Updating View
    
    func updateView() {
        guard let activity = activity else {return}
        activityNameLabel.text = activity.title
        if activity.averageRating == -1 {
            averageRatingLabel.text = ""
        } else {
            averageRatingLabel.text = String(activity.averageRating)
        }
        numDaysAppliedLabel.text = activity.timesSelected > 0 ? String(activity.timesSelected) : ""
    }
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//    }

}
