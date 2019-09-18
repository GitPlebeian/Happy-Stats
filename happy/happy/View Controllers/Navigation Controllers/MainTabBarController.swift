//
//  MainTabBarController.swift
//  happy
//
//  Created by Jackson Tubbs on 8/3/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 1
        guard let tabBarItems = tabBar.items else {return}
        var index = 0
        for item in tabBarItems {
            // Diables the titles of tab bar icons and centers the images
            item.title = ""
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            
            // Sets the selected image of all the icons
            switch index {
            case 0:
                item.selectedImage = UIImage(named: "reportIconDark")
            case 1:
                item.selectedImage = UIImage(named: "calendarIconDark")
            case 2:
                item.selectedImage = UIImage(named: "menuIconDark")
            default:
                print("Extra Tab Bar With No Selection Image")
            }
            index += 1
        }
        LogController.shared.fetchAllLogs { (success) in
            if success && ActivityController.shared.activities.count > 0 {
                LogController.shared.pairLogsAndActivities()
            }
        }
        ActivityController.shared.fetchAllActivities { (success) in
            if success && LogController.shared.logs.count > 0 {
                LogController.shared.pairLogsAndActivities()
            }
        }
    }
} // End of Class
