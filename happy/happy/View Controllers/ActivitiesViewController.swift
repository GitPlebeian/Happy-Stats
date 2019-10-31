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
    
    @IBOutlet weak var activitiesTableView: UITableView!
    @IBOutlet weak var activitiesNavigationBar: UINavigationBar!
    @IBOutlet weak var addActivityButton: UIBarButtonItem!
    
    // MARK: - Properties
    
    var alertController: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activitiesTableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc func alertTextFieldDidChange(_ sender: UITextField) {
        alertController?.actions[0].isEnabled = sender.text!.count > 0
    }
    
    @IBAction func createNewActivityButtonTapped(_ sender: Any) {
        createActivityAlert()
    }
    
    // MARK: - Custom Functions
    
    // Updates view attributes and colors
    func updateViews() {
        activitiesTableView.backgroundColor = .white
        activitiesNavigationBar.barTintColor = .white
        if var textAttributes = activitiesNavigationBar.titleTextAttributes {
            textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.black
            activitiesNavigationBar.titleTextAttributes = textAttributes
            
        }
        activitiesTableView.separatorStyle = .none
        addActivityButton.image = UIImage(named: "addIcon")
    }
    
    // presents alert for creating an activity
    func createActivityAlert() {
        alertController = UIAlertController(title: "New Activity", message: nil, preferredStyle: .alert)
        alertController?.addTextField { (textField) in
            textField.font = UIFont(name: "SFProDisplay-Light", size: 15)
            textField.placeholder = "Title"
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
        }
        
        let addActivityAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let activityTitle = self.alertController?.textFields?[0].text else {return}
            if !activityTitle.isEmpty {
                let feedback = UINotificationFeedbackGenerator()
                feedback.prepare()
                ActivityController.shared.createActivity(title: activityTitle)
                self.activitiesTableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addActivityAction.isEnabled = false
        
        alertController?.addAction(addActivityAction)
        alertController?.addAction(cancelAction)
        guard let alertController = alertController else {return}
        present(alertController, animated: true)
    }
    
    // Presents a basic message alert
    func presentBasicAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    // Presents an alert whenever you select an activity. The alert allows you to rename or delete
    func presentActivitySelectionAlert(activity: Activity) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            self.presentDeleteAlert(activity: activity)
        }
        let renameAction = UIAlertAction(title: "Rename", style: .default) { (_) in
            self.presentRenameAlert(activity: activity)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(renameAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    // An are you sure alert when you request to delete an activity
    func presentDeleteAlert(activity: Activity) {
        let alertController = UIAlertController(title: "Delete Activity", message: "Are you sure you want to delete this activity? This will remove the activity from any logs it has been applied too.", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "I'm Sure", style: .destructive) { (_) in
            let feedback = UINotificationFeedbackGenerator()
            feedback.prepare()
            ActivityController.shared.deleteActivity(activity: activity)
            self.activitiesTableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true)
    }
    
    // An alert with text field that will change the activity's title
    func presentRenameAlert(activity: Activity) {
        let alertController = UIAlertController(title: "Rename Activity", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.text = activity.title
            textField.font = UIFont(name: "SFProDisplay-Light", size: 15)
            textField.placeholder = "Title"
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
        }
        let renameAction = UIAlertAction(title: "Rename", style: .default) { (_) in
            guard let activityTitle = alertController.textFields?[0].text else {return}
            if !activityTitle.isEmpty {
                let feedback = UINotificationFeedbackGenerator()
                ActivityController.shared.renameActivity(title: activityTitle, activity: activity)
                self.activitiesTableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(renameAction)
        present(alertController, animated: true)
    }
} // End Class

extension ActivitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Num Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ActivityController.shared.activities.count
    }
    
    // Cell for row at
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = activitiesTableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath) as? ActivityTableViewCell else {return UITableViewCell()}
        
        let activity = ActivityController.shared.activities[indexPath.row]
        
        cell.activity = activity
        return cell
    }
    
    // Did Select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activity = ActivityController.shared.activities[indexPath.row]
        let feedback = UISelectionFeedbackGenerator()
        feedback.selectionChanged()
        presentActivitySelectionAlert(activity: activity)
    }
}
