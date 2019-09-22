//
//  ReportsViewController.swift
//  happy
//
//  Created by Jackson Tubbs on 8/15/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    // MARK: - Outlets
    
    
    // MARK: - Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let settings = SettingsController.shared.settings else {return .lightContent}
        if settings.darkMode == true {
            return .lightContent
        } else {
            if #available(iOS 13.0, *) {
                return .darkContent
            } else {
                return .default
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
