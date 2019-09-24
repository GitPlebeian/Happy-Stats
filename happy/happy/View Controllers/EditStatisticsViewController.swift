//
//  EditStatisticsViewController.swift
//  happy
//
//  Created by Jackson Tubbs on 9/24/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class EditStatisticsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var averagePeriodTextField: UITextField!
    @IBOutlet weak var comparingPeriodTextField: UITextField!
    
    // MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Actions
    
    
    // MARK: - Custom Functions

    func updateViews() {
        self.view.backgroundColor = .white
        if var textAttributes = navigationController?.navigationBar.titleTextAttributes {
            textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.black
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        }
    }
}
