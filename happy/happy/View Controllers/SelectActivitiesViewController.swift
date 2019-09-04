//
//  SelectActivitiesViewController.swift
//  happy
//
//  Created by Jackson Tubbs on 9/3/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class SelectActivitiesViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var activitiesTableView: UITableView!
    @IBOutlet weak var activitiesSearchBar: UISearchBar!
    
    // MARK: - Properties
    
    var log: Log? {
        didSet {
            updateViewsForLog()
        }
    }
    var displayActivities: [[Activity]] = [[],[]]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        activitiesTableView.delegate = self
        activitiesTableView.dataSource = self
        
        activitiesSearchBar.delegate = self
        
        setupSearchBar()
    }
    
    // MARK: - Actions
    
    @IBAction func saveActivitiesButtonTapped(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Custom Functions
    
    func setupSearchBar() {
        if let searchBarTextField = activitiesSearchBar.value(forKey: "searchField") as? UITextField {
            searchBarTextField.textColor = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            searchBarTextField.font = UIFont(name: "SFProDisplay-Light", size: 15)
        }
    }
    
    func updateViewsForLog() {
        loadViewIfNeeded()
        guard let log = log,
            let nsLogActivities = log.activities,
            let logActivities = Array(nsLogActivities) as? [Activity] else {return}
        displayActivities[0] = logActivities
        displayActivities[1] = ActivityController.shared.getActivitiesNotInLog(log: log)
        activitiesTableView.reloadData()
    }
}

extension SelectActivitiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return displayActivities[section].count
        } else {
            return displayActivities[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = activitiesTableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
        
        if indexPath.section == 0 {
            let activity = displayActivities[0][indexPath.row]
            cell.textLabel?.text = "\(activity.title!)"
            
            return cell
        } else {
            let activity = displayActivities[1][indexPath.row]
            cell.textLabel?.text = "\(activity.title!)"
            
            return cell
        }
    }
    
    
}

extension SelectActivitiesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        activitiesSearchBar.resignFirstResponder()
    }
}
