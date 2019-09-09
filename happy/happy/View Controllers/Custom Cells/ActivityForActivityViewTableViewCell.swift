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
        ratingView.backgroundColor = .white
    }
    
    // MARK: - Custom Functions
    
    func updateViewForActivity() {
        guard let activity = activity else {return}
        titleLabel.text = activity.title
        daysAppliedLabel.text = String(activity.timesSelected)
        activityView.backgroundColor = RatingColors.getColorFoInt(number: Int(activity.averageRating.rounded()))
        let rating = (activity.averageRating * 100).rounded() / 100
        ratingLabel.text = "\(rating)"
    }
}
