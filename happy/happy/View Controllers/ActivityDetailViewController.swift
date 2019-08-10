//
//  ThingDetailViewController.swift
//  happy
//
//  Created by Jackson Tubbs on 8/3/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class ActivityDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var activityTitleTextField: UITextField!
    
    
    // Receivers
    var activity: Activity? {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.tabBarItem.image = UIImage(named: "reportIcon")
        if let activity = activity {
            self.title = activity.title
        } else {
            self.title = "New Activity"
        }
    }
    
    // MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        // Checks to make sure that there is a value inside of the text field
        guard let activityTitle = activityTitleTextField.text else {return}
        if activityTitle.isEmpty {return}
        
        if let activity = activity {
            // Will update existing thing name if a thing object is loaded
//            ActivityController.shared.updateExistingAction(action: action, name: actionName)
        } else {
            // Will create a new thing if there is no thing object loaded in the receiver
            ActivityController.shared.createActivity(title: activityTitle)
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Functions
    
    func updateView() {
        loadViewIfNeeded()
        activityTitleTextField.text = activity?.title
    }
    
} // End Class
