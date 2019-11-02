//
//  StatisticsContentViewController.swift
//  happy
//
//  Created by Jackson Tubbs on 9/20/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class StatisticsContentViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var privacyPolicyButton: UIButton!
    
    @IBOutlet weak var past30DaysView: UIView!
    @IBOutlet weak var past30DaysLabel: UILabel!
    @IBOutlet weak var past30DaysResultsView: UIView!
    @IBOutlet weak var past30DaysResultsLabel: UILabel!
    
    @IBOutlet weak var past90DaysView: UIView!
    @IBOutlet weak var past90DaysLabel: UILabel!
    @IBOutlet weak var past90DaysResultsView: UIView!
    @IBOutlet weak var past90DaysResultsLabel: UILabel!
    
    @IBOutlet weak var past180DaysView: UIView!
    @IBOutlet weak var past180DaysLabel: UILabel!
    @IBOutlet weak var past180DaysResultsView: UIView!
    @IBOutlet weak var past180DaysResultsLabel: UILabel!
    
    @IBOutlet weak var pastYearView: UIView!
    @IBOutlet weak var pastYearLabel: UILabel!
    @IBOutlet weak var pastYearResultsView: UIView!
    @IBOutlet weak var pastYearResultsLabel: UILabel!
    
    // MARK: - Properties
    
    var average30: Double = -1
    var average90: Double = -1
    var average180: Double = -1
    var averageYear: Double = -1
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        runCalculations()
        updateViewsForCalculations()
    }
    
    // MARK: - Actions
    
    @IBAction func privacyPolicyButtonTapped(_ sender: Any) {
        if let url = URL(string: "https://sites.google.com/view/hapistats-privacy-policy/home") {
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: - Override Functions
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateViewsForCalculations()
    }
    
    // MARK: - Custom Functions
    
    // Updates views for viewDidLoad
    func updateViews() {
        privacyPolicyButton.setTitleColor((UIColor(named: "Black")), for: .normal)
        
        privacyPolicyButton.tintColor = .systemBlue
        past30DaysView.layer.cornerRadius = 15
        past30DaysResultsView.layer.cornerRadius = past30DaysResultsView.frame.height / 2
        
        past90DaysView.layer.cornerRadius = 15
        past90DaysResultsView.layer.cornerRadius = past90DaysResultsView.frame.height / 2
        
        past180DaysView.layer.cornerRadius = 15
        past180DaysResultsView.layer.cornerRadius = past180DaysResultsView.frame.height / 2
        
        pastYearView.layer.cornerRadius = 15
        pastYearResultsView.layer.cornerRadius = pastYearResultsView.frame.height / 2
    }
    
    // Run calculations to average out time periods
    func runCalculations() {
        average30 = StatisticFunctions.getAverageHappinessForDays(numDays: 30)
        average90 = StatisticFunctions.getAverageHappinessForDays(numDays: 90)
        average180 = StatisticFunctions.getAverageHappinessForDays(numDays: 180)
        averageYear = StatisticFunctions.getAverageHappinessForDays(numDays: 365)
    }
    
    // Updates view for calculations
    func updateViewsForCalculations() {
        loadViewIfNeeded()
        past30DaysLabel.text = "30 Day Average"
        var color = ColorHelper.getColorFoInt(number: Int(Double(average30).rounded()))
        past30DaysView.backgroundColor = color
        if average30 == -1 {
            past30DaysView.layer.borderColor = UIColor(named: "Black")!.cgColor
            past30DaysView.layer.borderWidth = 1.5
            past30DaysResultsLabel.text = ""
        } else {
            past30DaysView.layer.borderWidth = 0
            past30DaysResultsLabel.text = "\(average30)"
            if color.useDarkText() {
                past30DaysLabel.textColor = .black
            } else {
                past30DaysLabel.textColor = .white
            }
        }
        
        past90DaysLabel.text = "90 Day Average"
        color = ColorHelper.getColorFoInt(number: Int(Double(average90).rounded()))
        past90DaysView.backgroundColor = color
        past90DaysResultsLabel.text = "\(average90)"
        if average90 == -1 {
            past90DaysView.layer.borderColor = UIColor(named: "Black")!.cgColor
            past90DaysView.layer.borderWidth = 1.5
            past90DaysResultsLabel.text = ""
        } else {
            past90DaysView.layer.borderWidth = 0
            past90DaysResultsLabel.text = "\(average90)"
            if color.useDarkText() {
                past90DaysLabel.textColor = .black
            } else {
                past90DaysLabel.textColor = .white
            }
        }
        
        past180DaysLabel.text = "180 Day Average"
        color = ColorHelper.getColorFoInt(number: Int(Double(average180).rounded()))
        past180DaysView.backgroundColor = color
        past180DaysResultsLabel.text = "\(average180)"
        if average180 == -1 {
            past180DaysView.layer.borderColor = UIColor(named: "Black")!.cgColor
            past180DaysView.layer.borderWidth = 1.5
            past180DaysResultsLabel.text = ""
        } else {
            past180DaysView.layer.borderWidth = 0
            past180DaysResultsLabel.text = "\(average180)"
            if color.useDarkText() {
                past180DaysLabel.textColor = .black
            } else {
                past180DaysLabel.textColor = .white
            }
        }
        
        pastYearLabel.text = "Year Average"
        color = ColorHelper.getColorFoInt(number: Int(Double(averageYear).rounded()))
        pastYearView.backgroundColor = color
        pastYearResultsLabel.text = "\(averageYear)"
        if averageYear == -1 {
            pastYearView.layer.borderColor = UIColor(named: "Black")!.cgColor
            pastYearView.layer.borderWidth = 1.5
            pastYearResultsLabel.text = ""
        } else {
            pastYearView.layer.borderWidth = 0
            pastYearResultsLabel.text = "\(averageYear)"
            if color.useDarkText() {
                pastYearLabel.textColor = .black
            } else {
                pastYearLabel.textColor = .white
            }
        }
    }
}
