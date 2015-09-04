//
//  WeatherHelper.swift
//  GrowMe!
//
//  Created by Darion Cassel on 9/3/15.
//  Copyright (c) 2015 Darion Cassel. All rights reserved.
//

import Foundation
import RealmSwift

class WeatherHelper {
    
    static func getWeatherInfo(plant: Plant, zip: String, callback: (Dictionary<Int, (Bool, Int)>) -> ())  {
        
        let zipurl = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?zip=\(zip),us&APPID=\(APIkeys().openweathermap)")
        NSURLSession.sharedSession().dataTaskWithURL(zipurl!) { data, response, error in
            
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: NSErrorPointer()) as! NSDictionary
            
            var id = jsonResult.valueForKey("id") as! NSNumber
            var cityid = id.stringValue
            
            if cityid != "" {
                
                let cityurl = NSURL(string: "http://api.openweathermap.org/data/2.5/forecast/daily?id=\(cityid)&cnt=7&APPID=\(APIkeys().openweathermap)")
                NSURLSession.sharedSession().dataTaskWithURL(cityurl!) { data, response, error in
                    
                    var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: NSErrorPointer()) as! NSDictionary
                    
                    var dayNum = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!.components(.CalendarUnitWeekday, fromDate: NSDate()).weekday - 1
                    
                    var weather = jsonResult.valueForKey("list") as! NSArray
                    var weatherEffects = Dictionary<Int, (Bool, Int)>()
                    
                    for i in dayNum...6 {
                        var day = weather[i] as! NSDictionary
                        var rain = self.isRain(day.valueForKey("weather")!.valueForKey("main")![0] as! String)
                        var humidity = day.valueForKey("humidity")! as! Int
                        weatherEffects[i] = (rain, humidity)
                    }
                    
                    callback(weatherEffects)
        
                }.resume()
            }
            
        }.resume()
        
    }
    
    static func isRain(condition: String) -> Bool {
        if condition == "Rain" {
            return true
        }
        return false
    }

}