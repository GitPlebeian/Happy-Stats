//
//  ReportsViewController.swift
//  happy
//
//  Created by Jackson Tubbs on 8/15/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    
    // MARK: - Custom Functions
    
    func updateViews() {
        navigationController?.navigationBar.barTintColor = UIColor(named: "White")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Light", size: 17)!, NSAttributedString.Key.foregroundColor : UIColor(named: "Black")!]
    }
}
