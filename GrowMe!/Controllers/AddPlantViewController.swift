//
//  AddPlantViewController.swift
//  GrowMe!
//
//  Created by Darion Cassel on 8/10/15.
//  Copyright (c) 2015 Darion Cassel. All rights reserved.
//

import UIKit
import RealmSwift

class AddPlantViewController: UIViewController {
    
    var plant: Plant?

    @IBOutlet weak var zipcode: UITextField!
    @IBOutlet weak var notValid: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPlant(sender: AnyObject) {
        if sender.titleLabel!!.text == "Ok" {
            if validateZipcode(zipcode.text) == 1 {
                if let plant = plant {
                    plant.zipcode = zipcode.text
                    getWeatherInfo(plant, zip: plant.zipcode)
                }
                self.performSegueWithIdentifier(self.restorationIdentifier, sender: self)
            } else {
                notValid.hidden = false
            }
        } else if sender.titleLabel!!.text == "No thanks" {
            self.performSegueWithIdentifier(self.restorationIdentifier, sender: self)
        }
    }
    
    func validateZipcode(zip: String) -> Int {
        let pattern =  NSRegularExpression(pattern: "(^[0-9]{5}(-[0-9]{4})?$)", options: NSRegularExpressionOptions.allZeros, error: NSErrorPointer())
        return pattern!.numberOfMatchesInString(zip, options: NSMatchingOptions.allZeros, range: NSMakeRange(0, count(zip)))
    }
    
    func getWeatherInfo(plant: Plant, zip: String) {
        
        let zipurl = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?zip=\(zip),us&APPID=\(APIkeys().openweathermap)")
        NSURLSession.sharedSession().dataTaskWithURL(zipurl!) { data, response, error in
            
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: NSErrorPointer()) as! NSDictionary
            
            var id = jsonResult.valueForKey("id") as! NSNumber
            plant.cityid = id.stringValue
            
            if plant.cityid != "" {
                
                let cityurl = NSURL(string: "http://api.openweathermap.org/data/2.5/forecast/daily?id=\(plant.cityid)&cnt=7&APPID=\(APIkeys().openweathermap)")
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
                    
                }.resume()
            }
        }.resume()
    }
    
    func isRain(condition: String) -> Bool {
        if condition == "Rain" {
            return true
        }
        return false
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as! EditPlantViewController
        destinationViewController.plant = self.plant
        destinationViewController.leftButton.title = "Discard"
    }

}
