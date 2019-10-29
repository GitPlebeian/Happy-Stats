//
//  ActivityTableViewCell.swift
//  happy
//
//  Created by Jackson Tubbs on 9/4/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class SelectActivitiesTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var selectionDotView: UIView!
    @IBOutlet weak var activityTitleLabel: UILabel!
    @IBOutlet weak var activityView: UIView!
    
    // MARK: - Properties
    
    var activitiy: Activity? {
        didSet {
            updateViewForActivity()
        }
    }
    var appliedToLog: Bool = false {
        didSet {
            updateViewForAppliedToLog()
        }
    }
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
    }
    
    // MARK: - Custom Functions
    
    func updateViews() {
        backgroundColor = .white
        activityView.layer.cornerRadius = activityView.frame.height / 2
        selectionDotView.backgroundColor = .white
        selectionDotView.layer.cornerRadius = selectionDotView.frame.width / 2
    }
    
    // Updates View when activity is present
    func updateViewForActivity() {
        guard let activity = activitiy else {return}
        activityTitleLabel.text = activity.title
        if activity.averageRating > -1 {
            let backgroundColor = ColorHelper.getColorFoInt(number: Int(activity.averageRating.rounded()))
            activityView.backgroundColor = backgroundColor
            selectionDotView.backgroundColor = .white
            activityView.layer.borderWidth = 0
            if backgroundColor.useDarkText() {
                activityTitleLabel.textColor = UIColor.black
            } else {
                activityTitleLabel.textColor = UIColor.white
            }
        } else {
            activityTitleLabel.textColor = UIColor(named: "Black")
            activityView.backgroundColor = UIColor(named: "White")
            activityView.layer.borderColor = UIColor(named: "Black")!.cgColor
            activityView.layer.borderWidth = 1.5
            selectionDotView.backgroundColor = ColorHelper.getColorFoInt(number: 10)
        }
    }
    
    // Updates the cell if it is applied to a Log
    func updateViewForAppliedToLog() {
        if appliedToLog {
            selectionDotView.isHidden = false
        } else {
            selectionDotView.isHidden = true
        }
    }
}
