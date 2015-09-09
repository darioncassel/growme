//
//  Schedule.swift
//  GrowMe!
//
//  Created by Darion Cassel on 8/26/15.
//  Copyright (c) 2015 Darion Cassel. All rights reserved.
//

import Foundation
import RealmSwift

class Schedule: Object {
    
    let sizeArray = ["Seed", "Small", "Medium", "Large"]
    let typeArray = ["Succulent", "Tree/Shrub", "Edible", "Flowering"]
    let lightArray = ["Shade", "Partial", "Mostly", "Full"]
    
    dynamic var freq = List<Day>()
    
    convenience init(size: String, type: String, light: String, location: String, firstDay: Int, weatherEffects: Dictionary<Int, (Bool, Int)>?, completed: List<Day>?) {
        self.init()
        
        var size = intMatcher(size, array: sizeArray)
        var type = intMatcher(type, array: typeArray)
        var light = intMatcher(light, array: lightArray)

        var freq = Int(type*light)                               // Days per week
        var amt = (size+0.5)*log((type+1)*(light+1))             // Amout of water in oz

        for x in 0...freq {
            let num = (firstDay + freq*x + 1)%7
            let thisDay = Day(number: num, complete: false, amount: amt)
            self.freq.append(thisDay)
        }
        
        if let completed = completed {
            for x in completed {
                for day in self.freq {
                    if x.number == day.number {
                        day.complete = true
                    }
                }
            }
        }
        
        if location == "Outdoors" {
            if let weatherEffects = weatherEffects {
                for num in weatherEffects.keys {
                    for day in self.freq {
                        var dayNum = day.valueForKey("number") as! Int
                        if num == dayNum {
                            var amt = day.valueForKey("amount") as! Int
                            amt *= (1-(weatherEffects[num]!.1/100))
                            day.setValue(amt, forKey: "amount")
                            if weatherEffects[num]!.0 {
                                day.setValue(0, forKey: "amount")
                                day.complete = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    func intMatcher(match: String, array: [String]) -> Double{
        for var i = 0; i < array.count; i++ {
            if match == array[i] {
                 return Double(i) + 0.1
            }
        }
        return Double(0.01)
    }
    
}