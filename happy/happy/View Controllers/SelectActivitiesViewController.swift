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
    
    @IBOutlet weak var saveLogButton: UIButton!
    @IBOutlet weak var activitiesTableView: UITableView!
    @IBOutlet weak var activitiesSearchBar: UISearchBar!
    @IBOutlet weak var logRatingSlider: UISlider!
    @IBOutlet weak var logRatingLabel: UILabel!
    @IBOutlet weak var logRatingView: UIView!
    
    // MARK: - Properties
    
    var log: Log? {
        didSet {
            rating = Int(log!.rating)
        }
    }
    var selectedDate: Date?
    var displayActivities: [[Activity]] = [[],[]]
    var allApplied = false
    var allActivities = false
    var searchedActivities: [Activity] = []
    var resultSearchController = UISearchController()
    
    var rating = 5
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        activitiesTableView.delegate = self
        activitiesTableView.dataSource = self
        activitiesTableView.showsVerticalScrollIndicator = false
        activitiesSearchBar.delegate = self
        setupSearchBar()
        
        updateViewsForRatingChange()
        updateViewsForLog()
        logRatingView.layer.cornerRadius = logRatingView.frame.height / 2
        saveLogButton.layer.cornerRadius = saveLogButton.frame.height / 2
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            return controller
        })()
    }
    
    // MARK: - Actions
    
    @IBAction func saveActivitiesButtonTapped(_ sender: Any) {
        
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.success)
        
        if let log = log {
            LogController.shared.updateLog(log: log, selectedActivities: displayActivities[0], rating: rating)
        } else {
            guard let selectedDate = selectedDate else {return}
            LogController.shared.createLog(date: selectedDate, rating: rating, activities: displayActivities[0])
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ratingSliderValueChanged(_ sender: Any) {
        rating = Int(logRatingSlider.value.rounded())
        logRatingSlider.value = Float(rating)
        updateViewsForRatingChange()
    }
    
    // MARK: - Custom Functions
    
    func updateViewsForRatingChange() {
        logRatingLabel.text = "\(rating)"
        logRatingSlider.value = Float(rating)
        saveLogButton.backgroundColor = RatingColors.getColorFoInt(number: rating)
        logRatingView.backgroundColor = RatingColors.getColorFoInt(number: rating)
        logRatingSlider.minimumTrackTintColor = RatingColors.getColorFoInt(number: rating)
        logRatingSlider.thumbTintColor = RatingColors.getColorFoInt(number: rating)
    }
    
    func setAppliedVariables() {
        if displayActivities[0].count == 0 && displayActivities[1].count > 0{
            allApplied = false
            allActivities = true
        } else if displayActivities[1].count == 0 && displayActivities[0].count > 0 {
            allApplied = true
            allActivities = false
        } else {
            allApplied = false
            allActivities = false
        }
    }
    
    func setupSearchBar() {
        if let searchBarTextField = activitiesSearchBar.value(forKey: "searchField") as? UITextField {
            searchBarTextField.textColor = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            searchBarTextField.font = UIFont(name: "SFProDisplay-Light", size: 17)
        }
    }
    
    func updateViewsForLog() {
        loadViewIfNeeded()
        if let log = log,
            let nsLogActivities = log.activities,
            let logActivities = Array(nsLogActivities) as? [Activity] {
            displayActivities[0] = logActivities
            displayActivities[1] = ActivityController.shared.getActivitiesNotInLog(log: log)
            setAppliedVariables()
            activitiesTableView.reloadData()
        } else {
            displayActivities[1] = ActivityController.shared.activities
            setAppliedVariables()
            activitiesTableView.reloadData()
        }
    }
}

extension SelectActivitiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        let headerView = UIView()
        headerView.backgroundColor = .white
        let headerLabel: UILabel = {
            let label = UILabel()
            label.frame = CGRect(x: 2, y: 0, width: 150, height: 24)
            label.font = UIFont(name: "SFProDisplay-Medium", size: 18)
            
            if allActivities {
                label.text = "Activities"
            } else if allApplied {
                label.text = "Applied"
            } else if section == 0 {
                label.text = "Applied"
            } else {
                label.text = "Activities"
            }
            return label
        }()
        
        headerView.addSubview(headerLabel)
        
        
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if allApplied || allActivities{
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allApplied {
            return displayActivities[0].count
        }
        if allActivities {
            return displayActivities[1].count
        }
        return displayActivities[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = activitiesTableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as? ActivityTableViewCell else {return UITableViewCell()}
        
        if allApplied {
            let activity = displayActivities[0][indexPath.row]
            cell.activitiy = activity
            cell.appliedToLog = true
            return cell
        } else if allActivities {
            let activity = displayActivities[1][indexPath.row]
            cell.activitiy = activity
            cell.appliedToLog = false
            return cell
        }
        
        if indexPath.section == 0 {
            let activity = displayActivities[0][indexPath.row]
            cell.activitiy = activity
            cell.appliedToLog = true
            return cell
        } else {
            let activity = displayActivities[1][indexPath.row]
            cell.activitiy = activity
            cell.appliedToLog = false
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let feedback = UISelectionFeedbackGenerator()
        feedback.selectionChanged()
        
        if allApplied {
            let movingActivity = displayActivities[0][indexPath.row]
            displayActivities[0].remove(at: indexPath.row)
            displayActivities[1].append(movingActivity)
        } else if allActivities {
            let movingActivity = displayActivities[1][indexPath.row]
            displayActivities[1].remove(at: indexPath.row)
            displayActivities[0].append(movingActivity)
        } else if indexPath.section == 0 {
            let movingActivity = displayActivities[indexPath.section][indexPath.row]
            displayActivities[indexPath.section].remove(at: indexPath.row)
            displayActivities[1].append(movingActivity)
        } else {
            let movingActivity = displayActivities[indexPath.section][indexPath.row]
            displayActivities[indexPath.section].remove(at: indexPath.row)
            displayActivities[0].append(movingActivity)
        }
        setAppliedVariables()
        activitiesTableView.reloadData()
    }
}

extension SelectActivitiesViewController: UISearchBarDelegate, UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        print("Boi")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        activitiesSearchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Starting")
    }
    
}
