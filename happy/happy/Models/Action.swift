//
//  thing.swift
//  happy
//
//  Created by Jackson Tubbs on 8/3/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation

class Action: Codable {
    
    var name: String
    var isSelected: Bool
    var averageRating: Double
    
    init(name: String) {
        self.name = name
        self.isSelected = false
        self.averageRating = -1000
    }
} // Class End

extension Action: Equatable {
    static func == (lhs: Action, rhs: Action) -> Bool {
        return
            lhs.name == rhs.name &&
            lhs.averageRating == rhs.averageRating
    }
}
