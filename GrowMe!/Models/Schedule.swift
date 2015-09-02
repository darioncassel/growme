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
    
    
    let sizeArray = ["Seed", "Sapling", "Medium", "Large"]
    let typeArray = ["Succulent", "Tree/Shrub", "Edible", "Flowering"]
    let lightArray = ["Shade", "Partial", "Mostly", "Full"]
    
    dynamic var freq = List<Day>()
    
    convenience init(size: String, type: String, light: String, firstDay: Int) {
        self.init()
        
        var x = intMatcher(size, array: sizeArray)
        var y = intMatcher(type, array: typeArray)
        var z = intMatcher(light, array: lightArray)
        
        var freq = Int(y*z)                         // Days per week
        var amt = (x+0.1)*log(y*z+1)                      // Amout of water in oz

        for x in 0...freq {
            let num = (firstDay + freq*x)%7
            let thisDay = Day(number: num, complete: false, amount: amt)
            self.freq.append(thisDay)
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