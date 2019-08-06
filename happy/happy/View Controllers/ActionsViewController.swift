//
//  ThingsViewController.swift
//  happy
//
//  Created by Jackson Tubbs on 8/3/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class ActionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - Outlets
    @IBOutlet weak var actionsTableView: UITableView!
    
    
    // MARK: - Properties


    override func viewDidLoad() {
        super.viewDidLoad()
        actionsTableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        actionsTableView.reloadData()
        ActionController.shared.calculateHappinessForActions()
        actionsTableView.estimatedRowHeight = UITableView.automaticDimension
//        thingTableView.rowHeight = 100
    }
    
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ActionController.shared.actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = actionsTableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath) as? ActionsViewTableViewCell else {return UITableViewCell()}
        
        let action = ActionController.shared.actions[indexPath.row]
        
        cell.action = action
        cell.backgroundColor = UIColor(displayP3Red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        cell.layer.borderColor = UIColor(displayP3Red: 0.85, green: 0.85, blue: 0.85, alpha: 1).cgColor
        cell.layer.borderWidth = 0.5
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ActionController.shared.deleteAction(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showAction" {

            if let index = actionsTableView.indexPathForSelectedRow {

                guard let destinationVC = segue.destination as? ActionDetailViewController else {return}

                let action = ActionController.shared.actions[index.row]
                destinationVC.action = action
            }
        }
    }
} // End Class
