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
    
    @IBOutlet weak var settingsBarButtonItem: UIBarButtonItem!
    
    // MARK: - Properties
    
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - A
    
    // MARK: - Custom Functions
    
    func updateViews() {
        var titleColor: UIColor = UIColor.black
        if DarkModeController.shared.darkMode.enabled {
            titleColor = .white
        } else {
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.tintColor = .white
        }
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Light", size: 17)!, NSAttributedString.Key.foregroundColor : titleColor]
        settingsBarButtonItem.image = UIImage(named: "deleteIcon")
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
