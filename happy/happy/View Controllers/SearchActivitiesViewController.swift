//
//  searchActivitiesViewController.swift
//  happy
//
//  Created by Jackson Tubbs on 11/2/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

protocol SearchActivityViewControllerDelegate {
    func userSelectedActivityToSearch(activity: Activity)
}

class SearchActivitiesViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var searchActivitiesTextField: UITextField!
    @IBOutlet weak var activitiesTableView: UITableView!
    
    // MARK: - Properties
    
    var activitiesToShowUser: [Activity] = []
    var isSearching = false
    var delegate: SearchActivityViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activitiesTableView.delegate = self
        activitiesTableView.dataSource = self
        searchActivitiesTextField.delegate = self
    }
    
    // MARK: - Actions

    @IBAction func searchTextFieldValueChanged(_ sender: Any) {
        updateTableViewForSearch()
    }
    
    // MARK: - Custom Functions
    
    // Updates vies for viewDidLoad()
    func updateViews() {
        
    }
    
    func updateTableViewForSearch() {
        guard let searchText = searchActivitiesTextField.text else {return}
        activitiesToShowUser.removeAll()
        
        isSearching = true
        
        for activity in ActivityController.shared.activities {
            if activity.title.lowercased().contains(searchText.lowercased()){
                activitiesToShowUser.append(activity)
            }
        }
        
        if searchText == "" {
            isSearching = false
        }
        
        activitiesTableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
} // End of class

// MARK: - Extensions

// TableView
extension SearchActivitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Num Rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching == true {
            return activitiesToShowUser.count
        } else {
            return ActivityController.shared.activities.count
        }
    }
    
    // Cell for row at
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = activitiesTableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath) as? ActivityTableViewCell else {return UITableViewCell()}
        
        let activity: Activity
        if isSearching == true {
            activity = activitiesToShowUser[indexPath.row]
        } else {
            activity = ActivityController.shared.activities[indexPath.row]
        }
        
        cell.activity = activity
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            let activity = activitiesToShowUser[indexPath.row]
            delegate?.userSelectedActivityToSearch(activity: activity)
        } else {
            let activity = ActivityController.shared.activities[indexPath.row]
            delegate?.userSelectedActivityToSearch(activity: activity)
        }
        self.dismiss(animated: true)
    }
}

// TextField
extension SearchActivitiesViewController: UITextFieldDelegate {
    
    // ShouldReturn
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        isSearching = false
        activitiesTableView.reloadData()
        return true
    }
}
