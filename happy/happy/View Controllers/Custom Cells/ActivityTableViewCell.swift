//
//  ActivityForActivityViewTableViewCell.swift
//  happy
//
//  Created by Jackson Tubbs on 9/5/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var daysAppliedLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var timesSelectedAverageRatingParentView: UIView!
    
    // MARK: - Properties
    
    var activity: Activity? {
        didSet {
            updateViewForActivity()
        }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = UIColor(named: "Black")
        daysAppliedLabel.textColor = UIColor(named: "Black")
        ratingLabel.textColor = UIColor(named: "Black")
        activityView.layer.cornerRadius = 40 / 2
        timesSelectedAverageRatingParentView.layer.cornerRadius = 32 / 2
        self.backgroundColor = UIColor(named: "White")
    }
    
    // Set Highlighted
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        guard let activity = activity else {return}
        if highlighted {
            activityView.backgroundColor = activityView.backgroundColor?.darker(by: 15)
        } else {
            activityView.backgroundColor = ColorHelper.getColorFoInt(number: Int(activity.averageRating.rounded()))
        }
    }
    
    // MARK: - Custom Functions
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        activityView.layer.borderColor = UIColor(named: "Black")?.cgColor
    }
    
    // Updates view for an activity
    func updateViewForActivity() {
        guard let activity = activity else {return}
        let activityColor = ColorHelper.getColorFoInt(number: Int(activity.averageRating.rounded()))
        if activity.timesSelected == 0 {
            ratingLabel.isHidden = true
            activityView.layer.borderWidth = 1.5
            activityView.layer.borderColor = UIColor(named: "Black")?.cgColor
            timesSelectedAverageRatingParentView.isHidden = true
        } else {
            timesSelectedAverageRatingParentView.isHidden = false
            if activityColor.useDarkText() {
                titleLabel.textColor = UIColor.black
            } else {
                titleLabel.textColor = UIColor.white
            }
            ratingLabel.isHidden = false
            daysAppliedLabel.text = "\(activity.timesSelected)"
            activityView.layer.borderWidth = 0
        }
        titleLabel.text = activity.title
        activityView.backgroundColor = activityColor
        ratingLabel.text = "\(activity.averageRating)"
    }
}
