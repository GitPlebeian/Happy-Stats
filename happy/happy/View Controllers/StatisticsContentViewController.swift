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
    
    @IBOutlet weak var averageXDaysView: UIView!
    @IBOutlet weak var averageXDaysResultView: UIView!
    @IBOutlet weak var pastXDaysLabel: UILabel!
    @IBOutlet weak var averageXDaysResultLabel: UILabel!
    
    // MARK: - Properties
    
    var rollingRatingAveragePeriod: Int = -1
    var averageForXDays: Double = -1
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        runCalculations()
        updateViewsForCalculations()
    }
    

    // MARK: - Custom Functions
    
    func updateViews() {
        if DarkModeController.shared.darkMode.enabled {
            
        } else {
            pastXDaysLabel.textColor = .black
            averageXDaysResultLabel.textColor = .black
            averageXDaysResultView.backgroundColor = .white
        }
        averageXDaysView.layer.cornerRadius = 15
        averageXDaysResultView.layer.cornerRadius = averageXDaysResultView.frame.height / 2
    }
    
    func runCalculations() {
        guard let settings = SettingsController.shared.settings else {return}
        rollingRatingAveragePeriod = settings.rollingRatingAveragePeriod
        averageForXDays = StatisticFunctions.getAverageHappinessForDays(numDays:
            rollingRatingAveragePeriod)
        
    }
    
    func updateViewsForCalculations() {
        loadViewIfNeeded()
        pastXDaysLabel.text = "Past \(rollingRatingAveragePeriod) Days"
        averageXDaysView.backgroundColor = ColorHelper.getColorFoInt(number: Int(Double(averageForXDays).rounded()))
        averageXDaysResultLabel.text = "\(averageForXDays)"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
