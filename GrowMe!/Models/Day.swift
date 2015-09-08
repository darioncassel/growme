//
//  Day.swift
//  GrowMe!
//
//  Created by Darion Cassel on 8/26/15.
//  Copyright (c) 2015 Darion Cassel. All rights reserved.
//

import Foundation
import RealmSwift

class Day: Object {
    
    dynamic var name: String = ""
    dynamic var number: Int = 0
    dynamic var complete: Bool = false
    dynamic var notified: Bool = false
    dynamic var amount: Double = 0

    let dayArr = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    convenience init(number: Int, complete: Bool, amount: Double) {
        self.init()
        self.name = dayArr[number]
        self.number = number
        self.complete = complete
        self.amount = amount
    }
    
}