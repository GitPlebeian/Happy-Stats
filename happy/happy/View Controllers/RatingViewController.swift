//
//  RatingViewController.swift
//  happy
//
//  Created by Jackson Tubbs on 8/3/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    
    @IBOutlet weak var ratingNumberLabel: UILabel!
    @IBOutlet weak var todaysDateLabel: UILabel!
    @IBOutlet weak var activityTableView: UITableView!
    
    
    // MARK: - Properties
    
    var rating: Int = 5
    var date = Date()
    
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
        StatController.shared.createLog(date: date, rating: rating)
//        ActivityController.shared.dislectAllActions()
    }
    
    // MARK: - Table View Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return ActivityController.shared.actions.count
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath) as? ActionForRatingViewTableViewCell else {return UITableViewCell()}
        
//        let action = ActivityController.shared.actions[indexPath.row]
//        cell.action = action
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        ActivityController.shared.toggleSelection(index: indexPath.row)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    }
} // End of class
