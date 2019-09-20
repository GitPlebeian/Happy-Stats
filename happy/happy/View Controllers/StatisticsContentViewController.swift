//
//  StatisticsContentViewController.swift
//  happy
//
//  Created by Jackson Tubbs on 9/20/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class StatisticsContentViewController: UIViewController {

    @IBOutlet weak var thing: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = 0
        thing.backgroundColor = ColorHelper.getColorFoInt(number: color)
        if ColorHelper.getColorFoInt(number: color).useDarkText() {
            print("Use dark text")
        } else {
            print("Use Light text")
        }
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
