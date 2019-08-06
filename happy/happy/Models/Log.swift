//
//  log.swift
//  happy
//
//  Created by Jackson Tubbs on 8/3/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation

class Log: Codable {
    
    var rating: Int
    var actions: [Action]
    var date: Date
    
    init(rating: Int, actions: [Action], date: Date) {
        self.rating = rating
        self.actions = actions
        self.date = date
    }
} // Class End

extension Log: Equatable {
    static func == (lhs: Log, rhs: Log) -> Bool {
        return
            lhs.rating == rhs.rating &&
            lhs.date == rhs.date &&
            lhs.actions == rhs.actions
    }
}
