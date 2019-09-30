//
//  happinessColorEnums.swift
//  happy
//
//  Created by Jackson Tubbs on 8/19/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import UIKit

class ColorHelper {
    
    static private let zero = UIColor(red:1.00, green:1, blue:0.34, alpha:1.0)
    static private let one = UIColor(red:0.93, green:1, blue:0.35, alpha:1.0)
    static private let two = UIColor(red:0.87, green:1, blue:0.36, alpha:1.0)
    static private let three = UIColor(red:0.80, green:1, blue:0.36, alpha:1.0)
    static private let four = UIColor(red:0.73, green:1, blue:0.37, alpha:1.0)
    static private let five = UIColor(red:0.66, green:1, blue:0.38, alpha:1.0)
    static private let six = UIColor(red:0.60, green:1, blue:0.39, alpha:1.0)
    static private let seven = UIColor(red:0.53, green:1, blue:0.39, alpha:1.0)
    static private let eight = UIColor(red:0.46, green:1, blue:0.40, alpha:1.0)
    static private let nine = UIColor(red:0.40, green:1, blue:0.41, alpha:1.0)
    static private let ten = UIColor(red:0.30, green:1, blue:0.42, alpha:1.0)
    
    static func getColorFoInt(number: Int) -> UIColor {
        switch number {
        case 0:
            return ColorHelper.zero
        case 1:
            return ColorHelper.one
        case 2:
            return ColorHelper.two
        case 3:
            return ColorHelper.three
        case 4:
            return ColorHelper.four
        case 5:
            return ColorHelper.five
        case 6:
            return ColorHelper.six
        case 7:
            return ColorHelper.seven
        case 8:
            return ColorHelper.eight
        case 9:
            return ColorHelper.nine
        case 10:
            return ColorHelper.ten
        default:
            return UIColor.white
        }
    }
}
