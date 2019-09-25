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
    // MARK: - Custom Functions
    
    func updateViews() {
        if DarkModeController.shared.darkMode.enabled {
            
        } else {
            past30DaysLabel.textColor = .black
            past30DaysResultsLabel.textColor = .black
            past30DaysResultsView.backgroundColor = .white
            
            past90DaysResultsView.backgroundColor = .white
            past90DaysLabel.textColor = .black
            past90DaysResultsLabel.textColor = .black
            
            past180DaysLabel.textColor = .black
            past180DaysResultsLabel.textColor = .black
            past180DaysResultsView.backgroundColor = .white
            
            pastYearLabel.textColor = .black
            pastYearResultsLabel.textColor = .black
            pastYearResultsView.backgroundColor = .white
        }
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
        past30DaysView.backgroundColor = ColorHelper.getColorFoInt(number: Int(Double(average30).rounded()))
        if average30 == -1 {
            past30DaysView.layer.borderColor = UIColor.black.cgColor
            past30DaysView.layer.borderWidth = 1.5
            past30DaysResultsLabel.text = ""
        } else {
            past30DaysView.layer.borderWidth = 0
            past30DaysResultsLabel.text = "\(average30)"
        }
    
        past90DaysLabel.text = "90 Day Average"
        past90DaysView.backgroundColor = ColorHelper.getColorFoInt(number: Int(Double(average90).rounded()))
        past90DaysResultsLabel.text = "\(average90)"
        if average90 == -1 {
            past90DaysView.layer.borderColor = UIColor.black.cgColor
            past90DaysView.layer.borderWidth = 1.5
            past90DaysResultsLabel.text = ""
        } else {
            past90DaysView.layer.borderWidth = 0
            past90DaysResultsLabel.text = "\(average90)"
        }
        
        past180DaysLabel.text = "180 Day Average"
        past180DaysView.backgroundColor = ColorHelper.getColorFoInt(number: Int(Double(average180).rounded()))
        past180DaysResultsLabel.text = "\(average180)"
        if average180 == -1 {
            past180DaysView.layer.borderColor = UIColor.black.cgColor
            past180DaysView.layer.borderWidth = 1.5
            past180DaysResultsLabel.text = ""
        } else {
            past180DaysView.layer.borderWidth = 0
            past180DaysResultsLabel.text = "\(average180)"
        }
        
        pastYearLabel.text = "Year Average"
        pastYearView.backgroundColor = ColorHelper.getColorFoInt(number: Int(Double(averageYear).rounded()))
        pastYearResultsLabel.text = "\(averageYear)"
        if averageYear == -1 {
            pastYearView.layer.borderColor = UIColor.black.cgColor
            pastYearView.layer.borderWidth = 1.5
            pastYearResultsLabel.text = ""
        } else {
            pastYearView.layer.borderWidth = 0
            pastYearResultsLabel.text = "\(averageYear)"
        }
    }
}
