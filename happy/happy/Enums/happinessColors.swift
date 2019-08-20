//
//  happinessColorEnums.swift
//  happy
//
//  Created by Jackson Tubbs on 8/19/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import UIKit

class happinessColors {
    
    static private let zero = UIColor(red:1.00, green:0.34, blue:0.34, alpha:1.0)
    static private let one = UIColor(red:1.00, green:0.47, blue:0.34, alpha:1.0)
    static private let two = UIColor(red:0.99, green:0.60, blue:0.34, alpha:1.0)
    static private let three = UIColor(red:0.99, green:0.73, blue:0.34, alpha:1.0)
    static private let four = UIColor(red:0.99, green:0.87, blue:0.34, alpha:1.0)
    static private let five = UIColor(red:0.99, green:1.00, blue:0.34, alpha:1.0)
    static private let six = UIColor(red:0.85, green:1.00, blue:0.35, alpha:1.0)
    static private let seven = UIColor(red:0.72, green:1.00, blue:0.37, alpha:1.0)
    static private let eight = UIColor(red:0.59, green:1.00, blue:0.38, alpha:1.0)
    static private let nine = UIColor(red:0.46, green:1.00, blue:0.40, alpha:1.0)
    static private let ten = UIColor(red:0.33, green:1.00, blue:0.42, alpha:1.0)
    
    
    static func getColorFoInt(number: Int) -> UIColor {
        switch number {
        case 0:
            return happinessColors.zero
        case 1:
            return happinessColors.one
        case 2:
            return happinessColors.two
        case 3:
            return happinessColors.three
        case 4:
            return happinessColors.four
        case 5:
            return happinessColors.five
        case 6:
            return happinessColors.six
        case 7:
            return happinessColors.seven
        case 8:
            return happinessColors.eight
        case 9:
            return happinessColors.nine
        case 10:
            return happinessColors.ten
        default:
            return UIColor.clear
        }
    }
    /*
     0:FF5757
     1:FE7857
     2:FD9A57
     3:FDBB57
     4:FCDD57
     5:FCFF57
     6:DAFF5A
     7:B8FF5E
     8:97FF62
     9:75FF66
     10:54FF6A
    */
}
