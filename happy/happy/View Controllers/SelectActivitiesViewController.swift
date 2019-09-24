//
//  SelectActivitiesViewController.swift
//  happy
//
//  Created by Jackson Tubbs on 9/3/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

protocol SelectActivitiesViewControllerDelegate {
    func setCurrentLog(log: Log?)
}

class SelectActivitiesViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var saveLogButton: UIButton!
    @IBOutlet weak var activitiesTableView: UITableView!
    @IBOutlet weak var activitiesSearchBar: UISearchBar!
    @IBOutlet weak var logRatingSlider: UISlider!
    @IBOutlet weak var logRatingLabel: UILabel!
    @IBOutlet weak var logRatingView: UIView!
    @IBOutlet weak var titleNavigationItem: UINavigationItem!
    
    // MARK: - Properties
    
    var delegate: SelectActivitiesViewControllerDelegate?
    var log: Log? {
        didSet {
            rating = Int(log!.rating)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M-d-yyyy"
            updateNavBarTitle(title: dateFormatter.string(from: log!.date))
        }
    }
    var selectedDate: Date? {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M-d-yyyy"
            updateNavBarTitle(title: dateFormatter.string(from: selectedDate!))
        }
    }
    var displayActivities: [[Activity]] = [[],[]]
    var allApplied = false
    var allActivities = false
    var searchedActivities: [Activity] = []
    var isSearching = false
    var didLoad = false
    
    var rating = 5
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.setNavigationBarHidden(false, animated: false)
        
        activitiesTableView.delegate = self
        activitiesTableView.dataSource = self
        activitiesTableView.showsVerticalScrollIndicator = false
        activitiesSearchBar.delegate = self
        setupSearchBar()
        
        updateViews()
        updateViewsForRatingChange()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCellsWithActivities()
