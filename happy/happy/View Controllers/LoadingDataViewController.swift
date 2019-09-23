//
//  LoadingDataViewController.swift
//  happy
//
//  Created by Jackson Tubbs on 9/20/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class LoadingDataViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var loadingDataStackView: UIStackView!
    @IBOutlet weak var loadingDataLabel: UILabel!
    
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
        loadData()
        DarkModeController.shared.loadFromPersistentStore {
            updateViews()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideLoadingDataStackView()
    }
    
    // MARK: - Custom Functions
    
    func updateViews() {
        setNeedsStatusBarAppearanceUpdate()
        if DarkModeController.shared.darkMode.enabled {
            
        } else {
            loadingDataLabel.textColor = .black
        }
    }
    
    func presentErrorAlert() {
        let alertController = UIAlertController(title: "Error", message: "Unable To retreive data", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func loadData() {
        LoadDataController.loadAllData { (loadedAllData) in
            DispatchQueue.main.async {
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                if loadedAllData {
                    var viewController: UIViewController
                    viewController = mainStoryboard.instantiateViewController(withIdentifier: "mainTabBar")
                    viewController.modalPresentationStyle = .fullScreen
                    self.present(viewController, animated: true, completion: nil)
                } else {
                    self.presentErrorAlert()
                    self.hideLoadingDataStackView()
                }
            }
        }
    }
    
    func hideLoadingDataStackView() {
        UIView.animate(withDuration: 0.1, animations: {
            self.loadingDataStackView.alpha = 0.0
        }, completion: { (success) in
            if success {
                self.loadingDataStackView.isHidden = true
            }
        })
    }
    func showLoadingDataStackView() {
        self.loadingDataStackView.isHidden = false
        UIView.animate(withDuration: 0.15, animations: {
            self.loadingDataStackView.alpha = 0.0
        })
    }
}
