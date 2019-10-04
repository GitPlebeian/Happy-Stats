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
import Network

class LoadingDataViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var loadingDataStackView: UIStackView!
    @IBOutlet weak var loadingDataLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicatorLoadingData: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    var connectedToICloud = true
    var couldntConnect = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateICloudAvailable()
        if connectedToICloud == true {
            loadData()
        }
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
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        loadData()
        loadingDataLabel.isHidden = false
        activityIndicatorLoadingData.isHidden = false
        refreshButton.isHidden = true
    }
    
    // MARK: - Custom Functions
    
    func updateViews() {
        setNeedsStatusBarAppearanceUpdate()
        loadingDataLabel.textColor = .black
    }
    
    // Presents alert telling the user that they need to sign into icloud in order for the app to work
    func presentSignInToICloudAlert() {
        let alertController = UIAlertController(title: "iCloud", message: "This app uses iCloud to sync data across your devices. All data will not be saved unless you sign in to iCloud and enable iCloud Drive", preferredStyle: .alert)
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
    
    func presentInternetAlert() {
        let alertController = UIAlertController(title: "Internet Connection", message: "Internet connection is not working. Please try again", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
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
                    self.presentBasicAlert(title: "Error", message: "Unable to get data from iCloud. Please try again in 10 seconds")
                    self.hideLoadingDataStackView()
                    self.showLoadingDataStackView()
                    self.refreshButton.isHidden = false
                    self.activityIndicatorLoadingData.isHidden = true
                    self.loadingDataLabel.isHidden = true
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
