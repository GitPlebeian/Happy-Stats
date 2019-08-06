//
//  LogDetailViewController.swift
//  happy
//
//  Created by Jackson Tubbs on 8/4/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class LogDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var actionsTableView: UITableView!
    
    
    // Reveivers
    
    var log: Log? {
        didSet {
            updateView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Functions
    
    func updateView() {
        loadViewIfNeeded()
        guard let log = log else {return}
        
        // Sets the label as the logs date
        let format = DateFormatter()
        format.dateFormat = "MM-dd-yyy"
        dateLabel.text = format.string(from: log.date)
        
        // Sets the happiness level label
        ratingLabel.text = String(log.rating)
    }
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let log = log else {return 0}
        return log.actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let log = log else {return UITableViewCell()}
        let cell = actionsTableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath)
        
        cell.textLabel?.text = log.actions[indexPath.row].name
        
        return cell
    }
}
