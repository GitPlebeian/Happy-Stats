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
    @IBOutlet weak var activitiesNavigationBar: UINavigationBar!
    @IBOutlet weak var addActivityButton: UIBarButtonItem!
    
    // MARK: - Properties

    var alertController: UIAlertController?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if DarkModeController.shared.darkMode.enabled {
            return .lightContent
        } else {
            if #available(iOS 13.0, *) {
                return .darkContent
            } else {
                return .default
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityTableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc func alertTextFieldDidChange(_ sender: UITextField) {
        alertController?.actions[0].isEnabled = sender.text!.count > 0
    }
    
    @IBAction func createNewActivityButtonTapped(_ sender: Any) {
        createActivityAlert()
    }
    
    // MARK: - Custom Functions
    
    func updateViews() {
        if DarkModeController.shared.darkMode.enabled {
            
        } else {
            activityTableView.backgroundColor = .white
            activitiesNavigationBar.barTintColor = .white
            if var textAttributes = activitiesNavigationBar.titleTextAttributes {
                textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.black
                activitiesNavigationBar.titleTextAttributes = textAttributes
                
            }
        }
        activityTableView.separatorStyle = .none
//        let addActivityBarButtonItem = UIBarButtonItem(image: UIImage(named: "AddIcon"), style: .done, target: self, action: #selector(createNewActivityButtonTapped(_:)))
//        addActivityButton = addActivityBarButtonItem
        addActivityButton.image = UIImage(named: "addIcon")
    }
    
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
                ActivityController.shared.createActivity(title: activityTitle, completion: { (success) in
                    DispatchQueue.main.async {
                        if success {
                            feedback.notificationOccurred(.success)
                            self.activityTableView.reloadData()
                        } else {
                            feedback.notificationOccurred(.error)
                            self.presentBasicAlert(title: "Error", message: "Unable to save to ICloud")
                        }
                    }
                })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addActivityAction.isEnabled = false
        
        alertController?.addAction(addActivityAction)
        alertController?.addAction(cancelAction)
        guard let alertController = alertController else {return}
        present(alertController, animated: true)
    }
    
    // Presents a message to the user via alert
    func presentBasicAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
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
    
    func presentDeleteAlert(activity: Activity) {
        let alertController = UIAlertController(title: "Delete Activity", message: "Are you sure you want to delete this activity? This will remove the activity from any logs it has been applied too.", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "I'm Sure", style: .destructive) { (_) in
            let feedback = UINotificationFeedbackGenerator()
            feedback.prepare()
            ActivityController.shared.deleteActivity(activity: activity, completion: { (success) in
                DispatchQueue.main.async {
                    if success {
                        feedback.notificationOccurred(.success)
                        self.activityTableView.reloadData()
                    } else {
                        feedback.notificationOccurred(.error)
                        self.presentBasicAlert(title: "Error", message: "Unable to delete activity from ICloud")
                    }
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true)
    }
    
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
                feedback.prepare()
                let oldTitle = activity.title
                activity.title = activityTitle
                ActivityController.shared.updateActivities(activities: [activity], completion: { (success) in
                    DispatchQueue.main.async {
                        if success {
                            feedback.notificationOccurred(.success)
                            self.activityTableView.reloadData()
                        } else {
                            feedback.notificationOccurred(.error)
                            self.presentBasicAlert(title: "Error", message: "Unable to update ICloud")
                            activity.title = oldTitle
                        }
                    }
                })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(renameAction)
        present(alertController, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "showActivity" {
//
//            if let index = activityTableView.indexPathForSelectedRow {
//
//                guard let destinationVC = segue.destination as? ActivityDetailViewController else {return}
//
//                let activity = ActivityController.shared.activities[index.row]
//                destinationVC.activity = activity
//            }
//        }
//    }
} // End Class

extension ActivitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ActivityController.shared.activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = activityTableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath) as? ActivityForActivityViewTableViewCell else {return UITableViewCell()}
        
        let activity = ActivityController.shared.activities[indexPath.row]
        
        cell.activity = activity
        return cell
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let activityToDelete = ActivityController.shared.activities[indexPath.row]
//            let feedback = UINotificationFeedbackGenerator()
//            feedback.prepare()
//            ActivityController.shared.deleteActivity(activity: activityToDelete) { (success) in
//                DispatchQueue.main.async {
//                    if success {
//                        feedback.notificationOccurred(.success)
//                        tableView.deleteRows(at: [indexPath], with: .fade)
//                    } else {
//                        self.errorAlert(message: "Error Deleting Form Database")
//                    }
//                }
//            }
//        }
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activity = ActivityController.shared.activities[indexPath.row]
        let feedback = UISelectionFeedbackGenerator()
        feedback.selectionChanged()
        presentActivitySelectionAlert(activity: activity)
    }
}
