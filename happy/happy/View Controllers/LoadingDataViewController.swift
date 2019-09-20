//
//  LoadingDataViewController.swift
//  happy
//
//  Created by Jackson Tubbs on 9/20/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class LoadingDataViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        LoadDataController.loadAllData { (loadedAllData) in
            DispatchQueue.main.async {
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                if loadedAllData {
                    var viewController: UIViewController
                    viewController = mainStoryboard.instantiateViewController(withIdentifier: "mainTabBar")
                    self.present(viewController, animated: true, completion: nil)
                } else {
                    self.presentErrorAlert()
                }
            }
        }
    }
    
    // MARK: - Custom Functions
    
    func presentErrorAlert() {
        
    }
}
