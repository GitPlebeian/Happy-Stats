//
//  HistoricalLogsViewController.swift
//  happy
//
//  Created by Jackson Tubbs on 8/10/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class HistoricalLogsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var logsTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LogController.shared.logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = logsTableView.dequeueReusableCell(withIdentifier: "logCell", for: indexPath)
        let log = LogController.shared.logs[indexPath.row]
        guard let date = log.date, let activityCount = log.activities?.count else {return UITableViewCell()}
        
        let format = DateFormatter()
        format.dateFormat = "MM-dd-yyyy"
        
        cell.textLabel?.text = format.string(from: date)
        cell.detailTextLabel?.text = String(activityCount)
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let logToDelete = LogController.shared.logs[indexPath.row]
            LogController.shared.deleteLog(log: logToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLog" {
            guard let index = logsTableView.indexPathForSelectedRow, let destinationViewController = segue.destination as? LogDetailViewController else {return}
            let log = LogController.shared.logs[index.row]
            destinationViewController.log = log
        }
    }
}
