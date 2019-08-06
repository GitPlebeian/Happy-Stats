//
//  HistoricalRatingsViewController.swift
//  happy
//
//  Created by Jackson Tubbs on 8/4/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class HistoricalRatingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    // MARK: - Outlets
    
    @IBOutlet weak var logTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logTableView.reloadData()
    }
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LogController.shared.logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = logTableView.dequeueReusableCell(withIdentifier: "logCell", for: indexPath)
        let log = LogController.shared.logs[indexPath.row]
        
        // Populate the cell with data
        let format = DateFormatter()
        format.dateFormat = "MM-dd-yyyy"
        cell.textLabel?.text = format.string(from: log.date)
        cell.detailTextLabel?.text = String(log.rating)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            LogController.shared.deleteLog(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLog" {
    
            if let indexOfLog = logTableView.indexPathForSelectedRow {
                guard let destinationVC = segue.destination as? LogDetailViewController else {return}
                let log = LogController.shared.logs[indexOfLog.row]
                destinationVC.log = log
            }
        }
    }
} // End of class
