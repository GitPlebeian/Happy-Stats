//
//  RatingViewController.swift
//  happy
//
//  Created by Jackson Tubbs on 8/3/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController{
    
    // MARK: - Outlets
    
    @IBOutlet weak var ratingNumberLabel: UILabel!
    @IBOutlet weak var todaysDateLabel: UILabel!
    @IBOutlet weak var activityTableView: UITableView!
    @IBOutlet weak var ratingSlider: UISlider!
    
    
    // MARK: - Properties
    
    var rating: Int = 5
    var date = Date()
    var numbersOfActivitiesSelected: [IndexPath] = []

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingNumberLabel.text = String(rating)
        date = Date()
        let format = DateFormatter()
        format.dateFormat = "MM-dd-yyyy"
        todaysDateLabel.text = format.string(from: date)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            activityTableView.reloadData()
    }
    
    // MARK: - Actions
    
    // Will update and display the new rating value
    @IBAction func changeSlider(_ sender: UISlider) {
        sender.value = round(sender.value)
        rating = Int(sender.value)
        ratingNumberLabel.text = String(rating)
    }
    
    @IBAction func saveLogButtonTapped(_ sender: Any) {
        LogController.shared.createLog(date: date, rating: rating,activities: ActivityController.shared.getAllSelectedActivities())
        ActivityController.shared.dislectAllActivities()
        for row in numbersOfActivitiesSelected {
            activityTableView.deselectRow(at: row, animated: true)
        }
    }
} // End of class

extension RatingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ActivityController.shared.activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as? ActivityForRatingViewTableViewCell else {return UITableViewCell()}
        
        let activity = ActivityController.shared.activities[indexPath.row]
        cell.activity = activity
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ActivityController.shared.toggleSelection(indexOfActivity: indexPath.row)
        numbersOfActivitiesSelected.append(indexPath)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        ActivityController.shared.toggleSelection(indexOfActivity: indexPath.row)
        guard let index = numbersOfActivitiesSelected.firstIndex(of: indexPath) else {return}
        numbersOfActivitiesSelected.remove(at: index)
    }
}
