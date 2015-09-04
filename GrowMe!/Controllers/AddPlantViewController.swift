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
                    WeatherHelper.getWeatherInfo(plant, zip: plant.zipcode) { weatherEffects in
                        plant.weatherEffects = weatherEffects
                    }
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
    
        
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as! EditPlantViewController
        destinationViewController.plant = self.plant
        destinationViewController.leftButton.title = "Discard"
    }

}
