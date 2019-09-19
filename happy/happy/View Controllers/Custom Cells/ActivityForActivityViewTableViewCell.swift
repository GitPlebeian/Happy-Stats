//
//  ActivityForActivityViewTableViewCell.swift
//  happy
//
//  Created by Jackson Tubbs on 9/5/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class ActivityForActivityViewTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var daysAppliedLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var activityView: UIView!
    
    // MARK: - Properties
    
    var activity: Activity? {
        didSet {
            updateViewForActivity()
        }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityView.layer.cornerRadius = activityView.frame.height / 2
        ratingView.layer.cornerRadius = ratingView.frame.height / 2
        activityView.layer.borderWidth = 1.5
        activityView.layer.borderColor = UIColor.black.cgColor
        ratingView.backgroundColor = .white
    }
    
    // MARK: - Custom Functions
    
    func updateViewForActivity() {
        guard let activity = activity else {return}
        if activity.timesSelected == 0 {
            daysAppliedLabel.text = "No Days Selected"
//            daysAppliedLabel.isHidden = true
            ratingLabel.isHidden = true
        } else {
            ratingLabel.isHidden = false
            daysAppliedLabel.text = "\(activity.timesSelected)"
        }
        titleLabel.text = activity.title
        activityView.backgroundColor = RatingColors.getColorFoInt(number: Int(activity.averageRating.rounded()))
        ratingLabel.text = "\(activity.averageRating)"
    }
}
