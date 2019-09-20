//
//  UIColorExtensions.swift
//  happy
//
//  Created by Jackson Tubbs on 9/20/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

extension UIColor {
    func useDarkText() -> Bool {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            let calculation = (red * 299 * 255 + green * 587 * 255 + blue * 114 * 255) / 1000
            if calculation < 125 {
                return false
            } else {
                return true
            }
        }
        return true
    }
}
