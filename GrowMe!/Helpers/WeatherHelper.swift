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
            
            let jsonResult = (try! NSJSONSerialization.JSONObjectWithData(data!, options: [])) as! NSDictionary
            
            let id = jsonResult.valueForKey("id") as! NSNumber
            let cityid = id.stringValue
            
            if cityid != "" {
                
                let cityurl = NSURL(string: "http://api.openweathermap.org/data/2.5/forecast/daily?id=\(cityid)&cnt=7&APPID=\(APIkeys().openweathermap)")
                NSURLSession.sharedSession().dataTaskWithURL(cityurl!) { data, response, error in
                    
                    let jsonResult = (try! NSJSONSerialization.JSONObjectWithData(data!, options: [])) as! NSDictionary
                    
                    let dayNum = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!.components(.Weekday, fromDate: NSDate()).weekday - 1
                    
                    let weather = jsonResult.valueForKey("list") as! NSArray
                    var weatherEffects = Dictionary<Int, (Bool, Int)>()
                    
                    for i in dayNum...6 {
                        let day = weather[i] as! NSDictionary
                        let rain = self.isRain(day.valueForKey("weather")!.valueForKey("main")![0] as! String)
                        let humidity = day.valueForKey("humidity")! as! Int
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