//
//  DarkMode.swift
//  happy
//
//  Created by Jackson Tubbs on 9/23/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation

class DarkMode: Codable {
    
    var enabled: Bool
    
    init(enabled: Bool) {
        self.enabled = enabled
    }
}