//        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func deleteLogButtonTapped(_ sender: Any) {
        presentDeleteLogAlert()
    }
    
    @IBAction func saveActivitiesButtonTapped(_ sender: Any) {
        let feedback = UINotificationFeedbackGenerator()
        feedback.prepare()

        if let log = log {
            LogController.shared.updateLog(log: log, newRating: rating, newActivities: displayActivities[0]) { (log) in
                DispatchQueue.main.async {
                    if let log = log {
                        self.delegate?.setCurrentLog(log: log)
                        feedback.notificationOccurred(.success)
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        feedback.notificationOccurred(.error)
                        self.presentErrorAlert(message: "Unable to save to ICloud")
                    }
                }
            }
        } else {
            guard let selectedDate = selectedDate else {return}
            LogController.shared.createLog(date: selectedDate, rating: rating, activities: displayActivities[0]) { (log) in
                DispatchQueue.main.async {
                    if let log = log {
                        self.delegate?.setCurrentLog(log: log)
                        feedback.notificationOccurred(.success)
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        feedback.notificationOccurred(.error)
                        self.presentErrorAlert(message: "Unable to save to ICloud")
                    }
                }
            }
        }
    }
    
    @IBAction func ratingSliderValueChanged(_ sender: Any) {
        rating = Int(logRatingSlider.value.rounded())
        logRatingSlider.value = Float(rating)
        updateViewsForRatingChange()
    }
    
    // MARK: - Custom Functions
    
    func updateViews() {
        if DarkModeController.shared.darkMode.enabled  {
            activitiesSearchBar.searchTextField.backgroundColor = .black
        } else {
            activitiesSearchBar.searchTextField.leftView = nil
            activitiesSearchBar.searchTextField.tintColor = .black
            activitiesTableView.backgroundColor = .white
            logRatingLabel.textColor = .black
        }
        logRatingView.layer.cornerRadius = logRatingView.frame.height / 2
        saveLogButton.layer.cornerRadius = saveLogButton.frame.height / 2
        logRatingView.layer.borderWidth = 1.5
        logRatingView.layer.borderColor = UIColor.black.cgColor
        saveLogButton.layer.borderWidth = 1.5
        saveLogButton.layer.borderColor = UIColor.black.cgColor
    }
    
    func updateNavBarTitle(title: String) {
        self.title = title
    }
    
    // Presents a message to the user via alert
    func presentErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func presentDeleteLogAlert() {
        let alertController = UIAlertController(title: "Delete Log", message: "Are you sure?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            guard let log = self.log else {return}
            let feedback = UINotificationFeedbackGenerator()
            feedback.prepare()
            LogController.shared.deleteLog(log: log, completion: { (success) in
                DispatchQueue.main.async {
                    if success {
                        self.delegate?.setCurrentLog(log: nil)
                        feedback.notificationOccurred(.success)
                    } else {
                        feedback.notificationOccurred(.error)
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func updateViewsForRatingChange() {
        logRatingLabel.text = "\(rating)"
        logRatingSlider.value = Float(rating)
        saveLogButton.backgroundColor = ColorHelper.getColorFoInt(number: rating)
        logRatingView.backgroundColor = ColorHelper.getColorFoInt(number: rating)
        logRatingSlider.minimumTrackTintColor = ColorHelper.getColorFoInt(number: rating)
        logRatingSlider.thumbTintColor = ColorHelper.getColorFoInt(number: rating)
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
    
    func updateCellsWithActivities() {
        loadViewIfNeeded()
        if didLoad {
            for selectedActivity in displayActivities[0] {
                if ActivityController.shared.activities.contains(selectedActivity) == false {
                    let indexToRemove = displayActivities[0].firstIndex(of: selectedActivity)
                    displayActivities[0].remove(at: indexToRemove!)
                }
            }
            var deselectedActivities: [Activity] = []
            for activity in ActivityController.shared.activities {
                if displayActivities[0].contains(activity) == false {
                    deselectedActivities.append(activity)
                }
            }
            displayActivities[1] = deselectedActivities
        } else {
            if let log = log {
                displayActivities[0] = log.activities
                displayActivities[1] = ActivityController.shared.getActivitiesNotInLog(log: log)
            } else {
                displayActivities[1] = ActivityController.shared.activities
            }
        }
        if log != nil {
            let deleteLogNavigationBarItem = UIBarButtonItem(image: UIImage(named: "deleteIcon"), style: .done, target: self, action: #selector(deleteLogButtonTapped(_:)))
            self.navigationItem.rightBarButtonItem = deleteLogNavigationBarItem
        }
        setAppliedVariables()
        activitiesTableView.reloadData()
        if displayActivities[0].count == 0 && displayActivities[1].count == 0 {
            activitiesTableView.isHidden = true
        } else {
            activitiesTableView.isHidden = false
        }
        didLoad = true
    }
} // End Of Class

// MARK: - Extensions

// TableView Controller for all activities
extension SelectActivitiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Height for header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isSearching {
            return 0
        }
        return 24
    }
    
    // Sets header view
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if isSearching {
            return nil
        }
        let headerView = UIView()
        headerView.backgroundColor = .white
        let headerLabel: UILabel = {
            let label = UILabel()
            label.frame = CGRect(x: 2, y: 0, width: 150, height: 24)
            label.font = UIFont(name: "SFProDisplay-Medium", size: 17)
            label.textColor = .black
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
    
    // Number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {
            return 1
        }
        if allApplied || allActivities{
            return 1
        } else {
            return 2
        }
    }
    
    // Num row for section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchedActivities.count
        }
        if allApplied {
            return displayActivities[0].count
        }
        if allActivities {
            return displayActivities[1].count
        }
        return displayActivities[section].count
    }
    
    // Configure cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = activitiesTableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as? ActivityTableViewCell else {return UITableViewCell()}
        if isSearching {
            let activity = searchedActivities[indexPath.row]
            cell.activitiy = activity
            if displayActivities[0].contains(activity) {
                cell.appliedToLog = true
            } else {
                cell.appliedToLog = false
            }
            return cell
        }
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
        } else if indexPath.section == 0 {
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
    
    // Did select row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let feedback = UISelectionFeedbackGenerator()
        feedback.selectionChanged()
        
        // Moves selected and unselected activities into their own groups
        if isSearching {
            if let index = displayActivities[0].firstIndex(of: searchedActivities[indexPath.row]) {
                let movingActivity = displayActivities[0][index]
                displayActivities[0].remove(at: index)
                displayActivities[1].append(movingActivity)
            } else if let index = displayActivities[1].firstIndex(of: searchedActivities[indexPath.row]) {
                let movingActivity = displayActivities[1][index]
                displayActivities[1].remove(at: index)
                displayActivities[0].append(movingActivity)
            }
        } else if allApplied {
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

extension SelectActivitiesViewController: UISearchBarDelegate{
    
    // Searchbar text did change
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true

        searchedActivities.removeAll(keepingCapacity: false)

        for activity in ActivityController.shared.activities {
            if activity.title.lowercased().contains(searchText.lowercased()){
                searchedActivities.append(activity)
            }
        }
        if searchText == "" {
            isSearching = false
        }

        activitiesTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        activitiesSearchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        activitiesTableView.reloadData()
    }
}
