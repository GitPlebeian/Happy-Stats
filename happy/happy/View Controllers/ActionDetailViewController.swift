//
//  ThingDetailViewController.swift
//  happy
//
//  Created by Jackson Tubbs on 8/3/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class ActionDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var actionNameTextField: UITextField!
    
    // Receivers
    var action: Action? {
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
        if let action = action {
            self.title = action.name
        } else {
            self.title = "New Action"
        }
    }
    
    // MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        // Checks to make sure that there is a value inside of the text field
        guard let actionName = actionNameTextField.text else {return}
        if actionName.isEmpty {return}
        
        if let action = action {
            // Will update existing thing name if a thing object is loaded
            ActionController.shared.updateExistingAction(action: action, name: actionName)
        } else {
            // Will create a new thing if there is no thing object loaded in the receiver
            ActionController.shared.createAction(name: actionName)
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Functions
    
    func updateView() {
        loadViewIfNeeded()
        actionNameTextField.text = action?.name
    }
    
} // End Class
