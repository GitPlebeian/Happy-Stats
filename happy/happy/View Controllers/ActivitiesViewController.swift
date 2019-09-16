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

    // MARK: - Properties

    var alertController: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityTableView.separatorStyle = .none
        activitiesNavigationBar.barTintColor = .white
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
                            self.errorAlert(message: "Error Saving To Database. Sorry, I'm working on it")
                        }
                    }
                })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addActivityAction.isEnabled = false
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        addActivityAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alertController?.addAction(addActivityAction)
        alertController?.addAction(cancelAction)
        guard let alertController = alertController else {return}
        present(alertController, animated: true)
    }
    
    // Presents a message to the user via alert
    func errorAlert(message: String) {
        alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController?.addAction(okAction)
        guard let alertController = alertController else {return}
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let activityToDelete = ActivityController.shared.activities[indexPath.row]
            let feedback = UINotificationFeedbackGenerator()
            feedback.prepare()
            ActivityController.shared.deleteActivity(activity: activityToDelete) { (success) in
                DispatchQueue.main.async {
                    if success {
                        feedback.notificationOccurred(.success)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    } else {
                        self.errorAlert(message: "Error Deleting Form Database")
                    }
                }
            }
        }
    }
}
