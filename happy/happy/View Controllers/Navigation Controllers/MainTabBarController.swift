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
            // Disables the titles of tab bar icons and centers the images
            item.title = ""
            if #available(iOS 13, *) {
                item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            } else {
                item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            }
            // Sets the selected image of all the icons
            switch index {
            case 0:
                item.selectedImage = UIImage(named: "reportIconSelected")
                item.image = UIImage(named: "reportIcon")
            case 1:
                item.selectedImage = UIImage(named: "calendarIconSelected")
                item.image = UIImage(named: "calendarIcon")
            case 2:
                item.selectedImage = UIImage(named: "menuIconSelected")
                item.image = UIImage(named: "menuIcon")
            default:
                print("Extra Tab Bar With No Selection Image")
            }
            index += 1
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle == .light {
            self.tabBar.items?[0].image = UIImage(named: "reportIcon")
            self.tabBar.items?[0].selectedImage = UIImage(named: "reportIconSelected")
            self.tabBar.items?[1].image = UIImage(named: "calendarIcon")
            self.tabBar.items?[1].selectedImage = UIImage(named: "calendarIconSelected")
            self.tabBar.items?[2].image = UIImage(named: "menuIcon")
            self.tabBar.items?[2].selectedImage = UIImage(named: "menuIconSelected")
        } else {
            self.tabBar.items?[0].image = UIImage(named: "reportIconDarkMode")
            self.tabBar.items?[0].selectedImage = UIImage(named: "reportIconSelectedDarkMode")
            self.tabBar.items?[1].image = UIImage(named: "calendarIconDarkMode")
            self.tabBar.items?[1].selectedImage = UIImage(named: "calendarIconSelectedDarkMode")
            self.tabBar.items?[2].image = UIImage(named: "menuIconDarkMode")
            self.tabBar.items?[2].selectedImage = UIImage(named: "menuIconSelectedDarkMode")
        }
    }
} // End of Class
