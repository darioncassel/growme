//
//  Plant.swift
//  GrowMe!
//
//  Created by Darion Cassel on 8/10/15.
//  Copyright (c) 2015 Darion Cassel. All rights reserved.
//

import Foundation
import RealmSwift

class Plant: Object {
    
    dynamic var name: String = "Unnamed Plant"
    dynamic var size: String = ""
    dynamic var type: String = ""
    dynamic var location: String = ""
    dynamic var light: String = ""
    dynamic var firstDay: Int = 0
    dynamic var zipcode: String = ""
    dynamic var cityid: String = ""
    dynamic var notify: Bool = true
    dynamic var created: String = "Jan 1, 1970, 12:00 AM"
    
    dynamic var schedule = Schedule()
    
}

