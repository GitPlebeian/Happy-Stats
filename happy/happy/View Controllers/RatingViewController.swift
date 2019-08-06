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
    @IBOutlet weak var actionsTableView: UITableView!
    
    
    // MARK: - Properties
    
    var rating: Int = 5
    var date = Date()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionsTableView.allowsMultipleSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Will set the rating to default value
        rating = 5
        ratingNumberLabel.text = String(rating)
        
        // Will set the today's date
        date = Date()
        let format = DateFormatter()
        format.dateFormat = "MM-dd-yyyy"
        todaysDateLabel.text = format.string(from: date)
        
        // Reload things to the table view
        actionsTableView.reloadData()
    }
    
    // MARK: - Actions
    
    // Will update and display the new rating value
    @IBAction func changeSlider(_ sender: UISlider) {
        sender.value = round(sender.value)
        rating = Int(sender.value)
        ratingNumberLabel.text = String(rating)
    }
    
    @IBAction func saveLogButtonTapped(_ sender: Any) {
        LogController.shared.createNewLog(rating: rating, date: date)
        ActionController.shared.dislectAllActions()
    }
    
    // MARK: - Table View Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ActionController.shared.actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath) as? ActionForRatingViewTableViewCell else {return UITableViewCell()}
        
        let action = ActionController.shared.actions[indexPath.row]
        cell.action = action
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ActionController.shared.toggleSelection(index: indexPath.row)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
} // End of class
