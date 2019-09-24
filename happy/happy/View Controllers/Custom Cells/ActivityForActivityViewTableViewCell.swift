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
        if DarkModeController.shared.darkMode.enabled {
            
        } else {
            titleLabel.textColor = .black
            daysAppliedLabel.textColor = .black
            ratingLabel.textColor = .black
        }
        activityView.layer.cornerRadius = 55 / 2
        ratingView.layer.cornerRadius = 45 / 2
        ratingView.backgroundColor = .white
        self.backgroundColor = .white
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        guard let activity = activity else {return}
        if highlighted {
            activityView.backgroundColor = activityView.backgroundColor?.darker(by: 15)
        } else {
            activityView.backgroundColor = ColorHelper.getColorFoInt(number: Int(activity.averageRating.rounded()))
        }
    }
    
    // MARK: - Custom Functions
    
    func updateViewForActivity() {
        guard let activity = activity else {return}
        if activity.timesSelected == 0 {
            daysAppliedLabel.text = "No Days Selected"
            ratingLabel.isHidden = true
            activityView.layer.borderWidth = 1.5
            activityView.layer.borderColor = UIColor.black.cgColor
        } else {
            ratingLabel.isHidden = false
            daysAppliedLabel.text = "\(activity.timesSelected)"
            activityView.layer.borderWidth = 0
        }
        titleLabel.text = activity.title
        activityView.backgroundColor = ColorHelper.getColorFoInt(number: Int(activity.averageRating.rounded()))
        ratingLabel.text = "\(activity.averageRating)"
    }
}
