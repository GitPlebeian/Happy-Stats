//
//  LoadingDataViewController.swift
//  happy
//
//  Created by Jackson Tubbs on 9/20/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit
import CloudKit
import Foundation

class LoadingDataViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var loadingDataStackView: UIStackView!
    @IBOutlet weak var loadingDataLabel: UILabel!
    
    // MARK: - Properties
    
    var connectedToICloud = true
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateICloudAvailable()
        if connectedToICloud == true {
            loadData()
        }
        DarkModeController.shared.loadFromPersistentStore()
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideLoadingDataStackView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if connectedToICloud == false{
            presentSignInToICloudAlert()
        } else {
            showLoadingDataStackView()
        }
    }
    
    // MARK: - Custom Functions
    
    func updateViews() {
        setNeedsStatusBarAppearanceUpdate()
        if DarkModeController.shared.darkMode.enabled {
            
        } else {
            loadingDataLabel.textColor = .black
        }
    }
    
    // Presents alert telling the user that they need to sign into icloud in order for the app to work
    func presentSignInToICloudAlert() {
        let alertController = UIAlertController(title: "ICloud", message: "This app uses ICloud to sync data across your devices. All data will not be saved unless you sign in to ICloud", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            var viewController: UIViewController
            viewController = mainStoryboard.instantiateViewController(withIdentifier: "mainTabBar")
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func updateICloudAvailable() {
        if FileManager.default.ubiquityIdentityToken == nil {
            connectedToICloud = false
        }
    }
    
    func presentBasicAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    // Will load all data from user's iCloud
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
                    self.presentBasicAlert(title: "Error", message: "Unable to get data from iCloud")
                    self.hideLoadingDataStackView()
                }
            }
        }
    }
    
    // Fades out loading data view
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
            self.loadingDataStackView.alpha = 1.0
        })
    }
}
