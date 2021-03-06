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
    dynamic var useWeather: Bool = false
    dynamic var notify: Bool = true
    dynamic var created: String = "Jan 1, 1970, 12:00 AM"
    dynamic var schedule: Schedule?
    let completed: List<Day> = List<Day>()
    
    var weatherEffects: Dictionary<Int, (Bool, Int)>? {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                autoreleasepool {
                    let realm = try! Realm()
                    realm.write() {
                        self.schedule = Schedule(size: self.size, type: self.type, light: self.light, location: self.location, firstDay: self.firstDay, weatherEffects: self.weatherEffects, completed: self.completed)
                        realm.add(self)
                    }
                }
            }
        }
    }
    
    func getDay(dayNum: Int) -> (Bool, Double)? {
        if let schedule = schedule {
            for day in schedule.freq {
                if day.number == dayNum {
                    return (day.complete.boolValue, Double(day.amount))
                }
            }
        }
        return nil
    }
    
    func dayToggle(dayNum: Int, callback: (Bool) -> ()) {
        if let schedule = schedule {
            for day in schedule.freq {
                if dayNum == day.number {
                    if day.complete {
                        dispatch_async(dispatch_get_main_queue()) {
                            autoreleasepool {
                                let realm = try! Realm()
                                realm.write() {
                                    day.complete = false
                                    for x in self.completed {
                                        if x.number == dayNum {
                                            let index = self.completed.indexOf(x)
                                            if let index = index {
                                                self.completed.removeAtIndex(index)
                                            }
                                        }
                                    }
                                    realm.add(self)
                                }
                            }
                            callback(day.complete)
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                            autoreleasepool {
                                let realm = try! Realm()
                                let thisDay = Day(number: dayNum, complete: true, amount: 0.0)
                                realm.write() {
                                    day.complete = true
                                    self.completed.append(thisDay)
                                    realm.add(self)
                                }
                            }
                            callback(day.complete)
                        }
                    }
                }
            }
        }
    }
    
}

