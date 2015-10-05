//
//  DateHelper.swift
//  GrowMe!
//
//  Created by Darion Cassel on 9/4/15.
//  Copyright (c) 2015 Darion Cassel. All rights reserved.
//

import Foundation

class DateHelper {
    
    static func today() -> Int {
        return NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!.components(.Weekday, fromDate: NSDate()).weekday - 1
    }
    
}
