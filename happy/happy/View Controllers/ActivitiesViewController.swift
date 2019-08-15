//
//  ThingsViewController.swift
//  happy
//
//  Created by Jackson Tubbs on 8/3/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class ActivitiesViewController: UIViewController{
    
    // MARK: - Outlets
    @IBOutlet weak var activityTableView: UITableView!
    
    
    
    // MARK: - Properties


    override func viewDidLoad() {
        super.viewDidLoad()
        activityTableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityTableView.reloadData()
//        ActivityController.shared.calculateHappinessForActions()
        activityTableView.estimatedRowHeight = UITableView.automaticDimension
//        thingTableView.rowHeight = 100
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showActivity" {

            if let index = activityTableView.indexPathForSelectedRow {

                guard let destinationVC = segue.destination as? ActivityDetailViewController else {return}

                let activity = ActivityController.shared.activities[index.row]
                destinationVC.activity = activity
            }
        }
    }
} // End Class

extension ActivitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ActivityController.shared.activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = activityTableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath) as? ActivityViewTableViewCell else {return UITableViewCell()}
        
        let activity = ActivityController.shared.activities[indexPath.row]
        
        cell.activity = activity
        cell.backgroundColor = UIColor(displayP3Red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        cell.layer.borderColor = UIColor(displayP3Red: 0.85, green: 0.85, blue: 0.85, alpha: 1).cgColor
        cell.layer.borderWidth = 0.5
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let activityToDelete = ActivityController.shared.activities[indexPath.row]
            ActivityController.shared.deleteActivity(activity: activityToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
