//
//  LogDetailViewController.swift
//  happy
//
//  Created by Jackson Tubbs on 8/12/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class LogDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var logDateLabel: UILabel!
    @IBOutlet weak var logRatingLabel: UILabel!
    @IBOutlet weak var logActivitiesTableView: UITableView!
    
    
    // MARK: - Properties
    
    var displayActivities: [[Activity]] = [[]]
    var editMode = false
    
    var log: Log? {
        didSet {
            updateView()
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Custom Funcitons
    
    func updateView(){
        loadViewIfNeeded()
        guard let log = log, let date = log.date else {return}
        let format = DateFormatter()
        format.dateFormat = "MM-dd-yyyy"
        logDateLabel.text = format.string(from: date)
        logRatingLabel.text = "\(log.rating)"
        self.title = format.string(from: date)
        
        guard let activitiesAsNS = log.activities, let activitiesToAdd = activitiesAsNS.array as? [Activity] else {return}
        
        for activity in activitiesToAdd {
            displayActivities[0].append(activity)
        }
        displayActivities.append(ActivityController.shared.getActivitiesNotInLog(log: log))
    }
    
    func updateLogChanges() {
        guard let log = log else {return}
        LogController.shared.updateLog(log: log, selectedActivities: displayActivities[0], rating: Int(log.rating))
    }
    
    // MARK: - Actions
    
    @IBAction func editToggleButtonTapped(_ sender: Any) {
        editMode = !editMode
        if editMode == true {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(editToggleButtonTapped))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editToggleButtonTapped))
            updateLogChanges()
        }
        logActivitiesTableView.reloadData()
        
    }
    
    

} // End of class

// MARK: Table View Functions

extension LogDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if editMode == true {
            switch section {
            case 0:
                return "Applied Activities"
            case 1:
                return "Other Activities"
            default:
                return nil
            }
        } else {
            return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if editMode == true {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayActivities[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = logActivitiesTableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
        
        guard let activityName = displayActivities[indexPath.section][indexPath.row].title else {return UITableViewCell()}
    
        cell.textLabel?.text = String(activityName)
        
        if indexPath.section == 0 && editMode == false{
            cell.selectionStyle = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard editMode == true else {return}
        if indexPath.section == 0 {
            let movingActivity = displayActivities[indexPath.section][indexPath.row]
            displayActivities[indexPath.section].remove(at: indexPath.row)
            displayActivities[1].append(movingActivity)
        } else {
            let movingActivity = displayActivities[indexPath.section][indexPath.row]
            displayActivities[indexPath.section].remove(at: indexPath.row)
            displayActivities[0].append(movingActivity)
        }
        logActivitiesTableView.reloadData()
    }
}
